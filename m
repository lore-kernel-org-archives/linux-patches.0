Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5B930FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43048C433C7;
	Wed, 20 Sep 2023 12:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212597;
	bh=VqXnn+b58Ur8m9C/0upHB1oq698ryWW0SaRt4iIpB/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdbGLDMsdJWbI0yREeBN+SyAVSUFDyZ0nnEeJFVe3qBNkVu51OjiVhY4hkCIU46QF
	 x4fF1rs1ZzaxDcltC4X2n7hspkQzlhdXFmu4AU4CEme15hv9+NpdREDew+qJYxbqNf
	 untbYKHVrJYN9HJNt0mbUvfoqozZYptjE1AIXdKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 61/83] selftests: tracing: Fix to unmount tracefs for recovering environment
Date: Wed, 20 Sep 2023 13:31:51 +0200
Message-ID: <20230920112829.070598142@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112826.634178162@linuxfoundation.org>
References: <20230920112826.634178162@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 7e021da80f48582171029714f8a487347f29dddb ]

Fix to unmount the tracefs if the ftracetest mounted it for recovering
system environment. If the tracefs is already mounted, this does nothing.

Suggested-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/all/29fce076-746c-4650-8358-b4e0fa215cf7@sirena.org.uk/
Fixes: cbd965bde74c ("ftrace/selftests: Return the skip code when tracing directory not configured in kernel")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/ftracetest | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index 8ec1922e974eb..55314cd197ab9 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -30,6 +30,9 @@ err_ret=1
 # kselftest skip code is 4
 err_skip=4
 
+# umount required
+UMOUNT_DIR=""
+
 # cgroup RT scheduling prevents chrt commands from succeeding, which
 # induces failures in test wakeup tests.  Disable for the duration of
 # the tests.
@@ -44,6 +47,9 @@ setup() {
 
 cleanup() {
   echo $sched_rt_runtime_orig > $sched_rt_runtime
+  if [ -n "${UMOUNT_DIR}" ]; then
+    umount ${UMOUNT_DIR} ||:
+  fi
 }
 
 errexit() { # message
@@ -155,11 +161,13 @@ if [ -z "$TRACING_DIR" ]; then
 	    mount -t tracefs nodev /sys/kernel/tracing ||
 	      errexit "Failed to mount /sys/kernel/tracing"
 	    TRACING_DIR="/sys/kernel/tracing"
+	    UMOUNT_DIR=${TRACING_DIR}
 	# If debugfs exists, then so does /sys/kernel/debug
 	elif [ -d "/sys/kernel/debug" ]; then
 	    mount -t debugfs nodev /sys/kernel/debug ||
 	      errexit "Failed to mount /sys/kernel/debug"
 	    TRACING_DIR="/sys/kernel/debug/tracing"
+	    UMOUNT_DIR=${TRACING_DIR}
 	else
 	    err_ret=$err_skip
 	    errexit "debugfs and tracefs are not configured in this kernel"
-- 
2.40.1



