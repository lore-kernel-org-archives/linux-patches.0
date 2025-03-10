Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7581DE89C;
	Mon, 10 Mar 2025 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627309; cv=none; b=IYORmTzMPJULvXaU8fk5kOF2VqmLr+3Hc8MJFSGumwmDJfILncP3GkzVf35+4QtIBuNstRiWGODx1DPLe4WjXyb9FwZhJwqzKlw4p0U7mlaxlciCo+5Ek8jUnyumTHisuMtnozOzQ073gONGc7sMevUNNlCRASdbVhOaO4Gdhyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627309; c=relaxed/simple;
	bh=zVHlTjdMiMp9YMnFyusUNQy0MBL5dctImEFuIQS2UYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aECiakG4h+8D2kWdlxguvNtYjlaRKray1DJuLYQadvlMNg59ZXnkSM8XfR/+vSOR9Zq7j3MNH5il1rT8LJ+9FDP6LIZf1MmuyVQXlH5TrepIBO+PxP1GwiwcRWwmnKUgxBA27ZN3dXlgMDQUieFmA3NWPY6wWbC2LsVZZJLLH4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHgIoWBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHgIoWBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222DCC4CEE5;
	Mon, 10 Mar 2025 17:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627309;
	bh=zVHlTjdMiMp9YMnFyusUNQy0MBL5dctImEFuIQS2UYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHgIoWBP1MtpG+TrwYN+T8oDhcLUoYIzGCDIwRjIEYrFAHRfxj1PxtW5lVHcz3HsF
	 eBWHp+glJiBc1TMPrSqAXrmqCcSIPRrNHEVGHfCL/rLkc7O678MinsI9pvWeN6GDp2
	 lYTP+u2yPXqpZ5RfkkZAXOqxnjphDsJRsQgQSodo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 086/269] ksmbd: fix bug on trap in smb2_lock
Date: Mon, 10 Mar 2025 18:03:59 +0100
Message-ID: <20250310170501.145538770@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit e26e2d2e15daf1ab33e0135caf2304a0cfa2744b upstream.

If lock count is greater than 1, flags could be old value.
It should be checked with flags of smb_lock, not flags.
It will cause bug-on trap from locks_free_lock in error handling
routine.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7451,7 +7451,7 @@ no_check_cl:
 retry:
 		rc = vfs_lock_file(filp, smb_lock->cmd, flock, NULL);
 skip:
-		if (flags & SMB2_LOCKFLAG_UNLOCK) {
+		if (smb_lock->flags & SMB2_LOCKFLAG_UNLOCK) {
 			if (!rc) {
 				ksmbd_debug(SMB, "File unlocked\n");
 			} else if (rc == -ENOENT) {


