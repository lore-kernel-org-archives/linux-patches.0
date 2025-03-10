Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521711A7264;
	Mon, 10 Mar 2025 17:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628019; cv=none; b=EuJZeyWe551TFJp2RHuRGnOEOZxsTG2IZrRgC4Fm5vovMj/Q82YFaq9kNTHHg5thmanWbowr5ImU5+HHS9+JJL6UZ1AcnYZN3qgKIlM9Pjs5yNEdcJF3dg82CPk5VpRBv2E4c5cq0ozZg1J2r4ZLKHvX5F5ileAmMqkW+R4xpgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628019; c=relaxed/simple;
	bh=6b+1ZzhQO/C0e7y6UvOgH6xSH1xtm/FaQGMtqdqXzYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF1emMWYncXuLOiQiVqKXnwNoKP+O8pn/No0kpPM9cP2YkICwQiyo4puRMI0vU9gpk/ySwVksJxILKhbtU8DnGldFTJsFdQQ2iZyocd/olyYlTwwPxeMXMuzDBIPsF7e/syXPZ1IVfA/kPLdE2FS/Z8d2MGkTFNPILRrF7fdHts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHtFym+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHtFym+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8753C4CEE5;
	Mon, 10 Mar 2025 17:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628019;
	bh=6b+1ZzhQO/C0e7y6UvOgH6xSH1xtm/FaQGMtqdqXzYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHtFym+OXR+Z35EdHDtz5dixLEvYfxgZAtD6XZmG2usxeG6RCMGCTUvenuQBL9x4Z
	 R14rFzTw/1IpKQoCdbkt1cVBzXOHMnu8e7nDjmgUZLIYR0yzCOj6cy5kZ+0i6pLFGg
	 0a9VZNorEemsPtSXvTqEgirpPg+E6ilD/IIvP8go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 032/145] ksmbd: fix bug on trap in smb2_lock
Date: Mon, 10 Mar 2025 18:05:26 +0100
Message-ID: <20250310170436.031796260@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7452,7 +7452,7 @@ no_check_cl:
 retry:
 		rc = vfs_lock_file(filp, smb_lock->cmd, flock, NULL);
 skip:
-		if (flags & SMB2_LOCKFLAG_UNLOCK) {
+		if (smb_lock->flags & SMB2_LOCKFLAG_UNLOCK) {
 			if (!rc) {
 				ksmbd_debug(SMB, "File unlocked\n");
 			} else if (rc == -ENOENT) {


