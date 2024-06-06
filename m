Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7B719AA5C;
	Thu,  6 Jun 2024 14:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683029; cv=none; b=jh5EwzSjjW4VIfgtBrqRP8/cVVYRtLxsnoOjCG9IhujRUkzOCgQDnEzSPfPVXE43YfVoI02SbXcmZMpz/zWEYrv00qjzv4Kb7oMfSe6OdT98z3O/o0pJYGh9bFC+Sc1sw30pcFtLyyzBKN+9otDzwN7YXP+6bAMlmzpftOElKEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683029; c=relaxed/simple;
	bh=eNE7NWfYPr/gY5KIOl12D9npsrK175Xy0KckwFewDIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYSOfxbRWcwO3Eqkykr+ZtHgLT0g1yByniDi5HVu2cIeG1VbhJOdBx27qUcpZnbn+yP3ZFFolUaTlvewEe5Vucvae+6Vq5kE5gz/5aM8BsjRlQN5rRufc0Neeo1+Go/ep32VEVXcbneLsBEuR3U4XZ15A+5PERrCgidm+rIHfJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnaIv7+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnaIv7+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E8DC32781;
	Thu,  6 Jun 2024 14:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683028;
	bh=eNE7NWfYPr/gY5KIOl12D9npsrK175Xy0KckwFewDIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnaIv7+J0BcFJNPUeKY9Z7rvs/+MLXFo4oZPzqv+I9mj4kIx/KSOFKi0/7O1Pv0Dt
	 7uVrtB1YfwvHoIGbjD5bAQgd07f6hL+xhHCBoQhANkOhjX5/9nSLd0f4ZDElah3sFM
	 IlSWx0Sap21RMpKXuZvZJl6nX8h45PiO28Ay6e5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Petr Machata <petrm@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 250/374] selftests: net: Unify code of busywait() and slowwait()
Date: Thu,  6 Jun 2024 16:03:49 +0200
Message-ID: <20240606131700.197785975@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit a4022a332f437ae5b10921d66058ce98a2db2c20 ]

Bodies of busywait() and slowwait() functions are almost identical. Extract
the common code into a helper, loopy_wait, and convert busywait() and
slowwait() into trivial wrappers.

Moreover, the fact that slowwait() uses seconds for units is really not
intuitive, and the comment does not help much. Instead make the unit part
of the name of the argument to further clarify what units are expected.

Cc: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: ea63ac142925 ("selftests/net: use tc rule to filter the na packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 22 ++-----------------
 tools/testing/selftests/net/lib.sh            | 16 +++++++++++---
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 99ab42319e3e3..01322758255f7 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -41,27 +41,9 @@ source "$net_forwarding_dir/../lib.sh"
 # timeout in seconds
 slowwait()
 {
-	local timeout=$1; shift
-
-	local start_time="$(date -u +%s)"
-	while true
-	do
-		local out
-		out=$("$@")
-		local ret=$?
-		if ((!ret)); then
-			echo -n "$out"
-			return 0
-		fi
+	local timeout_sec=$1; shift
 
-		local current_time="$(date -u +%s)"
-		if ((current_time - start_time > timeout)); then
-			echo -n "$out"
-			return 1
-		fi
-
-		sleep 0.1
-	done
+	loopy_wait "sleep 0.1" "$((timeout_sec * 1000))" "$@"
 }
 
 ##############################################################################
diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index e826ec1cc9d88..308c3b0bcf210 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -53,9 +53,10 @@ ksft_exit_status_merge()
 		$ksft_xfail $ksft_pass $ksft_skip $ksft_fail
 }
 
-busywait()
+loopy_wait()
 {
-	local timeout=$1; shift
+	local sleep_cmd=$1; shift
+	local timeout_ms=$1; shift
 
 	local start_time="$(date -u +%s%3N)"
 	while true
@@ -69,13 +70,22 @@ busywait()
 		fi
 
 		local current_time="$(date -u +%s%3N)"
-		if ((current_time - start_time > timeout)); then
+		if ((current_time - start_time > timeout_ms)); then
 			echo -n "$out"
 			return 1
 		fi
+
+		$sleep_cmd
 	done
 }
 
+busywait()
+{
+	local timeout_ms=$1; shift
+
+	loopy_wait : "$timeout_ms" "$@"
+}
+
 cleanup_ns()
 {
 	local ns=""
-- 
2.43.0



