Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5FA226549;
	Thu, 12 Dec 2024 16:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021746; cv=none; b=C1E4f+vOYr+OgLtXYoeJOxhhvnCxtmJQ8zBzDl3o0O1kapmIDFXMu9mINpZEByuvVRrU+if63OfVcu2IwtsTK1l6o2hsXlFE/jsiUf14YZNjsIcpcHz2n28FAnexdM1d2iKektqFMTHSyPGQeBoprdoOVMNFZl3nX8e/jG4L1G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021746; c=relaxed/simple;
	bh=/CiFBAqSP/hZBQQDJzaFhT5DTDC+sHoNZs4OgIvQah0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwlCCafDYJ/j3XpbNuOZONQ2eGQh1exsWBHhoDb2Bp+OzAKa1W5kmc4mbl3jES3xT9ZKMU3fjZ//9Toz75ewdhYRLFNf81tRpOD31v2t07kKZ1edlts+iwW0q2tuEiLPLJRXH364PTCckvM1Rp0Xr4BqpnIoVUjuRfHslTsQMYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7MEiyvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7MEiyvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BC4C4CECE;
	Thu, 12 Dec 2024 16:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021746;
	bh=/CiFBAqSP/hZBQQDJzaFhT5DTDC+sHoNZs4OgIvQah0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7MEiyvI37cQrq0Pyycfyj49qxIGao1qLhQ60ooBoPuG43TFVN/OQ+ny1eHTkSQLA
	 zYQLoXzVk1JWxvBtrhXgN+0cTOwj464BwSm8pa0ExM4OhcyeecXDSrW/ZAfvOOlgkc
	 7MOYiZYgx7d/xcH4pXhwdAgIHPRpFMpSytv7N8k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 050/565] NFS: nfs_async_write_reschedule_io must not recurse into the writeback code
Date: Thu, 12 Dec 2024 15:54:05 +0100
Message-ID: <20241212144313.473662478@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit b1a28f2eb9ea7a5a1763fe53fe699aa0feae4231 upstream.

It is not safe to call filemap_fdatawrite_range() from
nfs_async_write_reschedule_io(), since we're often calling from a page
reclaim context. Just let fsync() redrive the writeback for us.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/write.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1422,8 +1422,6 @@ static void nfs_async_write_error(struct
 static void nfs_async_write_reschedule_io(struct nfs_pgio_header *hdr)
 {
 	nfs_async_write_error(&hdr->pages, 0);
-	filemap_fdatawrite_range(hdr->inode->i_mapping, hdr->args.offset,
-			hdr->args.offset + hdr->args.count - 1);
 }
 
 static const struct nfs_pgio_completion_ops nfs_async_write_completion_ops = {


