Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6A8169AD2;
	Tue, 16 Jun 2026 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628924; cv=none; b=WC3msuQNWLPZYYwQvEd3ksGMoMHQNHiSP1nJUefvidFcgPwldG6w9kSn++nH+4Qd/JebeUI0R8W5sliVqTwIZg95xLMLQFBGYeViIt2F+bcJ9hKPXVXFYHNqaWMiTNiTlU3l0Jmqz3EkJaqQGvcL+vzOlcA1RhZJIK9u3TrDg/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628924; c=relaxed/simple;
	bh=4tqMiqRu5kJIfNM6QK+s2jkF8z8lmj/UZjFDXLByw+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KW7/G+zp8oHMP0KSI1HZdogUh9b//1FTEEe4iL6oVWwgKKD8qucd1kkmAKbGqT12eCUU3A61prHxSk7oQISBV4Ev72/B64/HBxhxZNeazkwZO0ZdFW3j6qmH1OYVuOkupkihMBNSMLV9HGI00rWVr2CVXnw1BAj3+b4s8y0/Y8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfjTw6U8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfjTw6U8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A8C1F000E9;
	Tue, 16 Jun 2026 16:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628923;
	bh=GNtCtP90g+5j46e+ZnNkcIzJWPP+zKQ6Yo8DSvLxqdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfjTw6U80v4N+AlMip8QBi7ur8CLBZZcJgKWtf5JotLR818HxT9IvpUhfkSLQ6BDD
	 zg1THxEdy4cpOvTWkwLT1h3kdhCunKBXD0vrleJZ5B0UKxt8b5ikcSSOtljLKnA+dG
	 fHe3j7n54Oc1JFpWyUNvCGqQcAFB6qM24BXWUxfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ganiyev <ali.qaniyev@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 144/452] ksmbd: OOB read regression in smb_check_perm_dacl() ACE-walk loops
Date: Tue, 16 Jun 2026 20:26:11 +0530
Message-ID: <20260616145125.267591885@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ganiyev <ali.qaniyev@gmail.com>

commit 0e60dafe97eca61721f3db456f97d97a80c6c8ae upstream.

Commit d07b26f39246 ("ksmbd: require minimum ACE size in
smb_check_perm_dacl()") introduced a transposed bounds check:

    if (offsetof(struct smb_ace, sid) + aces_size < CIFS_SID_BASE_SIZE)

Since offsetof(..sid) is 8 and CIFS_SID_BASE_SIZE is 8, this evaluates
to `aces_size < 0`. Because `aces_size` is always non-negative, this
check becomes dead code and never breaks the loop.

Worse, that commit removed the old 4-byte guard, meaning the loop now
reads `ace->size` (offset 2) even when `aces_size` is 0-3 bytes. This
re-opens a 2-byte heap out-of-bounds (OOB) read past the pntsd allocation
during subsequent SMB2_CREATE operations.

Fix this by properly transposing the comparison to require at least
16 bytes (8-byte offset + 8-byte SID base), matching the correct form
used in smb_inherit_dacl().

Fixes: d07b26f39246 ("ksmbd: require minimum ACE size in smb_check_perm_dacl()")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ganiyev <ali.qaniyev@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1342,8 +1342,8 @@ int smb_check_perm_dacl(struct ksmbd_con
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = acl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-			if (offsetof(struct smb_ace, sid) +
-			    aces_size < CIFS_SID_BASE_SIZE)
+			if (aces_size < offsetof(struct smb_ace, sid) +
+			    CIFS_SID_BASE_SIZE)
 				break;
 			ace_size = le16_to_cpu(ace->size);
 			if (ace_size > aces_size ||
@@ -1366,8 +1366,8 @@ int smb_check_perm_dacl(struct ksmbd_con
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 	aces_size = acl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
-		if (offsetof(struct smb_ace, sid) +
-		    aces_size < CIFS_SID_BASE_SIZE)
+		if (aces_size < offsetof(struct smb_ace, sid) +
+		    CIFS_SID_BASE_SIZE)
 			break;
 		ace_size = le16_to_cpu(ace->size);
 		if (ace_size > aces_size ||


