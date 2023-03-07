Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B9CBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9B9C433D2;
	Tue,  7 Mar 2023 18:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215496;
	bh=Gr6ITl5YURZoEGZKTpTytwqn985BylCEAgPKBZxGhHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YP2NWpBEvTzmGUj8sVxfUI0rLer6pF8lm8rgP0VUUO9hPHnnVz3UyO7fzLjxlpmhl
	 cIDIXhKHLoWTPbMDy4yMszEjF+LDyl0zJ1O4fcbpSfrUBV5uceJLcCdzWi8MetNxTe
	 sTE+OL1rVHM7huD9C0QgTxztSZyOCra1gaXz4sMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 280/567] kobject: modify kobject_get_path() to take a const *
Date: Tue,  7 Mar 2023 18:00:16 +0100
Message-Id: <20230307165918.035102796@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index ea30529fba08a..d38916e598a59 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -116,7 +116,7 @@ extern void kobject_put(struct kobject *kobj);
 extern const void *kobject_namespace(struct kobject *kobj);
 extern void kobject_get_ownership(struct kobject *kobj,
 				  kuid_t *uid, kgid_t *gid);
-extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
+extern char *kobject_get_path(const struct kobject *kobj, gfp_t flag);
 
 /**
  * kobject_has_children - Returns whether a kobject has children.
diff --git a/lib/kobject.c b/lib/kobject.c
index ea53b30cf4837..94ff7fd5d80bc 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -126,10 +126,10 @@ static int create_dir(struct kobject *kobj)
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
@@ -144,9 +144,9 @@ static int get_kobj_path_length(struct kobject *kobj)
 	return length;
 }
 
-static void fill_kobj_path(struct kobject *kobj, char *path, int length)
+static void fill_kobj_path(const struct kobject *kobj, char *path, int length)
 {
-	struct kobject *parent;
+	const struct kobject *parent;
 
 	--length;
 	for (parent = kobj; parent; parent = parent->parent) {
@@ -168,7 +168,7 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
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



