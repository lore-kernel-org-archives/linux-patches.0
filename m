Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36182EA16C;
	Tue, 17 Jun 2025 16:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178256; cv=none; b=OElplyJ/cKF2fgnj4EKiZTflHVz61lERbhEwJp9QBkNM+sxL9OUAh92gsqfSP2F3lb6o54RpmZxPSv0ihKcik9aiZAq481gZ5bV/frG32Mj4mFKyM22L0jChz1aVINMu2R0Q+RB7momzq5rsdUhjr3eISqYTfKU7FmoKSKDLV/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178256; c=relaxed/simple;
	bh=Spz3R8s92P/th2AglvQQTZNTZLxGzs9m5f+NugEQIfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHDa7sJBkgm6ko9QFw87Ddm9iMLxHbKzW0SXhZEX7jqZqjMssilDmRweV0IVNgShRi4GM4I5ecGaWMB4D2up8xthNzO8sRS0cD+SBUMAds4e//I3fEFwXrtkHiW2Esg8xshI5Sht/DBqbRrlO8YUNuHUlnNVJxdiIJ6vNptEJD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TR7waNr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TR7waNr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A29C4CEE3;
	Tue, 17 Jun 2025 16:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178255;
	bh=Spz3R8s92P/th2AglvQQTZNTZLxGzs9m5f+NugEQIfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TR7waNr6lMCfXmMh0o5LJdbrk1ijnCTN+OLGlgBuNBOYtkmCIZe575j1CiWDNXPNQ
	 L/XhhAlbBDzPd44gOssvn1yIb2ScJVK65Az+/RsFU56jQiCm+HA2rhpag5EliG4Q2n
	 HmOHsFO9OClpu9rJQ0IzAgpnvNvvIwhEWQP+YoOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 434/780] perf tests metric-only perf stat: Fix tests 84 and 86 s390
Date: Tue, 17 Jun 2025 17:22:22 +0200
Message-ID: <20250617152509.142653594@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit ccd4b5cdf00f358acae9f396d13029e7ae78522e ]

On s390x KVM and z/VM machines the CPU Measurement Facility is not
available. Events cycles and instructions do not exist.  Running above
tests on s390 KVM and z/VM guests always fail with this error:

  # ./perf test 84 86
  84: perf stat JSON output linter          : FAILED!
  86: perf stat STD output linter           : FAILED!
  #

Root cause is command:

  # perf stat -j --metric-only -e instructions,cycles -- true
  {"metric-value" : "none"}
  #

Which fails due to unsupported events and returns "none".
Do not execute this test case on s390 KVM and z/VM machines.

Output after:
  # ./perf test 84 86
  84: perf stat JSON output linter          : Ok
  86: perf stat STD output linter           : Ok
  #

Fixes: 45a86d017adf4d6c ("perf test: Add --metric-only to perf stat output tests")
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Suggested-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20250424133310.37452-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/lib/stat_output.sh  | 5 +++++
 tools/perf/tests/shell/stat+json_output.sh | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/tools/perf/tests/shell/lib/stat_output.sh b/tools/perf/tests/shell/lib/stat_output.sh
index 4d4aac547f010..c2ec7881ec1de 100644
--- a/tools/perf/tests/shell/lib/stat_output.sh
+++ b/tools/perf/tests/shell/lib/stat_output.sh
@@ -151,6 +151,11 @@ check_per_socket()
 check_metric_only()
 {
 	echo -n "Checking $1 output: metric only "
+	if [ "$(uname -m)" = "s390x" ] && ! grep '^facilities' /proc/cpuinfo  | grep -qw 67
+	then
+		echo "[Skip] CPU-measurement counter facility not installed"
+		return
+	fi
 	perf stat --metric-only $2 -e instructions,cycles true
 	commachecker --metric-only
 	echo "[Success]"
diff --git a/tools/perf/tests/shell/stat+json_output.sh b/tools/perf/tests/shell/stat+json_output.sh
index a4f257ea839e1..98fb65274ac4f 100755
--- a/tools/perf/tests/shell/stat+json_output.sh
+++ b/tools/perf/tests/shell/stat+json_output.sh
@@ -176,6 +176,11 @@ check_per_socket()
 check_metric_only()
 {
 	echo -n "Checking json output: metric only "
+	if [ "$(uname -m)" = "s390x" ] && ! grep '^facilities' /proc/cpuinfo  | grep -qw 67
+	then
+		echo "[Skip] CPU-measurement counter facility not installed"
+		return
+	fi
 	perf stat -j --metric-only -e instructions,cycles -o "${stat_output}" true
 	$PYTHON $pythonchecker --metric-only --file "${stat_output}"
 	echo "[Success]"
-- 
2.39.5



