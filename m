Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA01028383
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3uSLg7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56388C433C9;
	Wed, 15 Nov 2023 19:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077434;
	bh=LTrlHBEmERhJ+ku6cK206NaD0t/V/L/QhRfpP6iR+u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3uSLg7CRo3PdiPvNtN/BPyehT0Yf8I3si3RTbfyGPoBtFfq22NRHV5ZglChntike
	 CVjk2pAJGIV/gqkfAVtVJHTp7vPMAVjL+y1dORDsN89ODO1UAuMJnzsTVhqaa65Vx1
	 /evgGnBYO+PyhHmWxnB0fJ1Xuu4BH3/Unw6iMsn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Rae Moar <rmoar@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 301/603] kunit: Fix possible memory leak in kunit_filter_suites()
Date: Wed, 15 Nov 2023 14:14:06 -0500
Message-ID: <20231115191634.218860645@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 24de14c98b37ea40a7e493dfd0d93b400b6efbca ]

If the outer layer for loop is iterated more than once and it fails not
in the first iteration, the filtered_suite and filtered_suite->test_cases
allocated in the last kunit_filter_attr_tests() in last inner for loop
is leaked.

So add a new free_filtered_suite err label and free the filtered_suite
and filtered_suite->test_cases so far. And change kmalloc_array of copy
to kcalloc to Clear the copy to make the kfree safe.

Fixes: 529534e8cba3 ("kunit: Add ability to filter attributes")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Rae Moar <rmoar@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/executor.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/lib/kunit/executor.c b/lib/kunit/executor.c
index 9358ed2df8395..1236b3cd2fbb2 100644
--- a/lib/kunit/executor.c
+++ b/lib/kunit/executor.c
@@ -157,10 +157,11 @@ kunit_filter_suites(const struct kunit_suite_set *suite_set,
 	struct kunit_suite_set filtered = {NULL, NULL};
 	struct kunit_glob_filter parsed_glob;
 	struct kunit_attr_filter *parsed_filters = NULL;
+	struct kunit_suite * const *suites;
 
 	const size_t max = suite_set->end - suite_set->start;
 
-	copy = kmalloc_array(max, sizeof(*filtered.start), GFP_KERNEL);
+	copy = kcalloc(max, sizeof(*filtered.start), GFP_KERNEL);
 	if (!copy) { /* won't be able to run anything, return an empty set */
 		return filtered;
 	}
@@ -195,7 +196,7 @@ kunit_filter_suites(const struct kunit_suite_set *suite_set,
 					parsed_glob.test_glob);
 			if (IS_ERR(filtered_suite)) {
 				*err = PTR_ERR(filtered_suite);
-				goto free_parsed_filters;
+				goto free_filtered_suite;
 			}
 		}
 		if (filter_count > 0 && parsed_filters != NULL) {
@@ -212,11 +213,11 @@ kunit_filter_suites(const struct kunit_suite_set *suite_set,
 				filtered_suite = new_filtered_suite;
 
 				if (*err)
-					goto free_parsed_filters;
+					goto free_filtered_suite;
 
 				if (IS_ERR(filtered_suite)) {
 					*err = PTR_ERR(filtered_suite);
-					goto free_parsed_filters;
+					goto free_filtered_suite;
 				}
 				if (!filtered_suite)
 					break;
@@ -231,6 +232,14 @@ kunit_filter_suites(const struct kunit_suite_set *suite_set,
 	filtered.start = copy_start;
 	filtered.end = copy;
 
+free_filtered_suite:
+	if (*err) {
+		for (suites = copy_start; suites < copy; suites++) {
+			kfree((*suites)->test_cases);
+			kfree(*suites);
+		}
+	}
+
 free_parsed_filters:
 	if (filter_count)
 		kfree(parsed_filters);
-- 
2.42.0



