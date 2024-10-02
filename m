Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFE71CCEDA;
	Wed,  2 Oct 2024 14:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879101; cv=none; b=VDho113SFGPIQqR3/dlvZfKSI9Y3VBpsaTRlccbILMbeHnDyIsKhc0/VOSJ49JsqKcJbR3HUiiKVOZT3KixsoUuaNxnyZG3NcdaHEgzfxKcOVWPdUSWT8wKtHeR7mJcKlUCPGQnOhfJMaDxCIVC5oG06rjGx6uR4jt8sU8Ue2co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879101; c=relaxed/simple;
	bh=4Rx/ymzpGp24IiWa7ymDal4rPSCEH6PO3EBXIpkh9zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7PURV/GlYVcAiLMC45MSQiFk1Fa534ynh1O4aUsvuxwV5PXe19081tCQBriUay8Yo5+bQcr3bhR/EalhQBZ4tgV1C8u9qBCYQt8boS1EWcfEgg3LtzSfjl/i3cvhKxYADlTpSt9Ye9WrgW5yxFmd+He2KIxgPq8WJ3RzvP5t2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhONMudu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhONMudu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6953C4CEC5;
	Wed,  2 Oct 2024 14:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879101;
	bh=4Rx/ymzpGp24IiWa7ymDal4rPSCEH6PO3EBXIpkh9zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhONMudua0BGS10AtE08XOep4w+XU/1w61/oZmIZNgtl+XwSW4LXnszQhsmwdvgNf
	 PFQQK6X6R3pVbQ1R/ugOKnfwT5yfJlTN5LozMBWir1+Uh5EF2QZIBxZtQqMZTTZgHu
	 1nYAB+C7pCJoSrMrJHf9wAxLqQXO9FuPc3H3dwQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@sandeen.net>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 611/634] fs_parse: add uid & gid option option parsing helpers
Date: Wed,  2 Oct 2024 15:01:51 +0200
Message-ID: <20241002125835.235591914@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 9f111059e725f7ca79a136bfc734da3c8c1838b4 ]

Multiple filesystems take uid and gid as options, and the code to
create the ID from an integer and validate it is standard boilerplate
that can be moved into common helper functions, so do that for
consistency and less cut&paste.

This also helps avoid the buggy pattern noted by Seth Jenkins at
https://lore.kernel.org/lkml/CALxfFW4BXhEwxR0Q5LSkg-8Vb4r2MONKCcUCVioehXQKr35eHg@mail.gmail.com/
because uid/gid parsing will fail before any assignment in most
filesystems.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Link: https://lore.kernel.org/r/de859d0a-feb9-473d-a5e2-c195a3d47abb@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 3a987b88a425 ("debugfs show actual source in /proc/mounts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/mount_api.rst |  9 +++++--
 fs/fs_parser.c                          | 34 +++++++++++++++++++++++++
 include/linux/fs_parser.h               |  6 ++++-
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/mount_api.rst b/Documentation/filesystems/mount_api.rst
index 9aaf6ef75eb53..317934c9e8fca 100644
--- a/Documentation/filesystems/mount_api.rst
+++ b/Documentation/filesystems/mount_api.rst
@@ -645,6 +645,8 @@ The members are as follows:
 	fs_param_is_blockdev	Blockdev path		* Needs lookup
 	fs_param_is_path	Path			* Needs lookup
 	fs_param_is_fd		File descriptor		result->int_32
+	fs_param_is_uid		User ID (u32)           result->uid
+	fs_param_is_gid		Group ID (u32)          result->gid
 	=======================	=======================	=====================
 
      Note that if the value is of fs_param_is_bool type, fs_parse() will try
@@ -678,6 +680,8 @@ The members are as follows:
 	fsparam_bdev()		fs_param_is_blockdev
 	fsparam_path()		fs_param_is_path
 	fsparam_fd()		fs_param_is_fd
+	fsparam_uid()		fs_param_is_uid
+	fsparam_gid()		fs_param_is_gid
 	=======================	===============================================
 
      all of which take two arguments, name string and option number - for
@@ -784,8 +788,9 @@ process the parameters it is given.
      option number (which it returns).
 
      If successful, and if the parameter type indicates the result is a
