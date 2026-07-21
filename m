Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A69315D53;
	Tue, 21 Jul 2026 18:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659257; cv=none; b=oCq+44llTecP5sP2CsSE4gyjCmHlmez3NJnPg2La6173VSzlEfxcTgqvoXPB7cQlayBlXhTOkxLlaNWsz1/m+suhiqWxlAOpLnsKzZisYy7MUNv0McYJKcFHmLatUJH1tW1ODeQqP7M5IXDDSNKSBO/FGxJ19wxOg1EXLFtHzaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659257; c=relaxed/simple;
	bh=gCESBkTmHOZf+DG20sTjFBjRdESocS8gNzT4kRUOrP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqboXnGIASJ0pDvT0ZZgBQMOg/CKSTnJMY4JvxYR2Ik1I6Ucj4msMUQJj/P+X+M0fIJ43tdbzT0sKBf5Kv4d4EYuVm2W8hlAgpJv1fmk7mQijX0O6NwsT5J4X2QpjXPNZRW+O5R5us+X7WcWvso9OO/PlFsRH20EF/4A6utkYxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBLcLuz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBLcLuz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F061F000E9;
	Tue, 21 Jul 2026 18:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659255;
	bh=5YCMt/6BXVwUOcmGjKH+pjzcmyrxeCRU+wo+HbFdajU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBLcLuz9MIOvzR9jZwgEjGpyPDA9OHTLXuMse6MvUtEXy/YTLHGRlJs7efFO1g7vS
	 OpVwBKdJco3kSt/0HGd9DZ7AJ72UbmTg9O0uZGS7EvFhJ/EjYL4fJtjFRaSxoM40jb
	 DMVqK62qeds3buk71Jo8vuaB/ESoaaGwcwcCL110=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 1453/1611] selftests: net: make busywait timeout clock portable
Date: Tue, 21 Jul 2026 17:26:09 +0200
Message-ID: <20260721152548.129689936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoyd@nvidia.com>

commit dd6a23bac306b7aa322e0aaccb60c6e32a198fb3 upstream.

loopy_wait() expects millisecond timestamps. However, Ubuntu Resolute
can use uutils date, where `date -u +%s%3N` returns seconds plus full
nanoseconds instead of a 3-digit millisecond field. This makes
busywait expire too early and can make vlan_bridge_binding.sh read a
stale operstate.

Fixes: 25ae948b4478 ("selftests/net: add lib.sh")
Cc: stable@vger.kernel.org # 6.8+
Link: https://github.com/uutils/coreutils/issues/11658
Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
Link: https://patch.msgid.link/20260630165157.3814871-1-nirmoyd@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/lib.sh |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -70,12 +70,33 @@ ksft_exit_status_merge()
 		$ksft_xfail $ksft_pass $ksft_skip $ksft_fail
 }
 
+timestamp_ms()
+{
+	local now
+	local seconds
+	local nanoseconds
+
+	now=$(date -u +%s:%N) || return
+	seconds=${now%:*}
+	nanoseconds=${now#*:}
+
+	if [[ $nanoseconds =~ ^[0-9]+$ ]]; then
+		nanoseconds=${nanoseconds:0:9}
+	else
+		nanoseconds=0
+	fi
+
+	echo $((seconds * 1000 + 10#$nanoseconds / 1000000))
+}
+
 loopy_wait()
 {
 	local sleep_cmd=$1; shift
 	local timeout_ms=$1; shift
+	local start_time
+	local current_time
 
-	local start_time="$(date -u +%s%3N)"
+	start_time=$(timestamp_ms) || return
 	while true
 	do
 		local out
@@ -84,7 +105,7 @@ loopy_wait()
 			return 0
 		fi
 
-		local current_time="$(date -u +%s%3N)"
+		current_time=$(timestamp_ms) || return
 		if ((current_time - start_time > timeout_ms)); then
 			echo -n "$out"
 			return 1


