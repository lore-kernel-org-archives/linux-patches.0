Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB6D1D0DE1;
	Wed,  2 Oct 2024 14:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877657; cv=none; b=l2N1jwr0MIXCFOhzmAs+Kh5CAquSOcJTTPUa2KnJhbq1Xxw+6YO+XVEVcW9DQ0DQKiqmNXx2i6rATQHRTSmtbm1VbgNaayIGaK+QDW3+3duWtUlM7SJB9KsjXg1TKJEkrKBUpfh7mCNEPo49xJy8kty1Unod+Qz3+UemVQjEN0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877657; c=relaxed/simple;
	bh=vAHmIDZO+Myv1o3OwwsVDsM2XQiTNgIdtZ2HJ4M79fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBVCouFQJlliFbnhWzDJw73y59Bez4cTVA89wV309ywlupM60SZeP3xXqSWpIs8VBmAuLqBqomDQl8XDjPqAdY73f0nACi38MpasDi/2z5I/7Q0O4/LYW8HxeFiowfWvGJlvSX1901njMUlMO2iaDKK9eHfsw3a+raiND8nhA3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSeP89Mu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSeP89Mu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FFDC4CEC2;
	Wed,  2 Oct 2024 14:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877657;
	bh=vAHmIDZO+Myv1o3OwwsVDsM2XQiTNgIdtZ2HJ4M79fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSeP89Mui2e4zPVRHUrsCm69DkzBNI31kuO29SNKvz2I10Qnx+eE5EBH57hZU+llU
	 H9gLimgOZbehdvxBaZg0nBc6+W3GgAEl0BhCGGpjwWawvskjV8FheRN36neWNLJCU4
	 UEO5NFbueDzwDyJs8eelJ34JkP7Nqx9bBkJB0wf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 150/634] selftests/ftrace: Fix test to handle both old and new kernels
Date: Wed,  2 Oct 2024 14:54:10 +0200
Message-ID: <20241002125817.031650924@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



