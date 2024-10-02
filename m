Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E871D12E8;
	Wed,  2 Oct 2024 14:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877672; cv=none; b=BLGjBWvYBUv4oRysxImobfJgSB0MtRivRYp4GcbPLfj0rK2BqnqPe3ZVg75RA1AaxGmCyQAcVC74oJI14FXrf4+Psm4f5a0dPEDxsMLae9UOD+9EAJfhtXCdS5bsc4mOlQlN/YFj85tq7lsSUqtzHOyGoat6MwF7DlsvlRKFjmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877672; c=relaxed/simple;
	bh=hfkFIWDkjKuAXkGi4ZeoGka0gItEFWOUXcq2Zw8Hk3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRaTq0GoqM4K+jVzJy/RZLaucrwDuC4j6D9A85M78wC4qfJgdLDd60NnO1RJofI4Zn2ACbjx6pANyAR2/fYsMUU1NCQSLxdaia/GfD3o+BbEK0vOxH2IlF1dEPFeDvColJlvkScsTANGYENoWz8exzUiWkv8F6nRIDrlbFKgcBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEY8Ch98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEY8Ch98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6B5C4CEC2;
	Wed,  2 Oct 2024 14:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877671;
	bh=hfkFIWDkjKuAXkGi4ZeoGka0gItEFWOUXcq2Zw8Hk3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEY8Ch98Ynh0mnY0g/dqCm4Hz67DXdLztsVJdL1DumNHmtsmIILRFwxW9t5QC/HO5
	 mK+IK40/KlhoU9dDF1DSv4Jrfj203kW29xvU4kdvgjfLc23f83RjaEe2t416oWUeKI
	 7zSc2ASBWGXZBCecEUCq0LPWqR3i5maQYmHV5LKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 154/634] selftests/ftrace: Fix eventfs ownership testcase to find mount point
Date: Wed,  2 Oct 2024 14:54:14 +0200
Message-ID: <20241002125817.188857098@linuxfoundation.org>
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



