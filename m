Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A701185924;
	Fri, 15 Nov 2024 06:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653292; cv=none; b=tdRTUTU1ZHaAZnKDWGIYelthI80lsL8GIpylT3qAgUrS2r7B0LzMW9RV6Yb41xzQy3MGQ7PCQe/TwTwhRMU+Nr+9/39xxCZvExuusMyZ5NDh2oZ1jULhbbKaBVR7km2pLxX6kszsk2q43s3HAohINQk7+pd3MI8X5FcJgHEqo8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653292; c=relaxed/simple;
	bh=7oU9UCuC26pVdt7hOJueueyH3I4FQ0PTt9AVScZmzUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xt5H9IbCBjWAGsjns3UoikHR0PEg3NNyzcwt0eQMlx2cdK9FcaFUgZrXt/AWJp5L3ySYnPGqJwwTK6ljvrvyvezffiEdHpD7nrOrBxxjTdBWEB8NAwawjUQaoByzPOvt97Hh2VUQlSgh1ZnT9+e4PuaRIoc5PUn1J/zsm/eVh8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enU9p2Ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enU9p2Ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20545C4CECF;
	Fri, 15 Nov 2024 06:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653292;
	bh=7oU9UCuC26pVdt7hOJueueyH3I4FQ0PTt9AVScZmzUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enU9p2Mltmi7toIh25kzjRViGPDV/PAXcIWWNRXZ26oTNP3crU1g2rr2vHh4c9zEC
	 jwLusGI3juUn+ZE6z7Er478s4li4dyoBk+KBU/EzxCzUhUKU9r+GIrj7hxBdXQA6sP
	 6ALIQKOEJ8cECFrXAtSf736whahu1XTxLICjDpZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com,
	Alessandro Zanni <alessandro.zanni87@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 44/63] fs: Fix uninitialized value issue in from_kuid and from_kgid
Date: Fri, 15 Nov 2024 07:38:07 +0100
Message-ID: <20241115063727.503931085@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Zanni <alessandro.zanni87@gmail.com>

[ Upstream commit 15f34347481648a567db67fb473c23befb796af5 ]

ocfs2_setattr() uses attr->ia_mode, attr->ia_uid and attr->ia_gid in
a trace point even though ATTR_MODE, ATTR_UID and ATTR_GID aren't set.

Initialize all fields of newattrs to avoid uninitialized variables, by
checking if ATTR_MODE, ATTR_UID, ATTR_GID are initialized, otherwise 0.

Reported-by: syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6c55f725d1bdc8c52058
Signed-off-by: Alessandro Zanni <alessandro.zanni87@gmail.com>
Link: https://lore.kernel.org/r/20241017120553.55331-1-alessandro.zanni87@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 02d2beb7ddb95..c6d0d17a759c1 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1128,9 +1128,12 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	trace_ocfs2_setattr(inode, dentry,
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    dentry->d_name.len, dentry->d_name.name,
-			    attr->ia_valid, attr->ia_mode,
-			    from_kuid(&init_user_ns, attr->ia_uid),
-			    from_kgid(&init_user_ns, attr->ia_gid));
+			    attr->ia_valid,
+				attr->ia_valid & ATTR_MODE ? attr->ia_mode : 0,
+				attr->ia_valid & ATTR_UID ?
+					from_kuid(&init_user_ns, attr->ia_uid) : 0,
+				attr->ia_valid & ATTR_GID ?
+					from_kgid(&init_user_ns, attr->ia_gid) : 0);
 
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))
-- 
2.43.0



