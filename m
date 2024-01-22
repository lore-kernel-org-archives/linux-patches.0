Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723DD132C35;
	Tue, 23 Jan 2024 00:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969126; cv=none; b=CHQpYBiLQaLXcroPIKI9O4+FRjxXzNAsLq2bAkd9/ITQhxtLg5s1A/2nRiat+943jCpd5T5dMBGS920XI+vWLicodHJvotN5vV+SoLlH6ewNSMxjm/qXcN61fxq2Ch4QvWBgnlCXBW+Bc5VKdzw9q+IUaYewbjS5gHHMuMkk77s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969126; c=relaxed/simple;
	bh=HknaY7IH+tITcHXZPbmJPQYNaj8voNhPj1/AwLu5MLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfvZvDx3wjnk6xLkHzhQYJEctavVmanizwUmliIjrJsEWsvvpO6FHzxIRc1kSVl9zcv6a/FBkaECt7C3zCgl3j8tUun+7GeGS63pLc2LQoucu2QYat4ZQj/YbO65RGhYfERthCLzDFq287TX2b8SC/E2UhOCSt7aHcuAhaPux5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLaFcP71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLaFcP71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320EAC433A6;
	Tue, 23 Jan 2024 00:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969126;
	bh=HknaY7IH+tITcHXZPbmJPQYNaj8voNhPj1/AwLu5MLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLaFcP71sPhZhAlHOiM0fcTFl/g/S+59ktUF9Sje6ARguJnbKwPC2SEy0BX4vwgFF
	 LnJeUpLqhDv16oRjlgoa1A1Dpe1LIIg6pZp79cZGsx9IJ+33LErqEdca9u9r4GxoMe
	 75Tu2M484yHl6DhpdP/ZUifs7DVi1jyXQ85Y9nQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rae Moar <rmoar@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 038/641] kunit: debugfs: Handle errors from alloc_string_stream()
Date: Mon, 22 Jan 2024 15:49:02 -0800
Message-ID: <20240122235819.270742408@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 1557e89d3af51a4f1bd6870b3117bed651de5dbf ]

In kunit_debugfs_create_suite() give up and skip creating the debugfs
file if any of the alloc_string_stream() calls return an error or NULL.
Only put a value in the log pointer of kunit_suite and kunit_test if it
is a valid pointer to a log.

This prevents the potential invalid dereference reported by smatch:

 lib/kunit/debugfs.c:115 kunit_debugfs_create_suite() error: 'suite->log'
	dereferencing possible ERR_PTR()
 lib/kunit/debugfs.c:119 kunit_debugfs_create_suite() error: 'test_case->log'
	dereferencing possible ERR_PTR()

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 05e2006ce493 ("kunit: Use string_stream for test log")
Reviewed-by: Rae Moar <rmoar@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/debugfs.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/lib/kunit/debugfs.c b/lib/kunit/debugfs.c
index 5bfc18ad5fff..382706dfb47d 100644
--- a/lib/kunit/debugfs.c
+++ b/lib/kunit/debugfs.c
@@ -111,14 +111,28 @@ static const struct file_operations debugfs_results_fops = {
 void kunit_debugfs_create_suite(struct kunit_suite *suite)
 {
 	struct kunit_case *test_case;
+	struct string_stream *stream;
 
-	/* Allocate logs before creating debugfs representation. */
-	suite->log = alloc_string_stream(GFP_KERNEL);
-	string_stream_set_append_newlines(suite->log, true);
+	/*
+	 * Allocate logs before creating debugfs representation.
+	 * The suite->log and test_case->log pointer are expected to be NULL
+	 * if there isn't a log, so only set it if the log stream was created
+	 * successfully.
+	 */
+	stream = alloc_string_stream(GFP_KERNEL);
+	if (IS_ERR_OR_NULL(stream))
+		return;
+
+	string_stream_set_append_newlines(stream, true);
+	suite->log = stream;
 
 	kunit_suite_for_each_test_case(suite, test_case) {
-		test_case->log = alloc_string_stream(GFP_KERNEL);
-		string_stream_set_append_newlines(test_case->log, true);
+		stream = alloc_string_stream(GFP_KERNEL);
+		if (IS_ERR_OR_NULL(stream))
+			goto err;
+
+		string_stream_set_append_newlines(stream, true);
+		test_case->log = stream;
 	}
 
 	suite->debugfs = debugfs_create_dir(suite->name, debugfs_rootdir);
@@ -126,6 +140,12 @@ void kunit_debugfs_create_suite(struct kunit_suite *suite)
 	debugfs_create_file(KUNIT_DEBUGFS_RESULTS, S_IFREG | 0444,
 			    suite->debugfs,
 			    suite, &debugfs_results_fops);
+	return;
+
+err:
+	string_stream_destroy(suite->log);
+	kunit_suite_for_each_test_case(suite, test_case)
+		string_stream_destroy(test_case->log);
 }
 
 void kunit_debugfs_destroy_suite(struct kunit_suite *suite)
-- 
2.43.0



