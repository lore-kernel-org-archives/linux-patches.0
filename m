Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585481;
	b=YNx42HMbzWfIeUM5IJyEcsRAgQf/xRnHE0lx7D3XP++dn6PKYkzjHEu2sUqzRVHprWSr
	 PsU6JYjcg4hsraiHaoY+JOdsouJgQvnGxuX+hKZ8Q+41zagt637xxAsvd0qEOoqc4mbaU
	 tB/cwsLJMtiwLQsIlhpEhWTeSQNaLK0Pq06cLAnylQ1c1ceQFOkVK2RJFyd1vrQ3M8zan
	 MCdrNTrnPht/mE/YPV5bJOaSlj4TN36gzMz9jd/dwzNhksCO96DmyWvxWkyuVyBFerheT
	 bcLOoBZQbAk3zL359rbF54RoghpiYwT86d9uz0NA2dv536zhhgfQhVUSNrvwHquoxVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=axLTX1QkXu2VhdN1IzgCl3ePQ98Yu2z8nRB5NQwxnSM=;
	b=gonV/BI73FbdCDzy/I5ymx81OtpHNCGmvj0dssZaUbnXl4CATjyTnMhz8zs5xmpexA2T
	 yEt4Dw064LYceMT0PoDPPOUIl9kYvmYcpWziEpIfzF4UPExgzVW4hrEZUDa91Q+QWDol9
	 R2XyF2cYXlmu2R6hOwA5Zg3dzWQcAH7dnqDY0aHTukjDpJlDD5/yDFaQdH7GEdKsvPqIT
	 sxeh+J3rN28TNNxFp0yxGvvJaUX4mPdHcZvnzBvvAAdyVDYJE24zQUNcNO/Yb5XPsCjhe
	 Um16yEDED8XsqA8SqG4VLgN0dlj+JOqL5FsjZqBTVepdKKcN7qxPbjV+sqc5Jy2Yyfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TPi+/72V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84208606EBA2;
	Fri, 13 Nov 2026 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TPi+/72V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6E21F000C8;
	Fri, 13 Nov 2026 15:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585481;
	bh=axLTX1QkXu2VhdN1IzgCl3ePQ98Yu2z8nRB5NQwxnSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPi+/72VknyzeeI5H6er0au57N4onfJH9uIB7PjEvsH8yBzmTrGj6FqTqWacadPxO
	 qy3nXPUMQFYZ7sJ2Jmk132X6yMLjA62hHGqvfqgNhcy71lK/aY1NokshI+mIR4GanI
	 s6+BOdWe0hB/48ziv9pYe6378GZwFsAVTMykH7Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 132/507] ksmbd: let the owner read and change the DACL when no ACE names it
Date: Fri, 13 Nov 2026 10:47:16 -0500
Message-ID: <20261113153758.921243842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit ffc855fe16afe02b22305111aa68cd8d07360941 ]

smb_check_perm_dacl() refuses the owner when neither its DACL lookup nor
the POSIX ACL fallback matches. The owner then cannot read or replace
the DACL over SMB. MS-DTYP 2.5.3.2 grants the owner READ_CONTROL and
WRITE_DAC unless an OWNER RIGHTS ACE applies.

An empty DACL allows the owner's explicit requests for these rights but
refuses MAXIMUM_ALLOWED. smb2_open() uses that check for the maximal
access reply (MS-SMB2 3.3.5.9.5), so even a READ_CONTROL open fails when
it asks for that reply.

Grant the owner's implicit rights on both paths, for explicit requests
and MAXIMUM_ALLOWED, unless an OWNER RIGHTS ACE applies.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index c9e4429a19638..cc3a450e4cb29 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1470,6 +1470,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	int i, found = 0;
 	unsigned int access_bits = 0, denied = 0;
 	struct smb_ace *others_ace = NULL;
+	bool or_ace = false;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
@@ -1502,6 +1503,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	is_owner = uid == from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid));
 
 	if (!pdacl->num_aces) {
+		unsigned int allowed = 0;
+
 		/*
 		 * An empty (present, zero-ACE) DACL grants no access to
 		 * anyone except the object owner's implicit READ_CONTROL
@@ -1510,9 +1513,14 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		 * not let trailing bytes after a zero-ACE DACL become an
 		 * implicit grant.
 		 */
-		if (!is_owner ||
-		    (*pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)))
+		if (is_owner)
+			allowed = READ_CONTROL | WRITE_DAC;
+		if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+			requested |= allowed;
+		if (!allowed || requested & ~allowed)
 			rc = -EACCES;
+		else
+			*pdaccess = cpu_to_le32(requested);
 		goto err_out;
 	}
 
@@ -1597,6 +1605,9 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			found = 1;
 			break;
 		}
+		if (!compare_sids(&sid_owner_rights, &ace->sid) &&
+		    !(ace->flags & INHERIT_ONLY_ACE))
+			or_ace = true;
 		if (!compare_sids(&sid_everyone, &ace->sid) ||
 		    !compare_sids(&sid_authusers, &ace->sid))
 			others_ace = ace;
@@ -1641,8 +1652,23 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		if (others_ace) {
 			ace = others_ace;
 		} else {
-			ksmbd_debug(SMB, "Can't find corresponding sid\n");
-			rc = -EACCES;
+			unsigned int allowed = 0;
+
+			/*
+			 * No ACE names the owner, who may still read and
+			 * change the DACL unless OWNER RIGHTS applies
+			 * (MS-DTYP 2.5.3.2).
+			 */
+			if (is_owner && !or_ace)
+				allowed = READ_CONTROL | WRITE_DAC;
+			if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+				requested |= allowed;
+			if (!allowed || requested & ~allowed) {
+				ksmbd_debug(SMB, "Can't find corresponding sid\n");
+				rc = -EACCES;
+				goto err_out;
+			}
+			*pdaccess = cpu_to_le32(requested);
 			goto err_out;
 		}
 	}
-- 
2.53.0



