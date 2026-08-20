Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F33147ECC8;
	Thu, 20 Aug 2026 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247608; cv=none; b=qBFJAGjD9gsZHeS0rjoY7w4sSJWMPBz1hikFFj3DnWR/bZ2Q4Jv1+n7OuZ7NlxKH3M9GD1d2DvMFTG0mKReNZBCQv6Jsju9PpLyub4T4GCPi4ocQiT6sEO9KgqTirjYIN6z8uEfUcYHbjfvhP1WJw7TMGX0751hJPwZi1PyWPlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247608; c=relaxed/simple;
	bh=sKwChpzvePc3c0jnmZePxNvU9YayhkhYDIJOKevghks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUiAHSbDWndGA0jdZMj4M/JBJ+KeqUPDB8YoZFbIEkXQp+W8XLPxa2K3ReJLrIPVWZ273ve7hhXfsBmWI3mNfCqAXZXLfUtTfDi1vX+m/HhCscZKreILPyXh+oVi5inoN0l/dmPnlMhOk0bwMoh/uMXHDezdI+IBKykn0SjaLgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8obIIl5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8obIIl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F4A1F000E9;
	Thu, 20 Aug 2026 17:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247607;
	bh=DVXTmcvnVUBXtX1w4Ovdoq2qrMMT1SYSyeGU54oIoi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8obIIl5eOJbxFm1NGyOIkBOhvzxaNsONv6q9jp2d++UG/Un5XzyFP+ikG9BUSijg
	 KyngCirU0R3dr5nkreYZS4J9sMee0V29FfMCKCAbzPlhdlaUSI7ozb21TiTtVVai4x
	 fYI+EaYF+It3WFszyzAe061QE/ilCfX90sS3CjVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/166] overflow: Change DEFINE_FLEX to take __counted_by member
Date: Thu, 20 Aug 2026 16:56:03 +0200
Message-ID: <20260820145214.292458934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit d8e45f2929b94099913eb66c3ebb18b5063e9421 ]

