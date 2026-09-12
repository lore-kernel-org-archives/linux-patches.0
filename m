Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854453546E1;
	Sat, 12 Sep 2026 08:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203571; cv=none; b=ongfY4DWcu5JNrWUQMuSqhQVv/R2o7aFgzqlY8XqB9avAY+2Vd5C+gckIa4544LYjQzoB25hk+1xRZPlI46sV/wQibdhpEbRZVCKE3bWpNAif7s0qXfRc1txi7WtHuyfRxrO1NFatRtLrLSxbtsnWW+6V1PFN3uGposUxyWDROI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203571; c=relaxed/simple;
	bh=ne8HUIMw2sq2JJxNOkv+q8O2nFvJtb1ioGIlOnyxTrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tq4JPmlqYoGn1Ay1RFtRDmH+gNNItlvWJ8UJzRPKtsQdu0oHqVLR0PMWjsrwA9bcum/eM/ksjde45ioMW4/2xpmEkiCZ5qHlRRQKIdX4x3yCGXqeGPNwu/1YfOYWltYuR8c/owro411Lzu35M109YxQEVIvFS3gtpd16TrNmPy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLato0ab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLato0ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF321F000FF;
	Sat, 12 Sep 2026 08:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203570;
	bh=y/gChCYfFePczFox2EyoDyJG/kloTcTroEp/HLZ7YBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLato0abYJ+7yTMTgypjOAh1UPPjtqMqHb0xDM31cR4swHMKT+ekU4CKu/T2pSSrS
	 tDNIxuOUT9Z6f5M8OsOg1fWn4nU21J0Bk4JQDa+RcWN+pL6Bm/g0FAOIQcJoQafuc7
	 j1IHRMLvir1B77SU9rsnJzHZQimCdoGMnogsAw68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1435/1815] selftests/cgroup: Preserve CPU hotplug write errors
Date: Sat, 12 Sep 2026 08:53:05 +0200
Message-ID: <20260912065722.705803966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8e21e9fc439c0..b2e60671273ec 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -520,6 +520,7 @@ write_cpu_online()
 	CPU=${1%=*}
 	VAL=${1#*=}
 	CPUFILE=//sys/devices/system/cpu/cpu${CPU}/online
+	echo $VAL > $CPUFILE || return 1
 	if [[ $VAL -eq 0 ]]
 	then
 		OFFLINE_CPUS="$OFFLINE_CPUS $CPU"
@@ -529,7 +530,6 @@ write_cpu_online()
 					sort | uniq -u)
 		}
 	fi
-	echo $VAL > $CPUFILE
 	pause 0.05
 }
 
@@ -597,7 +597,8 @@ set_ctrl_state()
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



