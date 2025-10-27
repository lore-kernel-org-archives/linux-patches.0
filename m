Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFC9324B06;
	Mon, 27 Oct 2025 18:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591442; cv=none; b=Fhsg28PwuxC15IAABFkBWxeSXAnUC18oxyk/DZKYTg+7QqNLag19U7aFfsY9oN2BNKkPAVcFiyjSYmxN0o7CBMfYAa6kkjW3MInvCCQHZzD9PSbtaW9ZRQMDOzj99vXR620J0fRh8LpQONVp7BVEWLGGSb6spfAMu3ArmPh967g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591442; c=relaxed/simple;
	bh=OAxXj7IZiNN4arw3pa24yHWhf1vCA7JXKAZocIeoy8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3OunLf15ZeBQwY2PFfTEFKoEdWS1nmvlDasbTChCXlzMM3lroPwAo32XW9XM5pJIU4SM2WkyNuobzWOesQ28EdAwhtVwxhmWx+z+nVcm3SsCdgDQ9mnpnva5g3dMgVeTa/UXtYuhk2WzazfACl4oLdUhHbMIgNgmU2rFfu+ank=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ju1AkwVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ju1AkwVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB088C4CEF1;
	Mon, 27 Oct 2025 18:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591442;
	bh=OAxXj7IZiNN4arw3pa24yHWhf1vCA7JXKAZocIeoy8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ju1AkwVXb7rNh0mic5waMdxE869uhEuj8yEzNSTfWztf0mqgLVblJdkCvWc/XOyJG
	 cE4lteBnYuRqSSoR1RCaxdpy6UHqgoHVvo92KAQ99CPL8RWTUTfJHd9FKMyXGSi8v5
	 spigboZEn3lQooH8enxIE0ODwm4gW9mvVD6zBwbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Mark Brown <broonie@kernel.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 199/332] minmax: Introduce {min,max}_array()
Date: Mon, 27 Oct 2025 19:34:12 +0100
Message-ID: <20251027183529.959956533@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit c952c748c7a983a8bda9112984e6f2c1f6e441a5 ]

Introduce min_array() (resp max_array()) in order to get the
minimal (resp maximum) of values present in an array.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20230623085830.749991-8-herve.codina@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   64 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -151,6 +151,70 @@
  */
 #define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
 
+/*
+ * Remove a const qualifier from integer types
+ * _Generic(foo, type-name: association, ..., default: association) performs a
+ * comparison against the foo type (not the qualified type).
+ * Do not use the const keyword in the type-name as it will not match the
+ * unqualified type of foo.
+ */
+#define __unconst_integer_type_cases(type)	\
+	unsigned type:  (unsigned type)0,	\
+	signed type:    (signed type)0
+
+#define __unconst_integer_typeof(x) typeof(			\
+	_Generic((x),						\
+		char: (char)0,					\
+		__unconst_integer_type_cases(char),		\
+		__unconst_integer_type_cases(short),		\
+		__unconst_integer_type_cases(int),		\
+		__unconst_integer_type_cases(long),		\
+		__unconst_integer_type_cases(long long),	\
+		default: (x)))
+
+/*
+ * Do not check the array parameter using __must_be_array().
+ * In the following legit use-case where the "array" passed is a simple pointer,
+ * __must_be_array() will return a failure.
+ * --- 8< ---
+ * int *buff
+ * ...
+ * min = min_array(buff, nb_items);
+ * --- 8< ---
+ *
+ * The first typeof(&(array)[0]) is needed in order to support arrays of both
+ * 'int *buff' and 'int buff[N]' types.
+ *
+ * The array can be an array of const items.
+ * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * to discard the const qualifier for the __element variable.
+ */
+#define __minmax_array(op, array, len) ({				\
+	typeof(&(array)[0]) __array = (array);				\
+	typeof(len) __len = (len);					\
+	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	while (__len--)							\
+		__element = op(__element, __array[__len]);		\
+	__element; })
+
+/**
+ * min_array - return minimum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define min_array(array, len) __minmax_array(min, array, len)
+
+/**
+ * max_array - return maximum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define max_array(array, len) __minmax_array(max, array, len)
+
 /**
  * clamp_t - return a value clamped to a given range using a given type
  * @type: the type of variable to use


