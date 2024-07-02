Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F461BD005;
	Tue,  2 Jul 2024 17:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941567; cv=none; b=iTjF+I+XbksqqcvprOWjY6A6Ue6JmUlsSadUX0wPHdLxL3C7bM/Kc+RakpdxO3T594rwq4QrTVntWqSE6lXv8RZciuF6KTSmdmyNNHWrgvWf15JxTNgezWgrLySvoMWaBnKJncQLVfpBF5k5G7y3B3aiUFSQ5OA/ny+yyKiIB34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941567; c=relaxed/simple;
	bh=DRGus4GGmavnF5Mo3bgJmRikgsUCj1B7M43f0QWZ66o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SX8xWPYd3TSXehi1WTSEh+ny+YQ9r6Wu+P9DoMkac5KXa96wBu5XlnRp5FfkAyrA4WElKyNRfzwVi+31Bfg+NMXdOrPytiFImwVhF/XzgYVQOLQRCHrFDZZxjP87J6HtPK0EV7lUHMtJHros1F4532JeCJ4Yleklo5kAB2DqoMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RU2WmZXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RU2WmZXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811F9C116B1;
	Tue,  2 Jul 2024 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941566;
	bh=DRGus4GGmavnF5Mo3bgJmRikgsUCj1B7M43f0QWZ66o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RU2WmZXYl8CoCErXe+b3ljZRojCUtyYFWC03KLjCKM46YdhWSTvR2mgg5a2dLLpwb
	 Zj1FeniUDlWWibd+CEUKW3wCwUiBd8zrmuW8dP113o6oIiZpfsFncd9Kjyhbp2fpbP
	 qVRSC8IJtIXZnNKoiliUENYqTZULS0QnJAOAiORo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/128] ima: Fix use-after-free on a dentrys dname.name
Date: Tue,  2 Jul 2024 19:04:22 +0200
Message-ID: <20240702170228.541271536@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Berger <stefanb@linux.ibm.com>

[ Upstream commit be84f32bb2c981ca670922e047cdde1488b233de ]

->d_name.name can change on rename and the earlier value can be freed;
there are conditions sufficient to stabilize it (->d_lock on dentry,
->d_lock on its parent, ->i_rwsem exclusive on the parent's inode,
rename_lock), but none of those are met at any of the sites. Take a stable
snapshot of the name instead.

Link: https://lore.kernel.org/all/20240202182732.GE2087318@ZenIV/
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_api.c          |   16 ++++++++++++----
 security/integrity/ima/ima_template_lib.c |   17 ++++++++++++++---
 2 files changed, 26 insertions(+), 7 deletions(-)

--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -244,8 +244,8 @@ int ima_collect_measurement(struct integ
 	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
 	struct inode *real_inode = d_real_inode(file_dentry(file));
-	const char *filename = file->f_path.dentry->d_name.name;
 	struct ima_max_digest_data hash;
+	struct name_snapshot filename;
 	int result = 0;
 	int length;
 	void *tmpbuf;
@@ -319,9 +319,13 @@ out:
 		if (file->f_flags & O_DIRECT)
 			audit_cause = "failed(directio)";
 
+		take_dentry_name_snapshot(&filename, file->f_path.dentry);
+
 		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
-				    filename, "collect_data", audit_cause,
-				    result, 0);
+				    filename.name.name, "collect_data",
+				    audit_cause, result, 0);
+
+		release_dentry_name_snapshot(&filename);
 	}
 	return result;
 }
@@ -434,6 +438,7 @@ out:
  */
 const char *ima_d_path(const struct path *path, char **pathbuf, char *namebuf)
 {
+	struct name_snapshot filename;
 	char *pathname = NULL;
 
 	*pathbuf = __getname();
@@ -447,7 +452,10 @@ const char *ima_d_path(const struct path
 	}
 
 	if (!pathname) {
-		strscpy(namebuf, path->dentry->d_name.name, NAME_MAX);
+		take_dentry_name_snapshot(&filename, path->dentry);
+		strscpy(namebuf, filename.name.name, NAME_MAX);
+		release_dentry_name_snapshot(&filename);
+
 		pathname = namebuf;
 	}
 
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -483,7 +483,10 @@ static int ima_eventname_init_common(str
 				     bool size_limit)
 {
 	const char *cur_filename = NULL;
+	struct name_snapshot filename;
 	u32 cur_filename_len = 0;
+	bool snapshot = false;
+	int ret;
 
 	BUG_ON(event_data->filename == NULL && event_data->file == NULL);
 
@@ -496,7 +499,10 @@ static int ima_eventname_init_common(str
 	}
 
 	if (event_data->file) {
-		cur_filename = event_data->file->f_path.dentry->d_name.name;
+		take_dentry_name_snapshot(&filename,
+					  event_data->file->f_path.dentry);
+		snapshot = true;
+		cur_filename = filename.name.name;
 		cur_filename_len = strlen(cur_filename);
 	} else
 		/*
@@ -505,8 +511,13 @@ static int ima_eventname_init_common(str
 		 */
 		cur_filename_len = IMA_EVENT_NAME_LEN_MAX;
 out:
-	return ima_write_template_field_data(cur_filename, cur_filename_len,
-					     DATA_FMT_STRING, field_data);
+	ret = ima_write_template_field_data(cur_filename, cur_filename_len,
+					    DATA_FMT_STRING, field_data);
+
+	if (snapshot)
+		release_dentry_name_snapshot(&filename);
+
+	return ret;
 }
 
 /*


