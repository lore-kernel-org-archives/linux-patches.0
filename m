Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695D31CF284;
	Wed,  2 Oct 2024 13:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875643; cv=none; b=gWolbYEZcupTpTpDQqQXZOG49kPRGr6tytzrNlNz2E+ev6uchgDe3TcYWlGZRhhmi5naR/LgJTaDOKAl6jvdzmKZIfiCoLVA4aVQu/yyk2Wixn3p7C7DrE8JiMfbLYYs7gZ7jhMeDSeKHYrYpQC4a7oAGUTpTdGPQKZoRBEkVbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875643; c=relaxed/simple;
	bh=ZEbWzWeYRWvBHpSN7nDGWb6KXAAMPLC4CUK9ZFGyERE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpDoQhQDZYl9g9zgtViiWMMz+XcvxYEoy+1J9owD/w7OxCVi63+1BRiBEez33pefRZk1UwNp0xvk7zqUeZjHIsQ9u2tZEzkyohggU/Zi0sevr3tBvEA3JVz8WTVtPoBbwHoS8NRiP4YboZ6nBTG95v7sCxcfH2KXy1/EEGVtEFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaJ9OCuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaJ9OCuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E734FC4CECD;
	Wed,  2 Oct 2024 13:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875643;
	bh=ZEbWzWeYRWvBHpSN7nDGWb6KXAAMPLC4CUK9ZFGyERE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaJ9OCuEQauFKC3FMOJZfVfHN0SCy09Ps0qO7gfgls7iyOyAZveRaQpu9rz1giS+3
	 I6GSpZJmdSk2296+/uoalU91rA/irN13n3pvT5Gemg/PB8mE56XV4h2sX/v5Bvpu9C
	 ItNRXPFR2nzaRLDUV7CIZo0nIZ9a7uCM6/zwqRu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 171/695] selftests/ftrace: Fix eventfs ownership testcase to find mount point
Date: Wed,  2 Oct 2024 14:52:49 +0200
Message-ID: <20241002125829.298124917@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit f0a6ecebd858658df213d114b0530f8f0b96e396 ]

Fix eventfs ownership testcase to find mount point if stat -c "%m" failed.
This can happen on the system based on busybox. In this case, this will
try to use the current working directory, which should be a tracefs top
directory (and eventfs is mounted as a part of tracefs.)
If it does not work, the test is skipped as UNRESOLVED because of
the environmental problem.

Fixes: ee9793be08b1 ("tracing/selftests: Add ownership modification tests for eventfs")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ftrace/test.d/00basic/test_ownership.tc          | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc b/tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc
index c45094d1e1d2d..803efd7b56c77 100644
--- a/tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc
+++ b/tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc
@@ -6,6 +6,18 @@ original_group=`stat -c "%g" .`
 original_owner=`stat -c "%u" .`
 
 mount_point=`stat -c '%m' .`
+
+# If stat -c '%m' does not work (e.g. busybox) or failed, try to use the
+# current working directory (which should be a tracefs) as the mount point.
+if [ ! -d "$mount_point" ]; then
+	if mount | grep -qw $PWD ; then
+		mount_point=$PWD
+	else
+		# If PWD doesn't work, that is an environmental problem.
+		exit_unresolved
+	fi
+fi
+
 mount_options=`mount | grep "$mount_point" | sed -e 's/.*(\(.*\)).*/\1/'`
 
 # find another owner and group that is not the original
-- 
2.43.0