The norm should be flexible array structures with __counted_by
annotations, so DEFINE_FLEX() is updated to expect that. Rename
the non-annotated version to DEFINE_RAW_FLEX(), and update the
few existing users. Additionally add selftests for the macros.

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20240306235128.it.933-kees@kernel.org
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: cdc36db204ff ("Bluetooth: hci_sync: Fix advertising data UAFs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c |   10 ++---
 include/linux/overflow.h                    |   52 ++++++++++++++++++++++++++++
 lib/overflow_kunit.c                        |   19 ++++++++++
 3 files changed, 76 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1812,7 +1812,7 @@ ice_aq_alloc_free_vsi_list(struct ice_hw
 			   enum ice_sw_lkup_type lkup_type,
 			   enum ice_adminq_opc opc)
 {
-	DEFINE_FLEX(struct ice_aqc_alloc_free_res_elem, sw_buf, elem, 1);
+	DEFINE_RAW_FLEX(struct ice_aqc_alloc_free_res_elem, sw_buf, elem, 1);
 	u16 buf_len = __struct_size(sw_buf);
 	struct ice_aqc_res_elem *vsi_ele;
 	int status;
@@ -2082,7 +2082,7 @@ ice_aq_get_recipe_to_profile(struct ice_
  */
 int ice_alloc_recipe(struct ice_hw *hw, u16 *rid)
 {
-	DEFINE_FLEX(struct ice_aqc_alloc_free_res_elem, sw_buf, elem, 1);
+	DEFINE_RAW_FLEX(struct ice_aqc_alloc_free_res_elem, sw_buf, elem, 1);
 	u16 buf_len = __struct_size(sw_buf);
 	int status;
 
@@ -4425,7 +4425,7 @@ int
 ice_alloc_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
 		   u16 *counter_id)
 {
-	DEFINE_FLEX(struct ice_aqc_alloc_free_res_elem, buf, elem, 1);
+	DEFINE_RAW_FLEX(struct ice_aqc_alloc_free_res_elem, buf, elem, 1);
 	u16 buf_len = __struct_size(buf);
 	int status;
 
@@ -4453,7 +4453,7 @@ int
 ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
 		  u16 counter_id)
 {
-	DEFINE_FLEX(struct ice_aqc_alloc_free_res_elem, buf, elem, 1);
+	DEFINE_RAW_FLEX(struct ice_aqc_alloc_free_res_elem, buf, elem, 1);
 	u16 buf_len = __struct_size(buf);
 	int status;
 
@@ -4483,7 +4483,7 @@ ice_free_res_cntr(struct ice_hw *hw, u8
  */
 int ice_share_res(struct ice_hw *hw, u16 type, u8 shared, u16 res_id)
 {
-	DEFINE_FLEX(struct ice_aqc_alloc_free_res_elem, buf, elem, 1);
+	DEFINE_RAW_FLEX(struct ice_aqc_alloc_free_res_elem, buf, elem, 1);
 	u16 buf_len = __struct_size(buf);
 	int status;
 
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -311,4 +311,56 @@ static inline size_t __must_check size_s
 #define struct_size_t(type, member, count)					\
 	struct_size((type *)NULL, member, count)
 
+/**
+ * _DEFINE_FLEX() - helper macro for DEFINE_FLEX() family.
+ * Enables caller macro to pass (different) initializer.
+ *
+ * @type: structure type name, including "struct" keyword.
+ * @name: Name for a variable to define.
+ * @member: Name of the array member.
+ * @count: Number of elements in the array; must be compile-time const.
+ * @initializer: initializer expression (could be empty for no init).
+ */
+#define _DEFINE_FLEX(type, name, member, count, initializer...)			\
+	_Static_assert(__builtin_constant_p(count),				\
+		       "onstack flex array members require compile-time const count"); \
+	union {									\
+		u8 bytes[struct_size_t(type, member, count)];			\
+		type obj;							\
+	} name##_u initializer;							\
+	type *name = (type *)&name##_u
+
+/**
+ * DEFINE_RAW_FLEX() - Define an on-stack instance of structure with a trailing
+ * flexible array member, when it does not have a __counted_by annotation.
+ *
+ * @type: structure type name, including "struct" keyword.
+ * @name: Name for a variable to define.
+ * @member: Name of the array member.
+ * @count: Number of elements in the array; must be compile-time const.
+ *
+ * Define a zeroed, on-stack, instance of @type structure with a trailing
+ * flexible array member.
+ * Use __struct_size(@name) to get compile-time size of it afterwards.
+ */
+#define DEFINE_RAW_FLEX(type, name, member, count)	\
+	_DEFINE_FLEX(type, name, member, count, = {})
+
+/**
+ * DEFINE_FLEX() - Define an on-stack instance of structure with a trailing
+ * flexible array member.
+ *
+ * @TYPE: structure type name, including "struct" keyword.
+ * @NAME: Name for a variable to define.
+ * @MEMBER: Name of the array member.
+ * @COUNTER: Name of the __counted_by member.
+ * @COUNT: Number of elements in the array; must be compile-time const.
+ *
+ * Define a zeroed, on-stack, instance of @TYPE structure with a trailing
+ * flexible array member.
+ * Use __struct_size(@NAME) to get compile-time size of it afterwards.
+ */
+#define DEFINE_FLEX(TYPE, NAME, MEMBER, COUNTER, COUNT)	\
+	_DEFINE_FLEX(TYPE, NAME, MEMBER, COUNT, = { .obj.COUNTER = COUNT, })
+
 #endif /* __LINUX_OVERFLOW_H */
--- a/lib/overflow_kunit.c
+++ b/lib/overflow_kunit.c
@@ -1113,6 +1113,24 @@ static void castable_to_type_test(struct
 #undef TEST_CASTABLE_TO_TYPE
 }
 
+struct foo {
+	int a;
+	u32 counter;
+	s16 array[] __counted_by(counter);
+};
+
+static void DEFINE_FLEX_test(struct kunit *test)
+{
+	DEFINE_RAW_FLEX(struct foo, two, array, 2);
+	DEFINE_FLEX(struct foo, eight, array, counter, 8);
+	DEFINE_FLEX(struct foo, empty, array, counter, 0);
+
+	KUNIT_EXPECT_EQ(test, __struct_size(two),
+			sizeof(struct foo) + sizeof(s16) + sizeof(s16));
+	KUNIT_EXPECT_EQ(test, __struct_size(eight), 24);
+	KUNIT_EXPECT_EQ(test, __struct_size(empty), sizeof(struct foo));
+}
+
 static struct kunit_case overflow_test_cases[] = {
 	KUNIT_CASE(u8_u8__u8_overflow_test),
 	KUNIT_CASE(s8_s8__s8_overflow_test),
@@ -1135,6 +1153,7 @@ static struct kunit_case overflow_test_c
 	KUNIT_CASE(overflows_type_test),
 	KUNIT_CASE(same_type_test),
 	KUNIT_CASE(castable_to_type_test),
+	KUNIT_CASE(DEFINE_FLEX_test),
 	{}
 };
 


