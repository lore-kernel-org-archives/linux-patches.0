Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6123330B06;
	Fri, 17 Oct 2025 15:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716594; cv=none; b=jN0jtZrl1Llbk5FtTsDObeJqrWuGyUJKanHqULUzl2UxXbSOEMaxsbiCuEU1v+15vCQRRvkwUHae6F+aqbgIr7ki9D5h3FteimSDgSlz8WjghofD1ecYYSegKpQ2QeMlg9okt1909TZufPt/XBhLM3fCA/pY1lX4rj+c6KF2VJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716594; c=relaxed/simple;
	bh=xlbISFRy47Kr18mKHyeTbDS9WSnonMQNt6r8ms5FbGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THw6wOGuVHcp7KyF6q58+iSOoMbHR7lxhEsKqUSiuFaIqGcL2Sw72iYJf3ZSWyCQQSXGAfiNGFGTWIczOup8v+MjilgjDaJehTPzDelpW5eK0qgFna2QpfuNE3p0559K7sm/bV1depaXl6iCpuJGa91n4rNygkB4AKB+kDcFjEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsZ7jZU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsZ7jZU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBD5C4CEE7;
	Fri, 17 Oct 2025 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716594;
	bh=xlbISFRy47Kr18mKHyeTbDS9WSnonMQNt6r8ms5FbGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsZ7jZU+uTLyhmvwsPzDgFHRnnfJ8bu5JF6PWJHkYXlgj+ezCprfOx7tv9uAaFr6/
	 Cr3kJ9WrcUwHeXOBUZaADNf4pYAFPcRTZGT7CBfa3FfaYjyI0Acez9rdSDeRVzSS8A
	 2N8X2cuhYYF5wtkrZl7BUSewfqREO18OwfErI74M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.15 243/276] minmax: deduplicate __unconst_integer_typeof()
Date: Fri, 17 Oct 2025 16:55:36 +0200
Message-ID: <20251017145151.344343479@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5e57418a2031cd5e1863efdf3d7447a16a368172 ]

It appears that compiler_types.h already have an implementation of the
__unconst_integer_typeof() called __unqual_scalar_typeof().  Use it
instead of the copy.

Link: https://lkml.kernel.org/r/20230911154913.4176033-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -169,27 +169,6 @@
 #define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
 /*
- * Remove a const qualifier from integer types
- * _Generic(foo, type-name: association, ..., default: association) performs a
- * comparison against the foo type (not the qualified type).
- * Do not use the const keyword in the type-name as it will not match the
- * unqualified type of foo.
- */
-#define __unconst_integer_type_cases(type)	\
-	unsigned type:  (unsigned type)0,	\
-	signed type:    (signed type)0
-
-#define __unconst_integer_typeof(x) typeof(			\
-	_Generic((x),						\
-		char: (char)0,					\
-		__unconst_integer_type_cases(char),		\
-		__unconst_integer_type_cases(short),		\
-		__unconst_integer_type_cases(int),		\
-		__unconst_integer_type_cases(long),		\
-		__unconst_integer_type_cases(long long),	\
-		default: (x)))
-
-/*
  * Do not check the array parameter using __must_be_array().
  * In the following legit use-case where the "array" passed is a simple pointer,
  * __must_be_array() will return a failure.
@@ -203,13 +182,13 @@
  * 'int *buff' and 'int buff[N]' types.
  *
  * The array can be an array of const items.
- * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * typeof() keeps the const qualifier. Use __unqual_scalar_typeof() in order
  * to discard the const qualifier for the __element variable.
  */
 #define __minmax_array(op, array, len) ({				\
 	typeof(&(array)[0]) __array = (array);				\
 	typeof(len) __len = (len);					\
-	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	__unqual_scalar_typeof(__array[0]) __element = __array[--__len];\
 	while (__len--)							\
 		__element = op(__element, __array[__len]);		\
 	__element; })


