Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872DB5158B7;
	Wed, 30 Sep 2026 16:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784768; cv=none; b=hwqfl/wGwXmVLRdThokNPY4yUVx5y0qO6mH92WdwrUfKHv1nRwfzcXKydsYSPeK9zLGCrhEeZ6v1IMxn24R/1jDygWx9QbDomkYldETmC/g0ie5ccndHPMD+ccwfCvxA4h+aDOjwqfTCW2sgMc+X6rDDvFJT5hhOycIYdyDIewM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784768; c=relaxed/simple;
	bh=+mQiIQFFUNIkrBe/QALZGPX36ynopoJ8L0ZJFJBlrD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgpgF8SaSip00J0cVJDmVxuPERGcrJzZyTY8A+2GNVT5tnMDSXqY5yU35v97qhcRE1BEK+HeFfr4Zk1YcjQhAQTPk2PNxRzk28m+cU26TyM5ey1wTJiY8XpwZiMXM+hNjnPYyjTi6yWVA2Az9Itcf/tVPchFiXEfhLDpwAsoNzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKybqZHu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKybqZHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDB11F000FF;
	Wed, 30 Sep 2026 16:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784765;
	bh=b0f0iPAQlUlqycZLuXs0ICD8vFvdzGbahaI4MHK+ZBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKybqZHueaxihWZTA/QOS7V947hlHcmiYtNn/hPPSqGioO1arEPYs/5ZbvgbSFUOL
	 walcKHMv8fh1bKD/qgu8QQsD5f1BJ48fE1WVJMS+MDCrThhYnhAFxZBrqIXrmEVQ52
	 KXWEjO+9tTkjrWkpRK30M6OsTm+AxZrN5TSu6o2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 254/982] ksmbd: validate SID namespace before mapping IDs
Date: Wed, 30 Sep 2026 17:16:30 +0200
Message-ID: <20260930152422.251909360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 17987e83bdd87..051df6536f7a3 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -258,6 +258,7 @@ static int sid_to_id(struct user_namespace *user_ns,
 		     struct smb_sid *psid, uint sidtype,
 		     struct smb_fattr *fattr)
 {
+	const struct smb_sid *sid_prefix;
 	int rc = -EINVAL;
 
 	/*
@@ -279,6 +280,12 @@ static int sid_to_id(struct user_namespace *user_ns,
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
 		uid = from_vfsuid(user_ns, &init_user_ns, VFSUIDT_INIT(uid));
@@ -290,6 +297,12 @@ static int sid_to_id(struct user_namespace *user_ns,
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
 		gid = from_vfsgid(user_ns, &init_user_ns, VFSGIDT_INIT(gid));
@@ -900,9 +913,9 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 
 		rc = sid_to_id(user_ns, owner_sid_ptr, SIDOWNER, fattr);
 		if (rc) {
-			pr_err("%s: Error %d mapping Owner SID to uid\n",
-			       __func__, rc);
+			ksmbd_debug(SMB, "Owner SID has no Unix uid mapping\n");
 			owner_sid_ptr = NULL;
+			rc = 0;
 		}
 	}
 
@@ -918,9 +931,9 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 		}
 		rc = sid_to_id(user_ns, group_sid_ptr, SIDUNIX_GROUP, fattr);
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



