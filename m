Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D2F171E70;
	Wed,  3 Jul 2024 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005665; cv=none; b=BghKShK2eOtybRDXioT2o+zlf/i2JpQSw/pgjZz8Fdp4CsYCJCs+8bI9jr07pOr2wVkNgzteO5OHI9q+HentWPDCKKvRy8RlMi4BPXAgEVK2OXl4ntCNqRzmErPfMV3U6U8sooEg9xJ6fddoMAj43JLAvWV42e8LXCFovaqTz0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005665; c=relaxed/simple;
	bh=83Mvu25hh8G5fiWjj5M0bIWVAuNWvEIL8Otrc6zjPZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Enkps7ctNDG86QG/RSXqCVVso1gEuEtYItJATwBQXWiyI9GbULNQZwfJJ/kgjOirCg9LBfIDUjuTUcI3aOz2VBmQQobXetqYW42O8Lo8pXSAbyDkb55wcCkLirOx4SVK8COi4Q1M3t3KULz1Gr6tGLhR6gO/fPYwU11i8/veL/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+hKXJkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+hKXJkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72936C2BD10;
	Wed,  3 Jul 2024 11:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005664;
	bh=83Mvu25hh8G5fiWjj5M0bIWVAuNWvEIL8Otrc6zjPZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+hKXJkUb8M6HrFPy7FE0qfcvjQjEFoBc8GaYi/WZPwZgnJIteeR7QOGXjQOuUs3r
	 Hojf8k1vLyOKdAn5flhB6oHYidB0GzqvLIrtrPQziozQOyn3fSO+GJGFiZjZeFgY7k
	 JAmqXPlKiKXSukcsdL97ofmhoQ9mY7Qw9JLggIRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alessandro Carminati (Red Hat)" <alessandro.carminati@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/356] selftests/bpf: Prevent client connect before server bind in test_tc_tunnel.sh
Date: Wed,  3 Jul 2024 12:38:12 +0200
Message-ID: <20240703102919.004545631@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>

[ Upstream commit f803bcf9208a2540acb4c32bdc3616673169f490 ]

In some systems, the netcat server can incur in delay to start listening.
When this happens, the test can randomly fail in various points.
This is an example error message:

   # ip gre none gso
   # encap 192.168.1.1 to 192.168.1.2, type gre, mac none len 2000
   # test basic connectivity
   # Ncat: Connection refused.

The issue stems from a race condition between the netcat client and server.
The test author had addressed this problem by implementing a sleep, which
I have removed in this patch.
This patch introduces a function capable of sleeping for up to two seconds.
However, it can terminate the waiting period early if the port is reported
to be listening.

Signed-off-by: Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240314105911.213411-1-alessandro.carminati@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_tc_tunnel.sh | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_tc_tunnel.sh b/tools/testing/selftests/bpf/test_tc_tunnel.sh
index 088fcad138c98..38c6e9f16f41e 100755
--- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
@@ -71,7 +71,6 @@ cleanup() {
 server_listen() {
 	ip netns exec "${ns2}" nc "${netcat_opt}" -l "${port}" > "${outfile}" &
 	server_pid=$!
-	sleep 0.2
 }
 
 client_connect() {
@@ -92,6 +91,16 @@ verify_data() {
 	fi
 }
 
+wait_for_port() {
+	for i in $(seq 20); do
+		if ip netns exec "${ns2}" ss ${2:--4}OHntl | grep -q "$1"; then
+			return 0
+		fi
+		sleep 0.1
+	done
+	return 1
+}
+
 set -e
 
 # no arguments: automated test, run all
@@ -189,6 +198,7 @@ setup
 # basic communication works
 echo "test basic connectivity"
 server_listen
+wait_for_port ${port} ${netcat_opt}
 client_connect
 verify_data
 
@@ -200,6 +210,7 @@ ip netns exec "${ns1}" tc filter add dev veth1 egress \
 	section "encap_${tuntype}_${mac}"
 echo "test bpf encap without decap (expect failure)"
 server_listen
+wait_for_port ${port} ${netcat_opt}
 ! client_connect
 
 if [[ "$tuntype" =~ "udp" ]]; then
-- 
2.43.0



