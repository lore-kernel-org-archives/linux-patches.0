Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC0912FB31;
	Wed, 19 Jun 2024 13:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802585; cv=none; b=FtZPQybRAt2OxMIfuv5kAGnEU9AqZU8n0Gv8Tc2EpLdWB3gK07aQlPgwtVxr2fMZKHf4yHcW+K50WQ//QLONhq/4hO/6IAbBz16qo2Mx/Cq5+2Yt1pkw2md61Nx9+Sed/4mwfGJ+dmLJT3pz9OPKrl+RT6PFmc2XtK4JJFztWuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802585; c=relaxed/simple;
	bh=MQo+UcnOfct0hNKkRCuNdRH51dATaMLh3mSdyf5e9DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3YOaNLaQLijwdTnfUUkbaQomdi+tJiUskrfsG9X7LIkgJn1xbfDu3YB44UyzT9eG4uA2Jazs/mGonBhNI8HfkgJ5m3yAPLgi6suz/2F0n9smNADIXa82qpzMyS7nu3RMRACb5b0p/3LKuaNbrQdw1ADTSTmt52n0n6gMCkuVUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYBC6u55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYBC6u55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022EBC2BBFC;
	Wed, 19 Jun 2024 13:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802585;
	bh=MQo+UcnOfct0hNKkRCuNdRH51dATaMLh3mSdyf5e9DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYBC6u55zpGtN8AD+93mB0CnUwMMw6+StCHaPUg4FbrrkLZna6TZKTbYEDBp+8h7y
	 RtmeQht0fZlHNdap6+DkHeMYiZVPk1hT081pfjhx55/Ft8K2bHacjQuxHT+NEhDVZc
	 Cjb0z5mnJqr/FmOHklGrd7Jg6boM9Ei77+mw7UWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: [PATCH 6.6 246/267] selftests/net: add lib.sh
Date: Wed, 19 Jun 2024 14:56:37 +0200
Message-ID: <20240619125615.763345695@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

commit 25ae948b447881bf689d459cd5bd4629d9c04b20 upstream.

Add a lib.sh for net selftests. This file can be used to define commonly
used variables and functions. Some commonly used functions can be moved
from forwarding/lib.sh to this lib file. e.g. busywait().

Add function setup_ns() for user to create unique namespaces with given
prefix name.

Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[PHLin: add lib.sh to TEST_FILES directly as we already have upstream
        commit 06efafd8 landed in 6.6.y]
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/Makefile          |    2 
 tools/testing/selftests/net/forwarding/lib.sh |   27 --------
 tools/testing/selftests/net/lib.sh            |   85 ++++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 27 deletions(-)
 create mode 100644 tools/testing/selftests/net/lib.sh

--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -92,7 +92,7 @@ TEST_PROGS += test_vxlan_nolocalbypass.s
 TEST_PROGS += test_bridge_backup_port.sh
 
 TEST_FILES := settings
-TEST_FILES += in_netns.sh net_helper.sh setup_loopback.sh setup_veth.sh
+TEST_FILES += in_netns.sh lib.sh net_helper.sh setup_loopback.sh setup_veth.sh
 
 include ../lib.mk
 
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -4,9 +4,6 @@
 ##############################################################################
 # Defines
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
 # Can be overridden by the configuration file.
 PING=${PING:=ping}
 PING6=${PING6:=ping6}
@@ -41,6 +38,7 @@ if [[ -f $relative_path/forwarding.confi
 	source "$relative_path/forwarding.config"
 fi
 
+source ../lib.sh
 ##############################################################################
 # Sanity checks
 
@@ -395,29 +393,6 @@ log_info()
 	echo "INFO: $msg"
 }
 
-busywait()
-{
-	local timeout=$1; shift
-
-	local start_time="$(date -u +%s%3N)"
-	while true
-	do
-		local out
-		out=$("$@")
-		local ret=$?
-		if ((!ret)); then
-			echo -n "$out"
-			return 0
-		fi
-
-		local current_time="$(date -u +%s%3N)"
-		if ((current_time - start_time > timeout)); then
-			echo -n "$out"
-			return 1
-		fi
-	done
-}
-
 not()
 {
 	"$@"
--- /dev/null
+++ b/tools/testing/selftests/net/lib.sh
@@ -0,0 +1,85 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+##############################################################################
+# Defines
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+##############################################################################
+# Helpers
+busywait()
+{
+	local timeout=$1; shift
+
+	local start_time="$(date -u +%s%3N)"
+	while true
+	do
+		local out
+		out=$("$@")
+		local ret=$?
+		if ((!ret)); then
+			echo -n "$out"
+			return 0
+		fi
+
+		local current_time="$(date -u +%s%3N)"
+		if ((current_time - start_time > timeout)); then
+			echo -n "$out"
+			return 1
+		fi
+	done
+}
+
+cleanup_ns()
+{
+	local ns=""
+	local errexit=0
+	local ret=0
+
+	# disable errexit temporary
+	if [[ $- =~ "e" ]]; then
+		errexit=1
+		set +e
+	fi
+
+	for ns in "$@"; do
+		ip netns delete "${ns}" &> /dev/null
+		if ! busywait 2 ip netns list \| grep -vq "^$ns$" &> /dev/null; then
+			echo "Warn: Failed to remove namespace $ns"
+			ret=1
+		fi
+	done
+
+	[ $errexit -eq 1 ] && set -e
+	return $ret
+}
+
+# setup netns with given names as prefix. e.g
+# setup_ns local remote
+setup_ns()
+{
+	local ns=""
+	local ns_name=""
+	local ns_list=""
+	for ns_name in "$@"; do
+		# Some test may setup/remove same netns multi times
+		if unset ${ns_name} 2> /dev/null; then
+			ns="${ns_name,,}-$(mktemp -u XXXXXX)"
+			eval readonly ${ns_name}="$ns"
+		else
+			eval ns='$'${ns_name}
+			cleanup_ns "$ns"
+
+		fi
+
+		if ! ip netns add "$ns"; then
+			echo "Failed to create namespace $ns_name"
+			cleanup_ns "$ns_list"
+			return $ksft_skip
+		fi
+		ip -n "$ns" link set lo up
+		ns_list="$ns_list $ns"
+	done
+}


