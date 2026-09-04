Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43A8414A2A;
	Fri,  4 Sep 2026 05:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499551; cv=none; b=pcb7CAon3yL5LqvSs0STP0HXL2mK1d0kh0X2pUDYY/l5YueU8PRNUVR0MDMpRz6SgvqUo3k45LozeJOd+VYnafSubC9SDlhtMwhg1GEdmeUmmmcKtQf0fF4sZCj+hSSBbs9I7WBjwucxPHMEVmb/jGUbkh4SNGuTpIjwm+1KWVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499551; c=relaxed/simple;
	bh=0Bxukk9sL/Xuj/ZBtlLFFv2+/iwBDhSwZu+lW7y3+eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaXDr+Owm3K2Ipq9b6JIKVDxQy60kMf0jHqUHJtEXgTIz+PGKnrdi8hbb09qCOQKqO0beZNorLSbTcpB54uOLhm53agzHuERwy+QOD/Aa9BcroQnovFn5BR5iQxhZdQL/Y1yAbQ57O8kAuev8Xywv0DaOTtHO46Nv8/YK6BTgCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhHW4yiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhHW4yiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0795F1F00A3D;
	Fri,  4 Sep 2026 05:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499550;
	bh=B+urh7g7quAguJ2MkecY8xVJpAD47nl2paR8fs5zRxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IhHW4yiGC1bWxSUUJL886w4k4ca2idCvtuTQCn+UpXmzxz9yuAEP8bQjaZSO/O2FE
	 eNcu/J10Tl3Q/t0v5R5TdRgToqLAy2FP5vzeNOMw8Y2yAqHhv9seXIvXC4ITbmPsZw
	 fzattTWZxT0KYbEomAcVDnMbuTclKBhoBylch9pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 7.2 458/713] orangefs: fix double-free of trailer_buf on readdir copy failure
Date: Fri,  4 Sep 2026 06:57:06 +0200
Message-ID: <20260904045814.093012611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifei Gao <gyf161023@gmail.com>

commit f574296be7f46eb60beca851240b526df232f480 upstream.

On a readdir downcall, orangefs_devreq_write_iter() frees
op->downcall.trailer_buf with vfree() when copy_from_iter_full() fails,
but does not clear the pointer before goto Efault. The waiter in
do_readdir() is then woken with a negative status and frees the same
pointer again on its r < 0 path, causing a deterministic double-free.
A client holding /dev/pvfs2-req triggers it by sending a readdir
downcall whose declared trailer_size exceeds the bytes it supplies.

Clear the pointer after freeing so the readdir-side vfree() becomes a
no-op.

Fixes: 382f4581e67f ("orangefs: rewrite readdir to fix several bugs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/orangefs/devorangefs-req.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/orangefs/devorangefs-req.c
+++ b/fs/orangefs/devorangefs-req.c
@@ -474,6 +474,7 @@ static ssize_t orangefs_devreq_write_ite
 			         op->downcall.trailer_size, iter)) {
 		gossip_err("%s: failed to copy trailer.\n", __func__);
 		vfree(op->downcall.trailer_buf);
+		op->downcall.trailer_buf = NULL;
 		goto Efault;
 	}
 


