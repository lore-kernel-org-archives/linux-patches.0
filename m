Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68EA268FD5;
	Tue,  8 Apr 2025 11:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111585; cv=none; b=ZfoSB1kLP4ZNgvtrkklUzPKGuyGsjKBy63cMBzsNWLx8+ELd1Cf7nQJv0Y+YAqcedGrQ2gX/u5Ss4/TspqaCwAoru8znLwchDODn252vwm/IbJrhDRNQ+UYL4/f2xdrPCi2ftgTlwNjnhjvad+mEeMpfun7Y51HhxMnS7xa7sjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111585; c=relaxed/simple;
	bh=JgTWD54CwU4kOVVpT/D1H69xqEZGib9pmIjVwyGmVCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC2ynH4pkGwUVWcrRWQmBGmCUW64zHeE0RfkKn+L6K4Lb5nhZxoMmFsTfOPNk2qUeuwZb/Dl1rofBMbGNpq5bFe9IAQ0YyIk1Zy+zWdnKejvwqld0A55dDqpV35XNJTWPfXzWVQ0V7Jvhz3fPgyAfUmAK/8Od9D15ddBA6N5zOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpYNzPYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpYNzPYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342EFC4CEEA;
	Tue,  8 Apr 2025 11:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111585;
	bh=JgTWD54CwU4kOVVpT/D1H69xqEZGib9pmIjVwyGmVCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpYNzPYOSlwpH6HHwNIk1cG2W5v28wqycBq9A680mccokH7qzWvYZkzRiIpcfqEhH
	 rT5xM41Cak0nCOD58nqjB8HONhPZoIvIKl1oqoW107zK8M7N7kuGwTBq7zB2iZJUfq
	 tBgll1aj7LiYjoK5fF/ZplenEbdqvD9IzFdqSZ5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 484/731] perf tests: Fix data symbol test with LTO builds
Date: Tue,  8 Apr 2025 12:46:21 +0200
Message-ID: <20250408104925.534321936@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 36e7748d33bf6a82e558009e03448e9321465e05 ]

With LTO builds, although regular builds could also see this as
all the code is in one file, the datasym workload can realize the
buf1.reserved data is never accessed. The compiler moves the
variable to bss and only keeps the data1 and data2 parts as
separate variables. This causes the symbol check to fail in the
test. Make the variable volatile to disable the more aggressive
optimization. Rename the variable to make which buf1 in perf is
being referred to.

Before:

  $ perf test -vv "data symbol"
  126: Test data symbol:
  --- start ---
  test child forked, pid 299808
  perf does not have symbol 'buf1'
  perf is missing symbols - skipping test
  ---- end(-2) ----
  126: Test data symbol                                                : Skip
  $ nm perf|grep buf1
  0000000000a5fa40 b buf1.0
  0000000000a5fa48 b buf1.1

After:

  $ nm perf|grep buf1
  0000000000a53a00 d buf1
  $ perf test -vv "data symbol"126: Test data symbol:
  --- start ---
  test child forked, pid 302166
   a53a00-a53a39 l buf1
  perf does have symbol 'buf1'
  Recording workload...
  Waiting for "perf record has started" message
  OK
  Cleaning up files...
  ---- end(0) ----
  126: Test data symbol                                                : Ok

Fixes: 3dfc01fe9d12 ("perf test: Add 'datasym' test workload")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250226230109.314580-1-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_data_symbol.sh | 17 +++++++++--------
 tools/perf/tests/workloads/datasym.c       | 11 ++++++-----
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/tools/perf/tests/shell/test_data_symbol.sh b/tools/perf/tests/shell/test_data_symbol.sh
index c86da02350596..7da606db97cb4 100755
--- a/tools/perf/tests/shell/test_data_symbol.sh
+++ b/tools/perf/tests/shell/test_data_symbol.sh
@@ -18,7 +18,7 @@ skip_if_no_mem_event() {
 
 skip_if_no_mem_event || exit 2
 
-skip_test_missing_symbol buf1
+skip_test_missing_symbol workload_datasym_buf1
 
 TEST_PROGRAM="perf test -w datasym"
 PERF_DATA=$(mktemp /tmp/__perf_test.perf.data.XXXXX)
@@ -26,18 +26,19 @@ ERR_FILE=$(mktemp /tmp/__perf_test.stderr.XXXXX)
 
 check_result() {
 	# The memory report format is as below:
-	#    99.92%  ...  [.] buf1+0x38
+	#    99.92%  ...  [.] workload_datasym_buf1+0x38
 	result=$(perf mem report -i ${PERF_DATA} -s symbol_daddr -q 2>&1 |
-		 awk '/buf1/ { print $4 }')
+		 awk '/workload_datasym_buf1/ { print $4 }')
 
-	# Testing is failed if has no any sample for "buf1"
+	# Testing is failed if has no any sample for "workload_datasym_buf1"
 	[ -z "$result" ] && return 1
 
 	while IFS= read -r line; do
-		# The "data1" and "data2" fields in structure "buf1" have
-		# offset "0x0" and "0x38", returns failure if detect any
-		# other offset value.
-		if [ "$line" != "buf1+0x0" ] && [ "$line" != "buf1+0x38" ]; then
+		# The "data1" and "data2" fields in structure
+		# "workload_datasym_buf1" have offset "0x0" and "0x38", returns
+		# failure if detect any other offset value.
+		if [ "$line" != "workload_datasym_buf1+0x0" ] && \
+		   [ "$line" != "workload_datasym_buf1+0x38" ]; then
 			return 1
 		fi
 	done <<< "$result"
diff --git a/tools/perf/tests/workloads/datasym.c b/tools/perf/tests/workloads/datasym.c
index 8ddb2aa6a049e..1d0b7d64e1ba1 100644
--- a/tools/perf/tests/workloads/datasym.c
+++ b/tools/perf/tests/workloads/datasym.c
@@ -10,7 +10,8 @@ typedef struct _buf {
 	char data2;
 } buf __attribute__((aligned(64)));
 
-static buf buf1 = {
+/* volatile to try to avoid the compiler seeing reserved as unused. */
+static volatile buf workload_datasym_buf1 = {
 	/* to have this in the data section */
 	.reserved[0] = 1,
 };
@@ -34,8 +35,8 @@ static int datasym(int argc, const char **argv)
 	alarm(sec);
 
 	while (!done) {
-		buf1.data1++;
-		if (buf1.data1 == 123) {
+		workload_datasym_buf1.data1++;
+		if (workload_datasym_buf1.data1 == 123) {
 			/*
 			 * Add some 'noise' in the loop to work around errata
 			 * 1694299 on Arm N1.
@@ -49,9 +50,9 @@ static int datasym(int argc, const char **argv)
 			 * longer a continuous repeating pattern that interacts
 			 * badly with the bias.
 			 */
-			buf1.data1++;
+			workload_datasym_buf1.data1++;
 		}
-		buf1.data2 += buf1.data1;
+		workload_datasym_buf1.data2 += workload_datasym_buf1.data1;
 	}
 	return 0;
 }
-- 
2.39.5



