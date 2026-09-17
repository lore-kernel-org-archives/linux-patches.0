Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5E553D9EE;
	Thu, 17 Sep 2026 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664821; cv=none; b=K7SjGlLByPqBPOi13a2doyWWzAW8mniraygjvaivsb2f5bJ9brd7eGeDWsL/enSeghIvfskQI2IlhWWfyxbZ9YDgNaEkvrmnfZ8o1iwbD3GfFQkoMqiVMyEVnlCPIet3+sWJ/0tjFqo4ExJ0egUVogRRmR/6WdQ74cBwMCwa1Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664821; c=relaxed/simple;
	bh=9HrkOqLnkYjSdI5apmBhQ3WoKUsPV11xj+TJT3BDTYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awHbGTWgn15SW0edL9+c1TMVatTirGlWif4QGlPyJUcrJXJVbHQJOCylY7UZABit1S/inuEhK+rgxXAtd55b7LUuZjO2clXoWao0AnBIMysYrLmaFmYNOY4WuMqxfW8UY0m/Phmixl9KgK9yOFG48t0+ygc5u5ais/BUSRz7j6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bceo9Mvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bceo9Mvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3A91F000FF;
	Thu, 17 Sep 2026 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664820;
	bh=lynKm52Wo6qwDSOr/uV2jAb2mngY5RlPtHAW2oKiCVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bceo9MvvjpyNX0z5LSaGIeIjyI12TMEg3SYoakU6jjDyiM2focPzQsSBdTztGJx9E
	 sOZG3LLKKdgxz5eNOtj7+DcIOAoViDOKfaod1sqPrwCFO7MGpIaQanZyxAXEvQyS2p
	 0qW5vOL3cYlW8cJZCKJei2C/HkTphFDuFh98DbUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0499/1250] ksmbd: validate SID namespace before mapping IDs
Date: Thu, 17 Sep 2026 16:04:54 +0100
Message-ID: <20260917151605.487169369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 0879012aa63c8..3586a6025127e 100644
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



