Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9756A1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12824C433D2;
	Wed, 28 Dec 2022 16:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246137;
	bh=vWvS77y3aOqKyCHgi+CB3rdVEMh/eS0ZGnwOuYNBRR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=li2nH8xSDKKZnBbVd9j+G5enNoGfHN8GlG21murVLLoNALUUv44dBXe74/4YGpm4n
	 KOnlEGTAlQzjQrFuPMRux6VzXjrGmn54DyGZwbm/vw8Y9B4/pwdbcAj25ImrVHQfoH
	 bb8ehnawvsC+KWDpUJZeWP1FZdt/xAv7phx/xX2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Petlan <mpetlan@redhat.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Disha Goel <disgoel@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nageswara R Sastry <rnsastry@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1018/1073] perf test: Fix "all PMU test" to skip parametrized events
Date: Wed, 28 Dec 2022 15:43:26 +0100
Message-Id: <20221228144355.834739696@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Petlan <mpetlan@redhat.com>

[ Upstream commit b50d691e50e600fab82b423be871860537d75dc9 ]

Parametrized events are not only a powerpc domain. They occur on other
platforms too (e.g. aarch64). They should be ignored in this testcase,
since proper setup of the parameters is out of scope of this script.

Let's not filter them out by PMU name, but rather based on the fact that
they expect a parameter.

Fixes: 451ed8058c69a3fe ("perf test: Fix "all PMU test" to skip hv_24x7/hv_gpci tests on powerpc")
Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Disha Goel <disgoel@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nageswara R Sastry <rnsastry@linux.ibm.com>
Link: https://lore.kernel.org/r/20221219163008.9691-1-mpetlan@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_all_pmu.sh | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/tools/perf/tests/shell/stat_all_pmu.sh b/tools/perf/tests/shell/stat_all_pmu.sh
index 9c9ef33e0b3c..c77955419173 100755
--- a/tools/perf/tests/shell/stat_all_pmu.sh
+++ b/tools/perf/tests/shell/stat_all_pmu.sh
@@ -4,17 +4,8 @@
 
 set -e
 
-for p in $(perf list --raw-dump pmu); do
-  # In powerpc, skip the events for hv_24x7 and hv_gpci.
-  # These events needs input values to be filled in for
-  # core, chip, partition id based on system.
-  # Example: hv_24x7/CPM_ADJUNCT_INST,domain=?,core=?/
-  # hv_gpci/event,partition_id=?/
-  # Hence skip these events for ppc.
-  if echo "$p" |grep -Eq 'hv_24x7|hv_gpci' ; then
-    echo "Skipping: Event '$p' in powerpc"
-    continue
-  fi
+# Test all PMU events; however exclude parametrized ones (name contains '?')
+for p in $(perf list --raw-dump pmu | sed 's/[[:graph:]]\+?[[:graph:]]\+[[:space:]]//g'); do
   echo "Testing $p"
   result=$(perf stat -e "$p" true 2>&1)
   if ! echo "$result" | grep -q "$p" && ! echo "$result" | grep -q "<not supported>" ; then
-- 
2.35.1



