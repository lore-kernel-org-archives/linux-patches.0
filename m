Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B958337699;
	Sat, 12 Sep 2026 08:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203025; cv=none; b=UH0pWJPPmrDwvqWF4CV00tGF1zS0chU7bLropcU5nSEtwHJorKG5rdPyDElpg6AoLggqX/abxjdcW/ng5eHEpem52q/D0/rnorsJNxX3I+jraj5nhHXgSEf++cVHx4pov1Jhs1myA91kGblz+d5I455wfXcQvd6y5nWvhFt4RfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203025; c=relaxed/simple;
	bh=+8tuBueWWcV2ldvxiKc+V6lQNzqV3GCSmMy/VN8munw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiN9VAgtCO8RXpaOYIxVOj6bskGJP7hXwpoWL/pyGvD08ak5321oaW5piZxkfz/gm1bDKnbjzkasj5E8DBg4dmTTYCFzb95+PyDwneO4qw6afVBNvGcb3XDJZ1erwX7lh6rdZ1T/zUKWWrc7XXh57V1jH4QKfwJGZ2fYXCeHmt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CR/q+O9u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CR/q+O9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EA61F000FF;
	Sat, 12 Sep 2026 08:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203024;
	bh=SSj5sPhYqnxZFHWBYhxdOhFMp+2m3m1/ITCn8bkxeJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CR/q+O9uBIvdB7QB0rgt92k7jJnU8G6YIt9RValqgty07CkDdIRxkY+aU08pluwux
	 rALt2I6g12iY1ekmpSXGGPyIzGiu3qZ8rdbuK5Vge40xVGTIbwX7xZTXC5BqTLYo8T
	 0mHN1JQVDTdFrKXjz5/HrOX51gLvIW7SFGtqO3/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1322/1815] selftests/cgroup: Avoid awk -e in cpuset tests
Date: Sat, 12 Sep 2026 08:51:12 +0200
Message-ID: <20260912065720.060654059@linuxfoundation.org>
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

[ Upstream commit 75e79a20190040800445ec95a4c4a84193d16992 ]

The cpuset selftests use awk -e to parse cgroup mount points. This
works with gawk, but mawk rejects the option. In test_cpuset_prs.sh,
this leaves CGROUP2 empty and causes the test to skip as if cgroup v2
were not mounted. The same non-portable invocation exists in the cpuset
v1 hotplug test.

The scripts only need to pass a single awk program. Use the standard awk
invocation without -e so mount point detection works with awk
implementations that do not support the gawk extension.

Fixes: a8c52eba880a ("kselftest/cgroup: Add cpuset v2 partition root state test")
Fixes: 812c5945bdb8 ("cgroup/cpuset: Add test_cpuset_v1_hp.sh")
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Acked-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh   | 2 +-
 tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index ca9bc38fdb95d..8e21e9fc439c0 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -20,7 +20,7 @@ skip_test() {
 WAIT_INOTIFY=$(cd $(dirname $0); pwd)/wait_inotify
 
 # Find cgroup v2 mount point
-CGROUP2=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+CGROUP2=$(mount -t cgroup2 | head -1 | awk '{print $3}')
 [[ -n "$CGROUP2" ]] || skip_test "Cgroup v2 mount point not found!"
 SUBPARTS_CPUS=$CGROUP2/.__DEBUG__.cpuset.cpus.subpartitions
 CPULIST=$(cat $CGROUP2/cpuset.cpus.effective)
diff --git a/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh b/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
index 7406c24be1ac9..da97f1643f9a3 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_v1_hp.sh
@@ -14,7 +14,7 @@ skip_test() {
 [[ $(id -u) -eq 0 ]] || skip_test "Test must be run as root!"
 
 # Find cpuset v1 mount point
-CPUSET=$(mount -t cgroup | grep cpuset | head -1 | awk -e '{print $3}')
+CPUSET=$(mount -t cgroup | grep cpuset | head -1 | awk '{print $3}')
 [[ -n "$CPUSET" ]] || skip_test "cpuset v1 mount point not found!"
 
 #
-- 
2.53.0



