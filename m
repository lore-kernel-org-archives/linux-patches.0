Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88AD30C361;
	Mon, 13 Oct 2025 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368831; cv=none; b=MwNvGbv7m55VQteb+K83AeZ1mWo+r7Ubgb/upd3rj3PEXu1cXhx1uoChpcsEn5EcSoG4g0QYivpEl6YJ2Um9dQv/mA65f8SNZlXPQcN7ioA1jqqn72168ftxcgwR+t4aRj9NMea6GflbCS1hb/+hzIN/Q+T1Nmj7G3k7JIH5gUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368831; c=relaxed/simple;
	bh=DNXDzLrw0LgMRjFv+B+6qxxmbF3HZxLHLSz1VzQsn60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drDKiD1BoEMH/jpJgni/R3VodcfS/CXydraX+WoRmRB9wSablqsGkVFAvxyeHBjanc/n2jYdtKIYhjsPq0/vC0s6KoTYLwcYI6Qbx95gK50g9BOryzb2lQ5jMtW6gpaMi8hew76PNTsip0MKYXZI23OnzQeDPdxMu1MrG91NfrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBZ6LThw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBZ6LThw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5374FC4CEE7;
	Mon, 13 Oct 2025 15:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368831;
	bh=DNXDzLrw0LgMRjFv+B+6qxxmbF3HZxLHLSz1VzQsn60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBZ6LThwXgtvGgAOLTxHBD1Hu18owNOLIWYr1DlwraCdChOJzhKol6a+VIrg6PWdK
	 XEpZesFrL/FYtI8giIKEl1BxLk1HmqaEcGrnceUCnq55jGtKIiPRfmiEepayUU+L1P
	 7x1pHHsaLWatC2Nk6jTZbmyYTwztuc4ItRdLpVHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Sebastian Chlad <sebastian.chlad@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 035/563] selftests: cgroup: Make test_pids backwards compatible
Date: Mon, 13 Oct 2025 16:38:16 +0200
Message-ID: <20251013144412.561721890@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 3b0dec689a6301845761681b852f9538cb75a1d2 ]

The predicates in test expect event counting from 73e75e6fc352b
("cgroup/pids: Separate semantics of pids.events related to pids.max")
and the test would fail on older kernels. We want to have one version of
tests for all, so detect the feature and skip the test on old kernels.
(The test could even switch to check v1 semantics based on the flag but
keep it simple for now.)

Fixes: 9f34c566027b6 ("selftests: cgroup: Add basic tests for pids controller")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Tested-by: Sebastian Chlad <sebastian.chlad@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/lib/cgroup_util.c     | 12 ++++++++++++
 .../selftests/cgroup/lib/include/cgroup_util.h       |  1 +
 tools/testing/selftests/cgroup/test_pids.c           |  3 +++
 3 files changed, 16 insertions(+)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 0e89fcff4d05d..44c52f620fda1 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -522,6 +522,18 @@ int proc_mount_contains(const char *option)
 	return strstr(buf, option) != NULL;
 }
 
+int cgroup_feature(const char *feature)
+{
+	char buf[PAGE_SIZE];
+	ssize_t read;
+
+	read = read_text("/sys/kernel/cgroup/features", buf, sizeof(buf));
+	if (read < 0)
+		return read;
+
+	return strstr(buf, feature) != NULL;
+}
+
 ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size)
 {
 	char path[PATH_MAX];
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index c69cab66254b4..9dc90a1b386d7 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -60,6 +60,7 @@ extern int cg_run_nowait(const char *cgroup,
 extern int cg_wait_for_proc_count(const char *cgroup, int count);
 extern int cg_killall(const char *cgroup);
 int proc_mount_contains(const char *option);
+int cgroup_feature(const char *feature);
 extern ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size);
 extern int proc_read_strstr(int pid, bool thread, const char *item, const char *needle);
 extern pid_t clone_into_cgroup(int cgroup_fd);
diff --git a/tools/testing/selftests/cgroup/test_pids.c b/tools/testing/selftests/cgroup/test_pids.c
index 9ecb83c6cc5cb..d8a1d1cd50072 100644
--- a/tools/testing/selftests/cgroup/test_pids.c
+++ b/tools/testing/selftests/cgroup/test_pids.c
@@ -77,6 +77,9 @@ static int test_pids_events(const char *root)
 	char *cg_parent = NULL, *cg_child = NULL;
 	int pid;
 
+	if (cgroup_feature("pids_localevents") <= 0)
+		return KSFT_SKIP;
+
 	cg_parent = cg_name(root, "pids_parent");
 	cg_child = cg_name(cg_parent, "pids_child");
 	if (!cg_parent || !cg_child)
-- 
2.51.0



