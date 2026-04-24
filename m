Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845D219A288;
	Fri, 24 Apr 2026 13:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038148; cv=none; b=a2WNw4RoAPR0w5MwDkfg2P0Sw/DracUp2d2GRoxViU89hE95TfxYUFJ0Yv9O8DUojdRRqdm/8ffrDwtN6Tz8FvZuej8BzrgKg/C6vZzJxBcOlXwxHs+9t2aGn+noNHT81MsDXEle3GDn4FWQuGqp6WKDWW5IAI4S2jBdHWdFUek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038148; c=relaxed/simple;
	bh=5bJHZJnHyWgb7lXnm1bacvbiENsykU/2QR0z9WxYvUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psIs2dQhn+XguAtFkoVdgD+erS3yQ+YoQTgkB4VeThliiJZ6MQc3m8gYDzY69O509AgoS6rKL16Lm9SqZqe+AgSoabUYKflD87J9/kuUUX9f7TLe5VrkOqcEEy99rUIJSUS59sZAi0O2VpYZWDa81iS6IAPQp11li6EPs0KBihM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7xbsiOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7xbsiOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BE6C19425;
	Fri, 24 Apr 2026 13:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038148;
	bh=5bJHZJnHyWgb7lXnm1bacvbiENsykU/2QR0z9WxYvUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7xbsiOqEbpvXfjLmyXirrjyVIKy9kRe5ESyMm1ydWH6He64okbbF2mBa7+LY9c2B
	 gZKwSwxVDXVoquMTqrfWSsHQ8z0FXIg3vOGaEMmmPjiuyzeSmU/3jVmYkiRjn3bVVV
	 dH+KtPpRXsoDWwfeoij8SPKjv5ZmFS7Qe1d5cGRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 42/55] ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()
Date: Fri, 24 Apr 2026 15:31:21 +0200
Message-ID: <20260424132438.766214932@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 3e4e2ea2a781018ed5d75f969e3e5606beb66e48 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1106,8 +1106,24 @@ int smb_inherit_dacl(struct ksmbd_conn *
 		goto free_parent_pntsd;
 	}
 
-	aces_base = kmalloc(sizeof(struct smb_ace) * num_aces * 2,
-			    KSMBD_DEFAULT_GFP);
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
+				  KSMBD_DEFAULT_GFP);
 	if (!aces_base) {
 		rc = -ENOMEM;
 		goto free_parent_pntsd;
@@ -1116,7 +1132,6 @@ int smb_inherit_dacl(struct ksmbd_conn *
 	aces = (struct smb_ace *)aces_base;
 	parent_aces = (struct smb_ace *)((char *)parent_pdacl +
 			sizeof(struct smb_acl));
-	aces_size = acl_len - sizeof(struct smb_acl);
 
 	if (pntsd_type & DACL_AUTO_INHERITED)
 		inherited_flags = INHERITED_ACE;
@@ -1124,11 +1139,14 @@ int smb_inherit_dacl(struct ksmbd_conn *
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
 
 		aces_size -= pace_size;


