Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105F343CEF3;
	Tue, 13 Oct 2026 12:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894259; cv=none; b=W1rdTMJtG/FcFum+lqAypfyCDpkgDEKfwjj/ti7HJAzkz1VASoTlM4eWdsgW38qmo3xDYjDL47kd2xgDUDjGltfxFb+rQQHVo6lrM+L+TV8XkAQMBo8Gfl6cG8Q4/knNMZY+yXLzVBDUkJCbJW1QWvqbVef0DR8W29byoXIET5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894259; c=relaxed/simple;
	bh=DPIbo//C1uw+aWPpHiTMnZEbn7nCtP2TM5TR1Y2F7JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFDUzxM/g8pHJGj6DX92YiQJZZRIRIJfjMzomsZRfJ2r5xktdW5A5f136gJGdM7L2swq/93977/Zajzfv3axlKxCn4fgEI2Cu81tD4chWawFZdHnbtxVRveBJ5ULILp6TTynjxP4HybNRuYi6yp8n1VdVH0Vkv82zvLJTxLXeOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcdjkfCT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcdjkfCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7BC1F000FF;
	Tue, 13 Oct 2026 12:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894258;
	bh=tN5NVrkgW34SUCrys/J4K9ujzsMK/vNn5LIci2c0jJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EcdjkfCTugwJf5UeFAH6n2W8G/UKIfa+pE0ZC/iKiMCp8kbbotflpWL5Ymsdgns7D
	 pldgaKVxz5HI5KmLd6oeERK4flhy9zqcw6gYg56uPq/TY+Lg1q3zg17TGlqQ7Sy+q7
	 J6+HgH85cWQs0l/cJfGiG0aDj1lGuDdMJbVq3/Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 501/621] smb: client: avoid using uninitialized SIDs in cifs_posix_to_fattr()
Date: Tue, 13 Oct 2026 13:38:16 +0200
Message-ID: <20261013112932.717095114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit da6e25842431982d5a53cf00d925b98c690f4467 ]

cifs_posix_to_fattr() ignores the return value of posix_info_parse().
When a malformed POSIX directory entry is encountered (e.g. invalid
SID lengths from an untrusted server), posix_info_parse() returns -1
without populating the 'parsed' struct.  The uninitialized stack
memory in parsed.owner and parsed.group is then passed to
sid_to_id(), which processes the garbage bytes and passes them to
request_key() to construct a SID string, potentially leaking kernel
stack contents to the userspace idmap daemon.

Fix this by checking the return value and skipping the SID-to-id
mapping when parsing fails.  The remaining fattr fields (timestamps,
mode, etc.) are populated directly from the 'info' pointer so they
are unaffected.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Closes: https://sashiko.dev/#/patchset/20260906181540.647469-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/readdir.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 9ca859a2451ea..fb537a1ceb8b4 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -243,8 +243,9 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		    struct cifs_sb_info *cifs_sb)
 {
 	struct smb2_posix_info_parsed parsed;
+	int rc;
 
-	posix_info_parse(info, NULL, &parsed);
+	rc = posix_info_parse(info, NULL, &parsed);
 
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_uniqueid = le64_to_cpu(info->Inode);
@@ -281,8 +282,15 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		 le32_to_cpu(info->ReparseTag),
 		 le32_to_cpu(info->Mode));
 
-	sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
-	sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+	if (rc < 0) {
+		cifs_dbg(VFS, "%s: failed to parse SIDs: %d\n",
+			 __func__, rc);
+	} else {
+		sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
+		sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
+	}
 }
 
 static void __dir_info_to_fattr(struct cifs_fattr *fattr, const void *info)
-- 
2.53.0



