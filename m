Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B2637F01B;
	Sat, 17 Oct 2026 17:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258576; cv=none; b=PjSKvZOEPia3vNToxkTPUSyQa+yE3spO5o2Fovt0aOBwkFsLkWwllUnJYRO+Z5iHyQwAE2KbpiOhY1cfT2LBVUEB+lKdodWwxvjz2pbN/uV89SZaR8wAzxOZsaOCkNLRaXGDnOuRzCnmQmpiAHeUPYFxRcit/eqTR+axQ49U6gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258576; c=relaxed/simple;
	bh=iR8/EqCybTlfv8bya5S2qdEyGA9NvGwBdbec7yMP9DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dk51fTKGyUcRONk0mdgcJFayf2koNeki+NcDWo6xFlb5QHVwSrH/R9yHPz0UqlG1kT9ytsTcImKuyOnK94vQXcOttWpNcyCavl2zdSdv7F/inT+n1uMlWTdK46XW788z/XQ4Yr1Jl692Y5kgNvAN2kCdZp5QYi+FakH48bqDxz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cijk+hS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cijk+hS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A7A1F000C4;
	Sat, 17 Oct 2026 17:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258575;
	bh=SS2781clUVGQ7SazjLHdSM9HJxrIkb7YTUk8OAdsz/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cijk+hS+LNHl01/8TpjzPoNYiP9ZcQQ5S+52tC4CaMxlGeHsZRwOnhNi1AFmUY3Yn
	 MArpFpoSx1XEvUc6B8aNwcYWbCHGRXcJYGRIc1Y5dMKAgcsay00xi5vu0mFROM4j+V
	 Vf123DSxevETUs0gbpTr8eoItvV4BybBN7Cw7y3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0889/1674] ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()
Date: Sat, 17 Oct 2026 17:52:41 +0200
Message-ID: <20261017160453.939730098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 3e4e2ea2a781018ed5d75f969e3e5606beb66e48 ]

smb_inherit_dacl() trusts the on-disk num_aces value from the parent
directory's DACL xattr and uses it to size a heap allocation:

  aces_base = kmalloc(sizeof(struct smb_ace) * num_aces * 2, ...);

num_aces is a u16 read from le16_to_cpu(parent_pdacl->num_aces)
without checking that it is consistent with the declared pdacl_size.
An authenticated client whose parent directory's security.NTACL is
tampered (e.g. via offline xattr corruption or a concurrent path that
bypasses parse_dacl()) can present num_aces = 65535 with minimal
actual ACE data.  This causes a ~8 MB allocation (not kzalloc, so
uninitialized) that the subsequent loop only partially populates, and
may also overflow the three-way size_t multiply on 32-bit kernels.

Additionally, the ACE walk loop uses the weaker
offsetof(struct smb_ace, access_req) minimum size check rather than
the minimum valid on-wire ACE size, and does not reject ACEs whose
declared size is below the minimum.

Reproduced on UML + KASAN + LOCKDEP against the real ksmbd code path.
A legitimate mount.cifs client creates a parent directory over SMB
(ksmbd writes a valid security.NTACL xattr), then the NTACL blob on
the backing filesystem is rewritten to set num_aces = 0xFFFF while
keeping the posix_acl_hash bytes intact so ksmbd_vfs_get_sd_xattr()'s
hash check still passes.  A subsequent SMB2 CREATE of a child under
that parent drives smb2_open() into smb_inherit_dacl() (share has
"vfs objects = acl_xattr" set), which fails the page allocator:

  WARNING: mm/page_alloc.c:5226 at __alloc_frozen_pages_noprof+0x46c/0x9c0
  Workqueue: ksmbd-io handle_ksmbd_work
   __alloc_frozen_pages_noprof+0x46c/0x9c0
   ___kmalloc_large_node+0x68/0x130
   __kmalloc_large_node_noprof+0x24/0x70
   __kmalloc_noprof+0x4c9/0x690
   smb_inherit_dacl+0x394/0x2430
   smb2_open+0x595d/0xabe0
   handle_ksmbd_work+0x3d3/0x1140

With the patch applied the added guard rejects the tampered value
with -EINVAL before any large allocation runs, smb2_open() falls back
to smb2_create_sd_buffer(), and the child is created with a default
SD.  No warning, no splat.

Fix by:

  1. Validating num_aces against pdacl_size using the same formula
     applied in parse_dacl().

  2. Replacing the raw kmalloc(sizeof * num_aces * 2) with
     kmalloc_array(num_aces * 2, sizeof(...)) for overflow-safe
     allocation.

  3. Tightening the per-ACE loop guard to require the minimum valid
     ACE size (offsetof(smb_ace, sid) + CIFS_SID_BASE_SIZE) and
     rejecting under-sized ACEs, matching the hardening in
     smb_check_perm_dacl() and parse_dacl().

v1 -> v2:
  - Replace the synthetic test-module splat in the changelog with a
    real-path UML + KASAN reproduction driven through mount.cifs and
    SMB2 CREATE; Namjae flagged the kcifs3_test_inherit_dacl_old name
    in v1 since it does not exist in ksmbd.
  - Drop the commit-hash citation from the code comment per Namjae's
    review; keep the parse_dacl() pointer.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index b68b63a3195fa..b9419c10bdd9c 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1179,7 +1179,24 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 		goto free_parent_pntsd;
 	}
 
-	aces_base = kmalloc(sizeof(struct smb_ace) * num_aces * 2, GFP_KERNEL);
+	aces_size = pdacl_size - sizeof(struct smb_acl);
+
+	/*
+	 * Validate num_aces against the DACL payload before allocating.
+	 * Each ACE must be at least as large as its fixed-size header
+	 * (up to the SID base), so num_aces cannot exceed the payload
+	 * divided by the minimum ACE size.  This mirrors the existing
+	 * check in parse_dacl().
+	 */
+	if (num_aces > aces_size / (offsetof(struct smb_ace, sid) +
+				    offsetof(struct smb_sid, sub_auth) +
+				    sizeof(__le16))) {
+		rc = -EINVAL;
+		goto free_parent_pntsd;
+	}
+
+	aces_base = kmalloc_array(num_aces * 2, sizeof(struct smb_ace),
+				  GFP_KERNEL);
 	if (!aces_base) {
 		rc = -ENOMEM;
 		goto free_parent_pntsd;
@@ -1188,7 +1205,6 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	aces = (struct smb_ace *)aces_base;
 	parent_aces = (struct smb_ace *)((char *)parent_pdacl +
 			sizeof(struct smb_acl));
-	aces_size = acl_len - sizeof(struct smb_acl);
 
 	if (pntsd_type & DACL_AUTO_INHERITED)
 		inherited_flags = INHERITED_ACE;
@@ -1196,11 +1212,14 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	for (i = 0; i < num_aces; i++) {
 		int pace_size;
 
-		if (offsetof(struct smb_ace, access_req) > aces_size)
+		if (aces_size < offsetof(struct smb_ace, sid) +
+		    CIFS_SID_BASE_SIZE)
 			break;
 
 		pace_size = le16_to_cpu(parent_aces->size);
-		if (pace_size > aces_size)
+		if (pace_size > aces_size ||
+		    pace_size < offsetof(struct smb_ace, sid) +
+				CIFS_SID_BASE_SIZE)
 			break;
 
 		if (parent_aces->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
-- 
2.53.0



