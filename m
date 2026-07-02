Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71231FA859;
	Thu,  2 Jul 2026 17:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011749; cv=none; b=CVQtvk/Wf57+kzvyCgYtdJVseC8RndP5qwplmA/uGMSjpm790ApdGmtlJH2DrfaszoTuMtsVc0lfVbM5AHrcoceFdR6/Da7zOLzgWJNHAGbADkFttjEx1uIb0Njz2XVqb3QWWU3WvS31IY0i/ZqUzrT6WdMwCaWLZ7guSBCdtcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011749; c=relaxed/simple;
	bh=kB2Cljqk2oTvp3F+iPEAvoZaTwAHUFrGYt/1T6Mjs7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPjZob0wAkBSz2xfEKBHnGnbGUFIlJ85EGy5uwF9grEELQcB6IYS4jQMuaFrsOaPEcBhZDM8mL2MsqU0v0SrruxqUMs8Ec1BVr6O13vG69kYb3gYzNBfjZsSWtF4u1uDVLbn9MhhvOUIzUas7bE9jErcefm3VU8MEgNodvE+o9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cojDc/D+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cojDc/D+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2286E1F000E9;
	Thu,  2 Jul 2026 17:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011748;
	bh=o+8/fbjNmC5IAK5uM4C5brmCZMlG4NXK4hQVBotogcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cojDc/D+9m7asfL0f8GpUYY7LoM4AKSjujijosppcYoPwgsyFBCL4Iq9eWwGq1JCH
	 F9E2QshIOewo5pbsQuhiuy4DJdNYl0Nx18cLlGEmAjyRw0xN0xx57SlSwXEH9zsjIA
	 Ev2kzTX06V6v34xa3eduTQ5QzmYicP3gUR6hb7Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hem Parekh <hemparekh1596@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 118/120] ksmbd: fix out-of-bounds read in smb_check_perm_dacl()
Date: Thu,  2 Jul 2026 18:21:54 +0200
Message-ID: <20260702155115.402447069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hem Parekh <hemparekh1596@gmail.com>

commit 1ef06004ed4bd6d3ed8c840d9d1a376b66d4935b upstream.

The permission-check ACE walk in smb_check_perm_dacl() validates the ACE
header size and caps sid.num_subauth at SID_MAX_SUB_AUTHORITIES, but it
never checks that ace->size is actually large enough to contain
num_subauth sub-authorities before compare_sids() dereferences them.

CIFS_SID_BASE_SIZE covers the SID header up to but excluding the
sub_auth[] array, and offsetof(struct smb_ace, sid) is the ACE header,
so the existing guards only guarantee the 8-byte SID base, i.e. zero
sub-authorities. compare_sids() then reads ace->sid.sub_auth[i] for
i < min(local_sid->num_subauth, ace->sid.num_subauth). The local
comparison SIDs (sid_everyone, sid_unix_NFS_mode, and the id_to_sid()
result) always have at least one sub-authority, and an attacker controls
the ACE revision and authority bytes (which lie within the in-bounds SID
base), so they can match one of those SIDs and force the sub_auth read.

A crafted ACE with size == 16 and num_subauth >= 1 placed at the tail of
the security descriptor therefore causes a heap out-of-bounds read of up
to SID_MAX_SUB_AUTHORITIES * sizeof(__le32) bytes past the pntsd
allocation. The security descriptor is loaded by ksmbd_vfs_get_sd_xattr()
into a buffer sized exactly to the on-disk data (kzalloc(sd_size) in
ndr_decode_v4_ntacl()), so the read lands past the allocation. The
malformed descriptor can be stored verbatim via SMB2_SET_INFO (the DACL
is not normalised before being written to the security.NTACL xattr) and
the read fires on a subsequent SMB2_CREATE access check, making this
reachable by an authenticated client on a share that uses ACL xattrs.

Add the missing num_subauth-versus-ace_size check, mirroring the
identical guards already present in the sibling parsers parse_dacl() and
smb_inherit_dacl().

Fixes: d07b26f39246 ("ksmbd: require minimum ACE size in smb_check_perm_dacl()")
Cc: stable@vger.kernel.org
Signed-off-by: Hem Parekh <hemparekh1596@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1477,7 +1477,9 @@ int smb_check_perm_dacl(struct ksmbd_con
 			break;
 		aces_size -= ace_size;
 
-		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
+		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+		    ace_size < offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE +
+			      sizeof(__le32) * ace->sid.num_subauth)
 			break;
 
 		if (!compare_sids(&sid, &ace->sid) ||


