Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162DA3346BE;
	Thu,  2 Jul 2026 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011366; cv=none; b=d44ecyhkenIKJBQjU7NoC7RsgTP3/vxRbrZPvtYr4kCIXxOjUBJI9K8heezGikciGPW93bwJlUVCQbS1AH8/2mgdBub9XFZHQIQhBU4Ym73FRRWlFT8QkxZ02j+Fx536KsVI33nyScESt1zVr1acbtTcjBeQgwGcAACuQk7oBTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011366; c=relaxed/simple;
	bh=bLedU2NAXn9LJ2igyqVk0xIdW1g/iosbkESIkogLMxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sP6xWYof7rAF7xKXy1rcYg4CmEmoO12Zgky3rPtXSpWAIBVJCc1ng9aN6vzgITXMMIpolRJh1leJHdbyG8tFCKoUl/ywhaSB1F+bindOc3JAZmY14UB8hMCMuQvM/mU0fSlPFeaEGb+TvBfpwL/YrgO5378zLc+g+a0UkyBmn+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7tl+Hz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7tl+Hz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0931F000E9;
	Thu,  2 Jul 2026 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011365;
	bh=CdcaVC97xKe4B0YBWGGn+RdoZR9T27Im3oQ4GkmgtHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7tl+Hz+3AvDuUgNsxJRTO/RlIFN+RRCRk6DQZqQ8gRqVmCO4/4r/7z79ceK+PdM/
	 OFCqQSWxhwqa12aCDU7bpKrH8Mun7HJgdnH7sSbKkpLcfyEhhThZMmbrLuaczdpqKt
	 6EdcZ0JMYoNO3IwA+0X80xWQnFuvhP1gFNZJDcMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 080/108] pNFS: Fix use-after-free in pnfs_update_layout()
Date: Thu,  2 Jul 2026 18:21:17 +0200
Message-ID: <20260702155113.770291146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 13e198a90ca4050f4bee8a3f23680389a6563ccc upstream.

When hitting the NFS_LAYOUT_RETURN branch in pnfs_update_layout(),
the code calls pnfs_prepare_to_retry_layoutget(lo). If it succeeds,
pnfs_put_layout_hdr(lo) is called before trace_pnfs_update_layout(),
which still references 'lo'. This results in a use-after-free when the
tracepoint accesses lo's fields.

Fix this by moving the tracepoint call before pnfs_put_layout_hdr(lo).

Fixes: 2c8d5fc37fe2 ("pNFS: Stricter ordering of layoutget and layoutreturn")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2217,11 +2217,11 @@ lookup_again:
 		dprintk("%s wait for layoutreturn\n", __func__);
 		lseg = ERR_PTR(pnfs_prepare_to_retry_layoutget(lo));
 		if (!IS_ERR(lseg)) {
-			pnfs_put_layout_hdr(lo);
 			dprintk("%s retrying\n", __func__);
 			trace_pnfs_update_layout(ino, pos, count, iomode, lo,
 						 lseg,
 						 PNFS_UPDATE_LAYOUT_RETRY);
+			pnfs_put_layout_hdr(lo);
 			goto lookup_again;
 		}
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,


