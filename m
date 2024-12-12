Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3631B53365;
	Thu, 12 Dec 2024 17:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023548; cv=none; b=e0h8Citk3FbCBSomme0oB1LYU8IiHNXRb0DfOsA1w9ViIxdAg8iQEdqq2z/96lvBRTJbwUl9tnINqF3Z47wPpnAYmbcsrqQkNNHZ5rIo43OXZH6Z9f5LRmnzbF5f6rMjOhLGsBjcuOdeZXUS9eVZbk7x9Gm8kTVNNHIEgc+1xzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023548; c=relaxed/simple;
	bh=FSOxS61Jx4JQ07BupQcXEcxu7GqFv39bnjUIvvrR+5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsFdpXYLAE+YVtKjWcsp5n/sJ63d+Ld+SkU+evlTxC0gWZ+zps9wURZ5ymjD47NlE3tGz1+7gffACRm8cWIYVRDNhZekhWtE9CRWQL/jXzpPcBYxLhMjHeBfIXA1AFf1nEo0k81le8AN2dpJhWZiHPYbOtQHg1rtQYUe0ZG1e64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeqtcTC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeqtcTC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ED8C4CED0;
	Thu, 12 Dec 2024 17:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023548;
	bh=FSOxS61Jx4JQ07BupQcXEcxu7GqFv39bnjUIvvrR+5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeqtcTC2Z06a86n7twLnTIN3GSrspykJyH0YQykSAIXT7kv8iRc3x2N9RosIqwRU8
	 q8UWMWKrFjTt+1Ih4tiKnVqkY+xZIdAYaJVVO+ZddkXgvlSQaNkSxH8JNAd/sUbDbN
	 k3TBNUloYtnqN6p9LGkQ/JKIg3IBKqZKwKYVoGew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Libo Chen <libo.chen.cn@windriver.com>
Subject: [PATCH 5.15 551/565] ima: Fix use-after-free on a dentrys dname.name
Date: Thu, 12 Dec 2024 16:02:26 +0100
Message-ID: <20241212144333.638001631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Libo Chen <libo.chen.cn@windriver.com>
---
 security/integrity/ima/ima_api.c          |   16 ++++++++++++----
 security/integrity/ima/ima_template_lib.c |   17 ++++++++++++++---
 2 files changed, 26 insertions(+), 7 deletions(-)

--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -217,7 +217,7 @@ int ima_collect_measurement(struct integ
 	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
 	struct inode *real_inode = d_real_inode(file_dentry(file));
-	const char *filename = file->f_path.dentry->d_name.name;
+	struct name_snapshot filename;
 	int result = 0;
 	int length;
 	void *tmpbuf;
@@ -280,9 +280,13 @@ out:
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
@@ -395,6 +399,7 @@ out:
  */
 const char *ima_d_path(const struct path *path, char **pathbuf, char *namebuf)
 {
+	struct name_snapshot filename;
 	char *pathname = NULL;
 
 	*pathbuf = __getname();
@@ -408,7 +413,10 @@ const char *ima_d_path(const struct path
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
@@ -426,7 +426,10 @@ static int ima_eventname_init_common(str
 				     bool size_limit)
 {
 	const char *cur_filename = NULL;
+	struct name_snapshot filename;
 	u32 cur_filename_len = 0;
+	bool snapshot = false;
+	int ret;
 
 	BUG_ON(event_data->filename == NULL && event_data->file == NULL);
 
@@ -439,7 +442,10 @@ static int ima_eventname_init_common(str
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
@@ -448,8 +454,13 @@ static int ima_eventname_init_common(str
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


