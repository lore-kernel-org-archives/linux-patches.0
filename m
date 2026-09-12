Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDEC1A8F7B;
	Sat, 12 Sep 2026 09:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206210; cv=none; b=Hry9Iytq13CqRe6hjNZbn2ZZ8eE21pVacr01lb5Qopb3vRwZuWM9IKspAJ2ShuQguavCC1FCSI0f97/6wFF0No8gO0YWgJN9F/zjjN9lO2/gf2oimPyDY4DwV41qCE+Cvm5G0/1M8WpxbDUON+HL8IxcAsho1DM2h+PEZL2dD3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206210; c=relaxed/simple;
	bh=cjvM3p23/dAruP4L/ZdxGyRdQzPxeNnYPaOddtyDshc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRsoY5769Wc9Tv2fePn1COUv9vcMEk8kOeQqNXGOBkL5IjdPgZs4qD1AHqEfxtgdtrVKvGLDg8V85e3u3nS9AwedX4sBRJcAVwC7sHqEazvoMiYlwOqD9Sojx94aESu1ysVBshoghYuq3otYFtXkSMyLcOZm5FH1D5lrGQIH1Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zO3wJ3xe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zO3wJ3xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80061F000FF;
	Sat, 12 Sep 2026 09:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206208;
	bh=RVABXUA4d+SYtLKSu4bKXYqEiCOY/A02dd9aU8KWtgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zO3wJ3xeyYEvoePqWToJIGkEZVgKdkCCDsws4HtLdAG6i2NlpUO7UIa41eUeMf6YB
	 DC6mgiOBjU/WsAjQ8nFDO50DYpnStfKgEKzgb390vzAVtLDE7m41Y9tEnCU98UYeaV
	 NPDJ6OLx0ey9PJwFTnBJZQqHf4hlmOzoI0NJjcFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0160/1518] perf test kvm: Add some basic perf kvm test coverage
Date: Sat, 12 Sep 2026 08:38:49 +0200
Message-ID: <20260912065627.114002598@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit b58261584d2f6b5241ac1693026242ef2f2148b4 ]

