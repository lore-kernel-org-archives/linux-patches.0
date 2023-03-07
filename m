Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C888BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1DBC433D2;
	Tue,  7 Mar 2023 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213239;
	bh=V5JZlLOhCSOG5H+xZRDw0QXOabOtSOhHsuxVANlYX6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5yDPbS8Ae9SXsEBv5OrPlgXkB2CcY7RxQwDL9gwSm6zodAoD7DwzVyi/Mf3geV/Z
	 E3yWD2KllkXpgV2JI5bzWNJtJUqjg502L9TZy/lxL/opPHM5OcoRUkL8aqm8i84tuh
	 hZiOqAvBNgk2sehMs6zO254YyZ22r0s7laHguEZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 413/885] kobject: modify kobject_get_path() to take a const *
Date: Tue,  7 Mar 2023 17:55:47 +0100
Message-Id: <20230307170020.370274738@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 33a0a1e3b3d17445832177981dc7a1c6a5b009f8 ]

kobject_get_path() does not modify the kobject passed to it, so make the
pointer constant.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Link: https://lore.kernel.org/r/20221001165315.2690141-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 3bb2a01caa81 ("kobject: Fix slab-out-of-bounds in fill_kobj_path()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kobject.h |  2 +-
 lib/kobject.c           | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 57fb972fea05b..592f9785b058a 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -115,7 +115,7 @@ extern void kobject_put(struct kobject *kobj);
 extern const void *kobject_namespace(struct kobject *kobj);
 extern void kobject_get_ownership(struct kobject *kobj,
 				  kuid_t *uid, kgid_t *gid);
-extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
+extern char *kobject_get_path(const struct kobject *kobj, gfp_t flag);
 
 struct kobj_type {
 	void (*release)(struct kobject *kobj);
diff --git a/lib/kobject.c b/lib/kobject.c
index a0b2dbfcfa233..0380ec889a6af 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -94,10 +94,10 @@ static int create_dir(struct kobject *kobj)
 	return 0;
 }
 
-static int get_kobj_path_length(struct kobject *kobj)
+static int get_kobj_path_length(const struct kobject *kobj)
 {
 	int length = 1;
-	struct kobject *parent = kobj;
+	const struct kobject *parent = kobj;
 
 	/* walk up the ancestors until we hit the one pointing to the
 	 * root.
@@ -112,9 +112,9 @@ static int get_kobj_path_length(struct kobject *kobj)
 	return length;
 }
 
-static void fill_kobj_path(struct kobject *kobj, char *path, int length)
+static void fill_kobj_path(const struct kobject *kobj, char *path, int length)
 {
-	struct kobject *parent;
+	const struct kobject *parent;
 
 	--length;
 	for (parent = kobj; parent; parent = parent->parent) {
@@ -136,7 +136,7 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
  *
  * Return: The newly allocated memory, caller must free with kfree().
  */
-char *kobject_get_path(struct kobject *kobj, gfp_t gfp_mask)
+char *kobject_get_path(const struct kobject *kobj, gfp_t gfp_mask)
 {
 	char *path;
 	int len;
-- 
2.39.2



