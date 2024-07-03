Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5979173336;
	Wed,  3 Jul 2024 10:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004020; cv=none; b=VrtHln8k7nUmcCtBWSNOvX8qizC78b/vBjhY6NkvNwrt69A0JovzuaJ2M0A7Ov2Q7uoy/BZhd61T2DFKOvv2sPKltzxrmNIwFIyPCZga/ZvSN0Xn/O8Ss1lnPsqoGZAiV0SPUri/2JGG0z7ulhGpA+1r8gMBtKM8zKwUaJVUiLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004020; c=relaxed/simple;
	bh=irObsscxo2AkFfAmKgQ6qMYBcDctXHZil0FoB0+zLLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVHP72VGxfQvgwSP+LB4ZUQ8g+DeAMFd8YoZHNURq+3/2mQFp8YjGPq80IkSywary1dvYGhq7zZS5sw6AikXH3T4T+HegDfNUhUIXGX0b9Ai5mMrO/3b5/3TBDHCOQDDidKivyw8cxt+m7mue4fPI/2NgT0XViKCsILJtNLrplQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1M+7fm7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1M+7fm7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AA0C2BD10;
	Wed,  3 Jul 2024 10:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004020;
	bh=irObsscxo2AkFfAmKgQ6qMYBcDctXHZil0FoB0+zLLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1M+7fm7IZeSp6QRv3WUFI6nKA6VN4RjzWuq6ibKo/BzyTOMJFXWn1TBCiq8N3xNuN
	 wCFCuLmMtdKiOxJeDUb9P1hexuKaM5ga2c52HXl5FyIGbRYZiq8tNi4oCSfRylZhPn
	 QW0es8ILiCz+O6OMJajcrOGIyfDMH+FkB9uxJ9+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alessandro Carminati (Red Hat)" <alessandro.carminati@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/189] selftests/bpf: Prevent client connect before server bind in test_tc_tunnel.sh
Date: Wed,  3 Jul 2024 12:39:11 +0200
Message-ID: <20240703102844.898388286@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7c76b841b17bb..21bde60c95230 100755
--- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
@@ -71,7 +71,6 @@ cleanup() {
 server_listen() {
 	ip netns exec "${ns2}" nc "${netcat_opt}" -l -p "${port}" > "${outfile}" &
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
@@ -183,6 +192,7 @@ setup
 # basic communication works
 echo "test basic connectivity"
 server_listen
+wait_for_port ${port} ${netcat_opt}
 client_connect
 verify_data
 
@@ -194,6 +204,7 @@ ip netns exec "${ns1}" tc filter add dev veth1 egress \
 	section "encap_${tuntype}_${mac}"
 echo "test bpf encap without decap (expect failure)"
 server_listen
+wait_for_port ${port} ${netcat_opt}
 ! client_connect
 
 if [[ "$tuntype" =~ "udp" ]]; then
-- 
2.43.0