Setup qemu with KVM then run kvm stat and some host
recording/reporting/build-id tests.

Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 509a2b9a6e14 ("perf tests: Fix flakiness in trace record and replay test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/kvm.sh | 154 ++++++++++++++++++++++++++++++++++
 1 file changed, 154 insertions(+)
 create mode 100755 tools/perf/tests/shell/kvm.sh

diff --git a/tools/perf/tests/shell/kvm.sh b/tools/perf/tests/shell/kvm.sh
new file mode 100755
index 0000000000000..2fafde1a29cca
--- /dev/null
+++ b/tools/perf/tests/shell/kvm.sh
@@ -0,0 +1,154 @@
+#!/bin/bash
+# perf kvm tests
+# SPDX-License-Identifier: GPL-2.0
+
+set -e
+
+err=0
+perfdata=$(mktemp /tmp/__perf_kvm_test.perf.data.XXXXX)
+qemu_pid_file=$(mktemp /tmp/__perf_kvm_test.qemu.pid.XXXXX)
+
+cleanup() {
+	rm -f "${perfdata}"
+	if [ -f "${qemu_pid_file}" ]; then
+		if [ -s "${qemu_pid_file}" ]; then
+			qemu_pid=$(cat "${qemu_pid_file}")
+			if [ -n "${qemu_pid}" ]; then
+				kill "${qemu_pid}" 2>/dev/null || true
+			fi
+		fi
+		rm -f "${qemu_pid_file}"
+	fi
+	trap - EXIT TERM INT
+}
+
+trap_cleanup() {
+	echo "Unexpected signal in ${FUNCNAME[1]}"
+	cleanup
+	exit 1
+}
+trap trap_cleanup EXIT TERM INT
+
+skip() {
+	echo "Skip: $1"
+	cleanup
+	exit 2
+}
+
+test_kvm_stat() {
+	echo "Testing perf kvm stat"
+
+	echo "Recording kvm events for pid ${qemu_pid}..."
+	if ! perf kvm stat record -p "${qemu_pid}" -o "${perfdata}" sleep 1; then
+		echo "Failed to record kvm events"
+		err=1
+		return
+	fi
+
+	echo "Reporting kvm events..."
+	if ! perf kvm -i "${perfdata}" stat report 2>&1 | grep -q "VM-EXIT"; then
+		echo "Failed to find VM-EXIT in report"
+		perf kvm -i "${perfdata}" stat report 2>&1
+		err=1
+		return
+	fi
+
+	echo "perf kvm stat test [Success]"
+}
+
+test_kvm_record_report() {
+	echo "Testing perf kvm record/report"
+
+	echo "Recording kvm profile for pid ${qemu_pid}..."
+	# Use --host to avoid needing guest symbols/mounts for this simple test
+	# We just want to verify the command runs and produces data
+	# We run in background and kill it because 'perf kvm record' appends options
+	# after the command, which breaks 'sleep' (e.g. it gets '-e cycles').
+	perf kvm --host record -p "${qemu_pid}" -o "${perfdata}" &
+	rec_pid=$!
+	sleep 1
+	kill -INT "${rec_pid}"
+	wait "${rec_pid}" || true
+
+	echo "Reporting kvm profile..."
+	# Check for some standard output from report
+	if ! perf kvm -i "${perfdata}" report --stdio 2>&1 | grep -q "Event count"; then
+		echo "Failed to report kvm profile"
+		perf kvm -i "${perfdata}" report --stdio 2>&1
+		err=1
+		return
+	fi
+
+	echo "perf kvm record/report test [Success]"
+}
+
+test_kvm_buildid_list() {
+	echo "Testing perf kvm buildid-list"
+
+	# We reuse the perf.data from the previous record test
+	if ! perf kvm --host -i "${perfdata}" buildid-list 2>&1 | grep -q "."; then
+		echo "Failed to list buildids"
+		perf kvm --host -i "${perfdata}" buildid-list 2>&1
+		err=1
+		return
+	fi
+
+	echo "perf kvm buildid-list test [Success]"
+}
+
+setup_qemu() {
+	# Find qemu
+	if [ "$(uname -m)" = "x86_64" ]; then
+		qemu="qemu-system-x86_64"
+	elif [ "$(uname -m)" = "aarch64" ]; then
+		qemu="qemu-system-aarch64"
+	elif [ "$(uname -m)" = "s390x" ]; then
+		qemu="qemu-system-s390x"
+	elif [ "$(uname -m)" = "ppc64le" ]; then
+		qemu="qemu-system-ppc64"
+	else
+		qemu="qemu-system-$(uname -m)"
+	fi
+
+	if ! which -s "$qemu"; then
+		skip "$qemu not found"
+	fi
+
+	if [ ! -r /dev/kvm ] || [ ! -w /dev/kvm ]; then
+		skip "/dev/kvm not accessible"
+	fi
+
+	if ! perf kvm stat record -a sleep 0.01 >/dev/null 2>&1; then
+		skip "No permission to record kvm events"
+	fi
+
+	echo "Starting $qemu..."
+	# Start qemu in background, detached, with pidfile
+	# We use -display none -daemonize and a monitor to keep it alive/controllable if needed
+	# We don't need a real kernel, just KVM active.
+	if ! $qemu -enable-kvm -display none -daemonize -pidfile "${qemu_pid_file}" -monitor none; then
+		echo "Failed to start qemu"
+		err=1
+		return
+	fi
+
+	# Wait a bit for qemu to start
+	sleep 1
+	qemu_pid=$(cat "${qemu_pid_file}")
+
+	if ! kill -0 "${qemu_pid}" 2>/dev/null; then
+		echo "Qemu process failed to stay alive"
+		err=1
+		return
+	fi
+}
+
+setup_qemu
+if [ $err -eq 0 ]; then
+	test_kvm_stat
+	test_kvm_record_report
+	test_kvm_buildid_list
+fi
+
+cleanup
+exit $err
-- 
2.53.0



