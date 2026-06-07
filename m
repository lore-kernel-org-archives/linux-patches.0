Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D441E98EF;
	Sun,  7 Jun 2026 10:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829045; cv=none; b=DSER4GkmDqBe/EoI2TJq/DfcndomLVvSwKes4GWCt+7Skb66dgLORCqpi+ay4Iqfzahh/LCvEoojYtYKf36uxvsLtPttbzQO2j6xhknP+M6i3yQaMs46aU4vTNsT09Wn494i144c8Khh/V2R2FGJ2vdOJTDeKVAkNjuIwd42x9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829045; c=relaxed/simple;
	bh=EsCt1yBY++4Drp68B1jV686Jl6uBU2F5C7wizDlCTCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMNtCzvG2lhkBGGBM22tDw7Hgdm6A+QOohlFODYcqQnUIpzIZHgs+pB/q5vFNv/lqgzQg+rI8qx509q1jn8ReJ+IhOOvoXuZSAVLcco1xGRk/Zf4+nhDw3XBczWFBrou9hjfjB85XrL1q3zKvcRs28N0J+YChoeCTyRtJy5E78w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KrSYJAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KrSYJAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFE81F00893;
	Sun,  7 Jun 2026 10:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829044;
	bh=W817MdTQdCjBnGAoJ5581qpZJZNSH7uwO3xkWcgu/6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KrSYJAu4SresJJVgwRYe6G/vvq1GcP3N0wW57HKVn7AUH1QruKT45QM2a0lQ8wKV
	 mmW7y61mnnfxZWumArJYKYuJetKADTeLKfigoAJ7QfqXF6x0T0xasrte1GGBxaiTPS
	 c8AK0IUCMmtbAxhGjblM8h7c8QSWqDbCp5Ub9anc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ganiyev <ali.qaniyev@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 212/315] ksmbd: OOB read regression in smb_check_perm_dacl() ACE-walk loops
Date: Sun,  7 Jun 2026 11:59:59 +0200
Message-ID: <20260607095735.342911637@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -1446,8 +1446,8 @@ int smb_check_perm_dacl(struct ksmbd_con
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
@@ -1470,8 +1470,8 @@ int smb_check_perm_dacl(struct ksmbd_con
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


