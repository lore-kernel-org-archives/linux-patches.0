Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFDA457E7A;
	Sat, 12 Sep 2026 11:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211164; cv=none; b=L+VbXdBxXmWhpIpmZ8KqbtHsMfBU9BFwMHrAm/TgDMqobQr92B5jx/DqdJ9CAY+P7ebQjkXTBpBp9b5zG0sxMwURioE4detsaHd4aTzsRDf7hY3AZfsuUnfmQTQZg432n7CL9OVg0cuVY3AWR9uYYklf5psz4leWBhfPnAFP0PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211164; c=relaxed/simple;
	bh=1qPr2Z2Olpcbv28BbmuOgCOejoiezTx+UUw1NCPVtss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXXEEewbE4ZPEL4boIeMeFevwh/B53Ggml+SOfGjE1As+YLJRkYMa4vWJ0j/8QqgmyIC+kHcgjWGIM19h8qFqIrLgGd3WyT2+Gm905JDuw615+QQOKiT7KvobXMXPrn2ExwMb1i+bmMFqfGzQC/HFMu3L5jZ9jeMzPJAZZTvQw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDrj9V/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDrj9V/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7811F000FF;
	Sat, 12 Sep 2026 11:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211162;
	bh=Ky4pZDe3a+PGVy3yIuxsrEgAlcv7ueuDGwlXWdSGwVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDrj9V/Kf55mperMuq7NsY3TSSdz2AZC5plS3RA2BN2G1PA5TEcePgtvyGmJMlStM
	 qOh41Fs2kGk2pLGBgK9ups1jck5CVWGcEBd6biZP5LNoZp/8rCOBbQd2IPLJFhfK3Y
	 qXWqMvQVspkx1YoKykhqS24PSaL8Zypyyyu+j4Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1174/1518] selftests/cgroup: Preserve CPU hotplug write errors
Date: Sat, 12 Sep 2026 08:55:43 +0200
Message-ID: <20260912065650.031539703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Rui Qi <qirui.001@bytedance.com>

[ Upstream commit ddabc5dbd262f3ca981e679ddae99ed7a9adb279 ]

The cpuset partition root state selftest checks several CPU hotplug
transitions. If writing to a CPU online file fails, the helper still
runs pause afterwards and returns the status of pause instead of the
failed write.

This hides the real hotplug failure and can make later checks run
against expectations for a transition that never happened. Move the
write before the bookkeeping and return when it fails, so callers can
observe the hotplug error and the test does not record a CPU as offline
unless the offline operation actually succeeded.

Also change the O* command handler in set_ctrl_state() to use
"eval $COMM $REDIRECT" like all other handlers. The previous version
set COMM but still called write_cpu_online directly, bypassing the
redirect that captures stderr for error reporting.

Changes since v1:
 - Use eval $COMM $REDIRECT in the O* handler instead of calling
   write_cpu_online directly (Waiman Long)

Fixes: a8c52eba880a ("kselftest/cgroup: Add cpuset v2 partition root state test")
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index a17256d9f88a8..592e533cd4d7b 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -488,6 +488,7 @@ write_cpu_online()
 	CPU=${1%=*}
 	VAL=${1#*=}
 	CPUFILE=//sys/devices/system/cpu/cpu${CPU}/online
+	echo $VAL > $CPUFILE || return 1
 	if [[ $VAL -eq 0 ]]
 	then
 		OFFLINE_CPUS="$OFFLINE_CPUS $CPU"
@@ -497,7 +498,6 @@ write_cpu_online()
 					sort | uniq -u)
 		}
 	fi
-	echo $VAL > $CPUFILE
 	pause 0.05
 }
 
@@ -565,7 +565,8 @@ set_ctrl_state()
 			eval $COMM $REDIRECT
 			;;
 		    O*) VAL=${CMD#?}
-			write_cpu_online $VAL
+			COMM="write_cpu_online $VAL"
+			eval $COMM $REDIRECT
 			;;
 		    T*) COMM="echo 0 > $TFILE"
 			eval $COMM $REDIRECT
-- 
2.53.0



