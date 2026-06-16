Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C213DD851;
	Tue, 16 Jun 2026 19:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636779; cv=none; b=OCUXiQIbCfFdzlTyr0AliokqfU/5B5Zq8zVJwZhB7OxUpTTKvNWxjLRGI8377FiusJQsZbgTyQp52vjmXlWTIT9Sc3WPl05umUtxH4e86hAc/qlyIV6rBoQ5rZZ1USQYphxUfliUFcxxcb/YoxwUEfGTJLcuBTkp+dnhQaoh0Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636779; c=relaxed/simple;
	bh=DF45VYnJBUnYIAO/ftz5JXNas7wIgU6+yCQPUd1SUMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvniqxJhx1AQTaCo1WZlYBvuERMJkDPRDLeCU9sUoOy3Q2tS0qAJOc7bXiKP3umvrvnjAMGALAIHqq9hsH2DWlhKbfUVWK/Ozj9llDyfuSi8cCy2ixaNf3wPu4Po+2ZrJU/PKSf+9zT6bn2q8XDHGqDo73eTA/Q/39rU9BFLwhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUmEyzJ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUmEyzJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300D41F000E9;
	Tue, 16 Jun 2026 19:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636778;
	bh=MnnqQ3iuvXPmxnVokH+BIuN2YnazWzK4awqFHNsUkho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUmEyzJ82PjthpnPgM9xBP0vDNiz5pvPgPykkHt039YXYnTnKyrPK336zkMRvDQzw
	 JDbpoHQAP9hJB8iGVS5RinU2ppM2cyWIen6W0dz5RwYc6PxZJGG4RscmAJngoDo6f7
	 kQZKSXnvCHZXTQSvQU6z5BvfNIP+Da9fjnCTjEmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 303/342] thunderbolt: property: Cap recursion depth in __tb_property_parse_dir()
Date: Tue, 16 Jun 2026 20:29:59 +0530
Message-ID: <20260616145102.545549072@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 928abe19fbf0127003abcb1ea69cabc1c897d0ab ]

A DIRECTORY entry's value field is used as the dir_offset for a
recursive call into __tb_property_parse_dir() with no depth counter.
A crafted peer that chains DIRECTORY entries into a back-reference
loop drives the parser until the kernel stack is exhausted and the
guard page fires.  Any untrusted XDomain peer (cable, dock, in-line
inspector, adjacent host) that reaches the PROPERTIES_REQUEST
control-plane exchange can trigger this without authentication.

Thread a depth counter through tb_property_parse() and
__tb_property_parse_dir(), and reject blocks that exceed
TB_PROPERTY_MAX_DEPTH = 8.  That is comfortably larger than any
observed legitimate XDomain layout.

Operators who do not need XDomain host-to-host discovery can disable
the path entirely with thunderbolt.xdomain=0 on the kernel command
line.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/property.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -35,10 +35,11 @@ struct tb_property_dir_entry {
 };
 
 #define TB_PROPERTY_ROOTDIR_MAGIC	0x55584401
+#define TB_PROPERTY_MAX_DEPTH		8
 
 static struct tb_property_dir *__tb_property_parse_dir(const u32 *block,
 	size_t block_len, unsigned int dir_offset, size_t dir_len,
-	bool is_root);
+	bool is_root, unsigned int depth);
 
 static inline void parse_dwdata(void *dst, const void *src, size_t dwords)
 {
@@ -99,7 +100,8 @@ tb_property_alloc(const char *key, enum
 }
 
 static struct tb_property *tb_property_parse(const u32 *block, size_t block_len,
-					const struct tb_property_entry *entry)
+					const struct tb_property_entry *entry,
+					unsigned int depth)
 {
 	char key[TB_PROPERTY_KEY_SIZE + 1];
 	struct tb_property *property;
@@ -120,7 +122,7 @@ static struct tb_property *tb_property_p
 	switch (property->type) {
 	case TB_PROPERTY_TYPE_DIRECTORY:
 		dir = __tb_property_parse_dir(block, block_len, entry->value,
-					      entry->length, false);
+					      entry->length, false, depth + 1);
 		if (!dir) {
 			kfree(property);
 			return NULL;
@@ -165,13 +167,17 @@ static struct tb_property *tb_property_p
 }
 
 static struct tb_property_dir *__tb_property_parse_dir(const u32 *block,
-	size_t block_len, unsigned int dir_offset, size_t dir_len, bool is_root)
+	size_t block_len, unsigned int dir_offset, size_t dir_len, bool is_root,
+	unsigned int depth)
 {
 	const struct tb_property_entry *entries;
 	size_t i, content_len, nentries;
 	unsigned int content_offset;
 	struct tb_property_dir *dir;
 
+	if (depth > TB_PROPERTY_MAX_DEPTH)
+		return NULL;
+
 	dir = kzalloc(sizeof(*dir), GFP_KERNEL);
 	if (!dir)
 		return NULL;
@@ -206,7 +212,7 @@ static struct tb_property_dir *__tb_prop
 	for (i = 0; i < nentries; i++) {
 		struct tb_property *property;
 
-		property = tb_property_parse(block, block_len, &entries[i]);
+		property = tb_property_parse(block, block_len, &entries[i], depth);
 		if (!property) {
 			tb_property_free_dir(dir);
 			return NULL;
@@ -243,7 +249,7 @@ struct tb_property_dir *tb_property_pars
 		return NULL;
 
 	return __tb_property_parse_dir(block, block_len, 0, rootdir->length,
-				       true);
+				       true, 0);
 }
 
 /**


