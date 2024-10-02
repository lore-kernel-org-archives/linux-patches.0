Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C261316F84F;
	Wed,  2 Oct 2024 13:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875628; cv=none; b=FcXoIZ52G+4kDGU19JpnYbCrZbmAIxxvw0L00GCVBYd5osBfECmnQNLAcsjzE3GpUUqUgABNfYebhAGJupD+npSCSOvnpsDIFeIFeqbPZXZag9wIu05JaKNmRh9jOHI9T4jpB3pAhOcwbquwUicZJo0qyKcVi3ji/9NFat363mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875628; c=relaxed/simple;
	bh=2oiofkuZoBgXiEQCs1ux50v4Zm6eC7inKcxcMSHrV9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdBMfdDtAaDBuCaVNRnoPLhJGoLTiDO25Iw49NlbRXDK+F0n9gGmkftDHiGSBOmdIGJR9FSI73N5o31YmarmlK/9wvXAzpVYYPUAA5G6u6WQnCSwhNFeQqn44MVIK+vN8Kz/MaJZYe9ROwR3HTEAnOufa058X9rfz5fqrnHxwaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vqaiyw/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vqaiyw/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4514FC4CECE;
	Wed,  2 Oct 2024 13:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875628;
	bh=2oiofkuZoBgXiEQCs1ux50v4Zm6eC7inKcxcMSHrV9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vqaiyw/cFlbd49nUAI/f/BMK0IaMqZCJGNo8CfZvmu/qrAflcjlfqt4LIzU0YQPW8
	 +7GyAiRMROx4eBf7+sXIbTxWLSWIm907BL2DPsrFRdQk4pW7vach+AzZZUAJZq6K2C
	 +pLEE4j+266dlvrjWFiqDqHdI3P+pbsXOJTc9RXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 167/695] selftests/ftrace: Fix test to handle both old and new kernels
Date: Wed,  2 Oct 2024 14:52:45 +0200
Message-ID: <20241002125829.142254944@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit c049acee3c71cfc26c739f82617a84e13e471a45 ]

The function "scheduler_tick" was renamed to "sched_tick" and a selftest
that used that function for testing function trace filtering used that
function as part of the test.

But the change causes it to fail when run on older kernels. As tests
should not fail on older kernels, add a check to see which name is
available before testing.

Fixes: 86dd6c04ef9f ("sched/balancing: Rename scheduler_tick() => sched_tick()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ftrace/test.d/ftrace/func_set_ftrace_file.tc         | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
index 073a748b9380a..263f6b798c853 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
@@ -19,7 +19,14 @@ fail() { # mesg
 
 FILTER=set_ftrace_filter
 FUNC1="schedule"
-FUNC2="sched_tick"
+if grep '^sched_tick\b' available_filter_functions; then
+    FUNC2="sched_tick"
+elif grep '^scheduler_tick\b' available_filter_functions; then
+    FUNC2="scheduler_tick"
+else
+    exit_unresolved
+fi
+
 
 ALL_FUNCS="#### all functions enabled ####"
 
-- 
2.43.0