-     boolean, integer or enum type, the value is converted by this function and
-     the result stored in result->{boolean,int_32,uint_32,uint_64}.
+     boolean, integer, enum, uid, or gid type, the value is converted by this
+     function and the result stored in
+     result->{boolean,int_32,uint_32,uint_64,uid,gid}.
 
      If a match isn't initially made, the key is prefixed with "no" and no
      value is present then an attempt will be made to look up the key with the
diff --git a/fs/fs_parser.c b/fs/fs_parser.c
index a4d6ca0b8971e..24727ec34e5aa 100644
--- a/fs/fs_parser.c
+++ b/fs/fs_parser.c
@@ -308,6 +308,40 @@ int fs_param_is_fd(struct p_log *log, const struct fs_parameter_spec *p,
 }
 EXPORT_SYMBOL(fs_param_is_fd);
 
+int fs_param_is_uid(struct p_log *log, const struct fs_parameter_spec *p,
+		    struct fs_parameter *param, struct fs_parse_result *result)
+{
+	kuid_t uid;
+
+	if (fs_param_is_u32(log, p, param, result) != 0)
+		return fs_param_bad_value(log, param);
+
+	uid = make_kuid(current_user_ns(), result->uint_32);
+	if (!uid_valid(uid))
+		return inval_plog(log, "Invalid uid '%s'", param->string);
+
+	result->uid = uid;
+	return 0;
+}
+EXPORT_SYMBOL(fs_param_is_uid);
+
+int fs_param_is_gid(struct p_log *log, const struct fs_parameter_spec *p,
+		    struct fs_parameter *param, struct fs_parse_result *result)
+{
+	kgid_t gid;
+
+	if (fs_param_is_u32(log, p, param, result) != 0)
+		return fs_param_bad_value(log, param);
+
+	gid = make_kgid(current_user_ns(), result->uint_32);
+	if (!gid_valid(gid))
+		return inval_plog(log, "Invalid gid '%s'", param->string);
+
+	result->gid = gid;
+	return 0;
+}
+EXPORT_SYMBOL(fs_param_is_gid);
+
 int fs_param_is_blockdev(struct p_log *log, const struct fs_parameter_spec *p,
 		  struct fs_parameter *param, struct fs_parse_result *result)
 {
diff --git a/include/linux/fs_parser.h b/include/linux/fs_parser.h
index d3350979115f0..6cf713a7e6c6f 100644
--- a/include/linux/fs_parser.h
+++ b/include/linux/fs_parser.h
@@ -28,7 +28,7 @@ typedef int fs_param_type(struct p_log *,
  */
 fs_param_type fs_param_is_bool, fs_param_is_u32, fs_param_is_s32, fs_param_is_u64,
 	fs_param_is_enum, fs_param_is_string, fs_param_is_blob, fs_param_is_blockdev,
-	fs_param_is_path, fs_param_is_fd;
+	fs_param_is_path, fs_param_is_fd, fs_param_is_uid, fs_param_is_gid;
 
 /*
  * Specification of the type of value a parameter wants.
@@ -57,6 +57,8 @@ struct fs_parse_result {
 		int		int_32;		/* For spec_s32/spec_enum */
 		unsigned int	uint_32;	/* For spec_u32{,_octal,_hex}/spec_enum */
 		u64		uint_64;	/* For spec_u64 */
+		kuid_t		uid;
+		kgid_t		gid;
 	};
 };
 
@@ -131,6 +133,8 @@ static inline bool fs_validate_description(const char *name,
 #define fsparam_bdev(NAME, OPT)	__fsparam(fs_param_is_blockdev, NAME, OPT, 0, NULL)
 #define fsparam_path(NAME, OPT)	__fsparam(fs_param_is_path, NAME, OPT, 0, NULL)
 #define fsparam_fd(NAME, OPT)	__fsparam(fs_param_is_fd, NAME, OPT, 0, NULL)
+#define fsparam_uid(NAME, OPT) __fsparam(fs_param_is_uid, NAME, OPT, 0, NULL)
+#define fsparam_gid(NAME, OPT) __fsparam(fs_param_is_gid, NAME, OPT, 0, NULL)
 
 /* String parameter that allows empty argument */
 #define fsparam_string_empty(NAME, OPT) \
-- 
2.43.0



