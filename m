Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826967;
	b=o8kfI0dMhcYmp0UYWwNB8QajOq2SXriP0gWX2WOPDd8nX94FE3CFqQoB+Jz2nHFX7g/T
	 3ngytuxZUh1xfA3bxlFnPXPIDMv06iEf8ZvDZOTMQsrzraIMiEFjIbKlWDvPK6eMovNwN
	 P7ZGA8GeTyIQMN5NLQfHHFWTgxjp5TuEnxcn4wf1oWGXE5QUzeYZSKmJK9UJNnvs4P99R
	 Kz2fC6Fijg7f2KFKY0GDdcb6LKfiCUqm4q7JSMxnhjx9pVlrznStqBI6c4asnJQRws3OV
	 VeuLGsUu4Qwrp+mUAs6jATXM+5kutgwOJPFKbxlXmAUKGX2+jEOBHOqx5HToIVX+8jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RkaUJLucWOQzYxNEUwFeMsDORIegiA+pYfmE9t/ec50=;
	b=UaTKD+D9AW+R9iWnylQWUDpE/jhZaYE84fJGs8xER36RYJScIvTsMdNF+sxMKkOUCjv7
	 7NV0NTzSu/Wg/KD0ZeqAhR0D+bt+JyWCAlIOLpRkecHkca6c07QWVlwUIZoyt0jeoqedI
	 6SKhFNxv5PHGEoa7Z/+raQ7m5P/6iwVA/WOmNzRlTCMntXzc8bXHcZ1XuNH57UarKEDHy
	 X7+2xgNWEJ/l5GECdxiJ8QiLTgVCFNNVpnQ7DVCNlw2k0WRzbBtIwTpM1lQd4OXfAJ0t4
	 mu8XFtad2T1QalnAia/iGHGHr522l6KRFpgAYjNwCi89XC8byA26tiovh3xhbOc7yew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPkUlzWE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C73C60BB5B8;
	Wed,  4 Nov 2026 21:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPkUlzWE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AB51F00A21;
	Wed,  4 Nov 2026 21:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826967;
	bh=RkaUJLucWOQzYxNEUwFeMsDORIegiA+pYfmE9t/ec50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPkUlzWEyqGr6cQTsRohfH667HcQmwKTkilQMBOIpl/Dbet3BIxOkc7S8FvTi0pZ0
	 tXN2Yq2U1xPry3NN4p20TG8/5gELL/NFj6glio+RXxEpGR64OJiBuX/mtfIRtv+ZWc
	 jY2HaRwoPynlNG7uQa5OY/sImJhIk3XoqtygC9/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 114/547] ksmbd: avoid restoring only in-memory EOF after allocation change
Date: Wed,  4 Nov 2026 16:04:58 -0500
Message-ID: <20261104211041.443070481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

commit 9455e920aebe41217cabff3f81e90da4c407fdb6 upstream.

When SetAllocation requests a size below the allocated block count but
above EOF, ksmbd truncates the file to that size and restores only the
in-memory i_size. The larger EOF remains on disk and reappears after a
reboot. A 3-byte file preallocated to 64 KiB can acquire a 4 KiB EOF
after reducing its allocation to 4 KiB. Extending EOF this way is not
a reliable way to reclaim the preallocation beyond the old EOF either.

Only use this truncate path when the requested allocation is at or below
the observed EOF. A truncate to the existing EOF still lets filesystems
release preallocated blocks beyond EOF. Remove the in-memory-only i_size
restoration. The size check still precedes vfs_truncate() taking the
inode lock, so a concurrent shrink can make the truncate extend EOF;
that race also existed in the original path.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8241,24 +8241,17 @@ static int set_file_allocation_info(stru
 			pr_err("vfs_fallocate is failed : %d\n", rc);
 			return rc;
 		}
-	} else if (alloc_blks < stat.blocks) {
-		loff_t size;
-
+	} else if (alloc_blks < stat.blocks &&
+		   alloc_blks * 512 <= i_size_read(inode)) {
 		/*
-		 * Allocation size could be smaller than original one
-		 * which means allocated blocks in file should be
-		 * deallocated. use truncate to cut out it, but inode
-		 * size is also updated with truncate offset.
-		 * inode size is retained by backup inode size.
+		 * Truncate at or below EOF to discard excess allocation.
+		 * Truncating above EOF would extend the file on disk.
 		 */
-		size = i_size_read(inode);
 		rc = ksmbd_vfs_truncate(work, fp, alloc_blks * 512);
 		if (rc) {
 			pr_err("truncate failed!, err %d\n", rc);
 			return rc;
 		}
-		if (size < alloc_blks * 512)
-			i_size_write(inode, size);
 	}
 
 	fp->allocation_size = le64_to_cpu(file_alloc_info->AllocationSize);


