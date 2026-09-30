Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B713BA244;
	Wed, 30 Sep 2026 18:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794670; cv=none; b=okckcq5H1pqgEa1wk6IBSeDRqGpL8dJGqWvTNoTBQm+G+fqWipCpNpJnJS90DdGIkcCxRdQqFYnVniE/2gPsqmcKP+u9qO03v2Oz9KhGt7kJ1jttHm/QoVwc6Nomr2eMkkasqr1Cl0TG5o+jRUFSZIcwcQdjwONLnT0C0Mvvx94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794670; c=relaxed/simple;
	bh=eYbiMuR2GvFzMSmhyJ/SLThhB3YgNLlXQ8HTcAkOXpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7xsQplLkv/g4VHKZO9HAlXWqd5tE3q4/eBSAnWzsDTGH+VQ9h/Xmh5Mm0fPe8cbWJfk0ZXnpj9YTljLCWVU+FqiyMnA1fl4BQn94taEqXzzUpXvvQiV9fGZgSoVDt7fsoVddRT8hr5C4mcLcq3WKgEjKsN6+/CQFjyCOu04POo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtV33HHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtV33HHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E131F000FF;
	Wed, 30 Sep 2026 18:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794668;
	bh=cnzeuOOT2kpXVawrFW7kFNW4JQdl6GhZbODnB+QK7pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtV33HHQMhc8bEzeyuE/o1pbwS9PVXO3N+B9WBTmnqB5GEe2I9j7rZpoZMbR4G5B1
	 IG3RwuOt76aCKGxsHAl1hFiWnnpZ6RavKoS5vg+XHQkjPsTF2YdzwaWRIzkRJC+nq7
	 MgcqRDIL107vJUso3TtVhmIFqOdSi4X1vanVFCxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0293/1193] ksmbd: validate SID namespace before mapping IDs
Date: Wed, 30 Sep 2026 17:16:17 +0200
Message-ID: <20260930152440.672448838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit fbe0bb2b75eb3c61e8464486506253d1b471240b ]

sid_to_id() currently treats the last subauthority of any owner or group
SID as a Unix uid or gid. For example, this maps Everyone (S-1-1-0) to
uid 0 and BUILTIN\Users (S-1-5-32-545) to gid 545.

When an SMB2 CREATE security descriptor contains those SIDs, ksmbd
attempts to change the newly created file to the bogus Unix ownership.
notify_change() then returns -EPERM, which makes smb2.create.aclfile fail
with NT_STATUS_SHARING_VIOLATION.

Validate the SID prefix before extracting its RID. Only server-domain
owner SIDs and S-1-22-2 Unix group SIDs have local ID representations.
Treat other valid Windows SIDs as unmapped so their original values can
still be preserved in the NT ACL xattr.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index cf72d0942e16e..3056634d0b4b5 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -258,6 +258,7 @@ static int sid_to_id(struct mnt_idmap *idmap,
 		     struct smb_sid *psid, uint sidtype,
 		     struct smb_fattr *fattr)
 {
+	const struct smb_sid *sid_prefix;
 	int rc = -EINVAL;
 
 	/*
@@ -279,6 +280,12 @@ static int sid_to_id(struct mnt_idmap *idmap,
 		kuid_t uid;
 		uid_t id;
 
+		/* Only the server domain RID has a local uid representation. */
+		sid_prefix = &server_conf.domain_sid;
+		if (psid->num_subauth != sid_prefix->num_subauth + 1 ||
+		    compare_sids(psid, sid_prefix))
+			return -EINVAL;
+
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
 		uid = KUIDT_INIT(id);
 		uid = from_vfsuid(idmap, &init_user_ns, VFSUIDT_INIT(uid));
@@ -290,6 +297,12 @@ static int sid_to_id(struct mnt_idmap *idmap,
 		kgid_t gid;
 		gid_t id;
 
+		/* Local gids are represented by S-1-22-2-<gid>. */
+		sid_prefix = &sid_unix_groups;
+		if (psid->num_subauth != sid_prefix->num_subauth + 1 ||
+		    compare_sids(psid, sid_prefix))
+			return -EINVAL;
+
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
 		gid = KGIDT_INIT(id);
 		gid = from_vfsgid(idmap, &init_user_ns, VFSGIDT_INIT(gid));
@@ -916,9 +929,9 @@ int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 
 		rc = sid_to_id(idmap, owner_sid_ptr, SIDOWNER, fattr);
 		if (rc) {
-			pr_err("%s: Error %d mapping Owner SID to uid\n",
-			       __func__, rc);
+			ksmbd_debug(SMB, "Owner SID has no Unix uid mapping\n");
 			owner_sid_ptr = NULL;
+			rc = 0;
 		}
 	}
 
@@ -934,9 +947,9 @@ int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		}
 		rc = sid_to_id(idmap, group_sid_ptr, SIDUNIX_GROUP, fattr);
 		if (rc) {
-			pr_err("%s: Error %d mapping Group SID to gid\n",
-			       __func__, rc);
+			ksmbd_debug(SMB, "Group SID has no Unix gid mapping\n");
 			group_sid_ptr = NULL;
+			rc = 0;
 		}
 	}
 
-- 
2.53.0



