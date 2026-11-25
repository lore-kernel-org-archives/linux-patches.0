Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623406;
	b=pM52OT/RzyLxM9SfaHVT2X3F5yaJ8FK/+O7koCiSLYDnrxzbc9CidiVajYKabU7cIjbP
	 Jz/NcaesVye2D5BNZW3HgcuW9Ddz1raJSerD0KOjJ09kArqd9M4XfkzXs1ouCKGp1K39j
	 1FZFyWtOWxy6xkc+jpgu/aoxfe7apXY7L9B2YmShBStXa5RdqNb2ETXyxMd3DMNBTpKL3
	 6KuKxeKkOHl8LJCQxgEq2PT8F3ACeRI7f/7KNlf75/OJNya/5eLnVOgupy0qvVIURSy4G
	 HoMoOReiHLWYKQLgvuOIbZkZpJqBXFBotrCosvJcRGLqgt0nK7mrnhhXPPq+0fGFImA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5cc0QV0I0KB8Jdj0mbOSRfV6jHj+CcaW4dNY0lz1Jf0=;
	b=0ApPQPBRYM4t1gi4XiaZO/PEGgRFIrPZHHyCZRfGNv/Dqn4zI0VLQBhKnJ2gK49Mf1Oe
	 xSBXFHNwdJgpP1hasjjY7wjFHtvRnpO4TbGvDRbFtAm/0LE5CIwOubU/dczGylVAAjdde
	 KjHSCRURWziFgQ8ZWYOnv8c52Z5h3Phn5Zi69uDj4f73KxrK/tDPvKgEmLhwprjVQwzfO
	 oblicA740ilHIQrUHCy4Sgh1t7O4HxyZLDZ7+aehDrBzu9MfjE3uvgSBKrXVTmOZOBgQw
	 TF1gRuCFK8W0Vicr47Uin+U/WPgZI26nUC9HpA/UKgRxxZLAFdcREzqvl2JqZbPE/zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YsPMjGcR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8E2606A326;
	Wed, 25 Nov 2026 16:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YsPMjGcR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0961F000C6;
	Wed, 25 Nov 2026 16:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623406;
	bh=5cc0QV0I0KB8Jdj0mbOSRfV6jHj+CcaW4dNY0lz1Jf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YsPMjGcRyHr+QilJsNETgrqrBAJcdLk+FRMW2zfaOOpEKw7/0WH4Su+arnIKHmOYQ
	 lqLsHj63xBuXFHjj861Od3F4IbmqmljJnDpq5dmMh6/4y9ZtOKEEivXltPApJjSnto
	 pBFTmWWsQZS9B7u8lxZ9P54dKr63SaXX/Rgg2eK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaohan Li <shunsheng1218@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 850/990] dm: avoid double-dropping the zone reset submission reference
Date: Wed, 25 Nov 2026 15:36:57 +0100
Message-ID: <20261125143841.940089095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yaohan Li <shunsheng1218@gmail.com>

commit c4965effbe15f837a8089e79c0fc17ab19363cce upstream.

On an error in __send_zone_reset_all(), the submission reference
held by the dm_io can be decremented there and again by the caller's
error path. If another clone is still outstanding, the second drop
can release the dm_io before that clone completes.

Only drop the submission reference in __send_zone_reset_all() on
success. On failure, leave the reference for the caller's existing
error handling to release once.

The error path was reproduced under KASAN with an injected GFP_NOIO
allocation failure while another zone-reset clone remained in
flight. With the change, the same failure was reported normally,
without the observed use-after-free, and ordinary zone resets
continued to work.

Fixes: 81e7706345f06 ("dm: handle REQ_OP_ZONE_RESET_ALL")
Cc: stable@vger.kernel.org
Assisted-by: ZCode:GLM-4
Signed-off-by: Yaohan Li <shunsheng1218@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1924,8 +1924,13 @@ static blk_status_t __send_zone_reset_al
 			break;
 	}
 
-	/* Release the reference that alloc_io() took for submission. */
-	atomic_sub(1, &ci->io->io_count);
+	/*
+	 * Release the reference that alloc_io() took for submission. On error,
+	 * that reference was not consumed: dm_split_and_process_bio() releases
+	 * it on the error path, so do not release it here a second time.
+	 */
+	if (sts == BLK_STS_OK)
+		atomic_dec(&ci->io->io_count);
 
 	return sts;
 }


