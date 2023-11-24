Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71082511F;
	Fri, 24 Nov 2023 18:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoeGhEKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C1FC433C8;
	Fri, 24 Nov 2023 18:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849910;
	bh=Fq5FgvaqaT5AeH5dIpJ0uq6TG1QwLIPuDP7ueyHMKsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoeGhEKRuJ6QHoKi8VSdZK5kPhb+cGKbO4OVBQ/1UEQWb/X9kN0xEC19f9OBx+ebj
	 SQxr4+OvcYx075hgTBMZ4I45jyFzHUsdlAu2zXyVuhp9vjqLIfT7OsXm76rJaISw+H
	 F0h1WE5vU6hz7tJTdyhycLH8oqmoOeTPs7JLB8SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 369/530] selftests/clone3: Fix broken test under !CONFIG_TIME_NS
Date: Fri, 24 Nov 2023 17:48:55 +0000
Message-ID: <20231124172039.237597080@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit fc7f04dc23db50206bee7891516ed4726c3f64cf upstream.

When execute the following command to test clone3 under !CONFIG_TIME_NS:

  # make headers && cd tools/testing/selftests/clone3 && make && ./clone3

we can see the following error info:

  # [7538] Trying clone3() with flags 0x80 (size 0)
  # Invalid argument - Failed to create new process
  # [7538] clone3() with flags says: -22 expected 0
  not ok 18 [7538] Result (-22) is different than expected (0)
  ...
  # Totals: pass:18 fail:1 xfail:0 xpass:0 skip:0 error:0

This is because if CONFIG_TIME_NS is not set, but the flag
CLONE_NEWTIME (0x80) is used to clone a time namespace, it
will return -EINVAL in copy_time_ns().

If kernel does not support CONFIG_TIME_NS, /proc/self/ns/time
will be not exist, and then we should skip clone3() test with
CLONE_NEWTIME.

With this patch under !CONFIG_TIME_NS:

  # make headers && cd tools/testing/selftests/clone3 && make && ./clone3
  ...
  # Time namespaces are not supported
  ok 18 # SKIP Skipping clone3() with CLONE_NEWTIME
  ...
  # Totals: pass:18 fail:0 xfail:0 xpass:0 skip:1 error:0

Link: https://lkml.kernel.org/r/1689066814-13295-1-git-send-email-yangtiezhu@loongson.cn
Fixes: 515bddf0ec41 ("selftests/clone3: test clone3 with CLONE_NEWTIME")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/clone3/clone3.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/clone3/clone3.c
+++ b/tools/testing/selftests/clone3/clone3.c
@@ -196,7 +196,12 @@ int main(int argc, char *argv[])
 			CLONE3_ARGS_NO_TEST);
 
 	/* Do a clone3() in a new time namespace */
-	test_clone3(CLONE_NEWTIME, 0, 0, CLONE3_ARGS_NO_TEST);
+	if (access("/proc/self/ns/time", F_OK) == 0) {
+		test_clone3(CLONE_NEWTIME, 0, 0, CLONE3_ARGS_NO_TEST);
+	} else {
+		ksft_print_msg("Time namespaces are not supported\n");
+		ksft_test_result_skip("Skipping clone3() with CLONE_NEWTIME\n");
+	}
 
 	/* Do a clone3() with exit signal (SIGCHLD) in flags */
 	test_clone3(SIGCHLD, 0, -EINVAL, CLONE3_ARGS_NO_TEST);


