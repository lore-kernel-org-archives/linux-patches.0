Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF2425F787;
	Tue, 11 Mar 2025 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707205; cv=none; b=Wp8cY/qa7AE1SrzpDm+bbunS+Ij+6np1mi7awuomj0t1Fmegwa7zt0oOP2kBE834gboE/0YmxLFR1AQGy5Jr2LvoKeMOIp9tRLP5jnlZMuJ765JzzXp6uHTD9P+tZf39k2gewD0WZHAMuNB47+vzNEyfmzVTA6woSVH9dEThkgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707205; c=relaxed/simple;
	bh=CVrOb7i60bhQO1IDKRU+f0OX10S6yvOvqGoQXnW0At8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBxntGZVdQzJZlvgk8PLSwb0RgY9ZFvVbyGiXjrUHSwaqdbdVn+ZLS7IJxZndWk1dMnqqMTMqX0E2lERGxfr08sFzxUUEfs98PdoMqZG5T8ySSkLolPKammltXuGB3oRatzcOif1EZTVhbgePnH6hwRa7SUGMJdVvN9UH45a/Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIJ7wXh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIJ7wXh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB3FC4CEE9;
	Tue, 11 Mar 2025 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707204;
	bh=CVrOb7i60bhQO1IDKRU+f0OX10S6yvOvqGoQXnW0At8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIJ7wXh5FgzC6rbNQD0Cl0wZSo3X9FfjdjnT6mTTEFOtX9d1SjJnIYC2grQQZIY+d
	 yX0vpZWhgf+BVMyhr54UYnIxsFc0uxZkAXTiW7EV+pnTE9NgD5kBm5Q408zTLCOKaX
	 vqdeqv1F2imqI96SjaZWriw9I8I3dmWn6KhZ95sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Subject: [PATCH 5.10 308/462] ima: Fix use-after-free on a dentrys dname.name
Date: Tue, 11 Mar 2025 15:59:34 +0100
Message-ID: <20250311145810.527195746@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Berger <stefanb@linux.ibm.com>

commit be84f32bb2c981ca670922e047cdde1488b233de upstream.

->d_name.name can change on rename and the earlier value can be freed;
there are conditions sufficient to stabilize it (->d_lock on dentry,
->d_lock on its parent, ->i_rwsem exclusive on the parent's inode,
rename_lock), but none of those are met at any of the sites. Take a stable
snapshot of the name instead.

Link: https://lore.kernel.org/all/20240202182732.GE2087318@ZenIV/
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
[ Samasth: bp to fix CVE-2024-39494; Minor conflict resolved due to code context change ]
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_api.c          |   16 ++++++++++++----
 security/integrity/ima/ima_template_lib.c |   17 ++++++++++++++---
 2 files changed, 26 insertions(+), 7 deletions(-)

--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -213,7 +213,7 @@ int ima_collect_measurement(struct integ
 	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
 	struct inode *real_inode = d_real_inode(file_dentry(file));
-	const char *filename = file->f_path.dentry->d_name.name;
+	struct name_snapshot filename;
 	int result = 0;
 	int length;
 	void *tmpbuf;
@@ -276,9 +276,13 @@ out:
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
@@ -391,6 +395,7 @@ out:
  */
 const char *ima_d_path(const struct path *path, char **pathbuf, char *namebuf)
 {
+	struct name_snapshot filename;
 	char *pathname = NULL;
 
 	*pathbuf = __getname();
@@ -404,7 +409,10 @@ const char *ima_d_path(const struct path
 	}
 
 	if (!pathname) {
-		strlcpy(namebuf, path->dentry->d_name.name, NAME_MAX);
+		take_dentry_name_snapshot(&filename, path->dentry);
+		strscpy(namebuf, filename.name.name, NAME_MAX);
+		release_dentry_name_snapshot(&filename);
+
 		pathname = namebuf;
 	}
 
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -385,7 +385,10 @@ static int ima_eventname_init_common(str
 				     bool size_limit)
 {
 	const char *cur_filename = NULL;
+	struct name_snapshot filename;
 	u32 cur_filename_len = 0;
+	bool snapshot = false;
+	int ret;
 
 	BUG_ON(event_data->filename == NULL && event_data->file == NULL);
 
@@ -398,7 +401,10 @@ static int ima_eventname_init_common(str
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
@@ -407,8 +413,13 @@ static int ima_eventname_init_common(str
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


