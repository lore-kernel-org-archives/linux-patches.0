Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8394A17E90E;
	Mon, 27 May 2024 19:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836918; cv=none; b=cRXHRzLrtb4ffH42vX15+XUHjmVKJD8oQjUFIoRta5wxi56pM3Hk+5UQ3AgnwI7owC6HRxh/uyhmHizAxmlsbWCEO/282L3jvrHNYiz+NSefaMmzlE5ooOga21a3Asv4u1f6Supn/9so7RMHIGN9RU13YjugltWIISXwkJDkqGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836918; c=relaxed/simple;
	bh=DWDy1jJyNMmBp9euKaCI3aAzQR2K6mXOAYceF/KvOsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlGd/8Ib59EiXe0G4c83eVPp9rVhbpscqaU+GxDsVj+sLwbGB/ftF7HfjfVChlpChbYMAi17pcxs9v9shbgxRVB/LDex2ZDxq4903f77MCPMEsfWQt53af/flqhC14/QW4Br2d5eOk5FhVEuZ25twqcun04WR7a72nMynBRK+NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ViD6o3zl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViD6o3zl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17337C2BBFC;
	Mon, 27 May 2024 19:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836918;
	bh=DWDy1jJyNMmBp9euKaCI3aAzQR2K6mXOAYceF/KvOsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViD6o3zlKhYQWPmFfDEpZpH9ZdSeZDkKa4ccl55Q+f0pv5DekcK+OCIWX5En8VE29
	 tmzZRoKmwG78hk0oc3+wxVD3fXBuOP3L90M/27SbT22V+bWvQYdM1FCUBaMqqAmU0P
	 V9CQ4oTkatiCgc+yDgOiYOC6EPY7FRZFDIv6+/U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 240/427] selftests: net: move amt to socat for better compatibility
Date: Mon, 27 May 2024 20:54:47 +0200
Message-ID: <20240527185624.956790308@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4c639b6a7b9db236c0907aca8e92d1537076f2cd ]

The test seems to expect that nc will exit after the first
received message. This is not the case with Ncat 7.94.
There are multiple versions of nc out there, switch
to socat for better compatibility.

Tell socat to exit after 128 bytes and pad the message.

Since the test sets -e make sure we don't set exit code
(|| true) and print the pass / fail rather then silently
moving over the test and just setting non-zero exit code
with no output indicating what failed.

Fixes: c08e8baea78e ("selftests: add amt interface selftest script")
Acked-by: Paolo Abeni<pabeni@redhat.com>
Tested-by: Taehee Yoo <ap420073@gmail.com>
Link: https://lore.kernel.org/r/20240509161952.3940476-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/amt.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/amt.sh b/tools/testing/selftests/net/amt.sh
index 75528788cb95e..5175a42cbe8a2 100755
--- a/tools/testing/selftests/net/amt.sh
+++ b/tools/testing/selftests/net/amt.sh
@@ -210,8 +210,8 @@ check_features()
 
 test_ipv4_forward()
 {
-	RESULT4=$(ip netns exec "${LISTENER}" nc -w 1 -l -u 239.0.0.1 4000)
-	if [ "$RESULT4" == "172.17.0.2" ]; then
+	RESULT4=$(ip netns exec "${LISTENER}" timeout 15 socat - UDP4-LISTEN:4000,readbytes=128 || true)
+	if echo "$RESULT4" | grep -q "172.17.0.2"; then
 		printf "TEST: %-60s  [ OK ]\n" "IPv4 amt multicast forwarding"
 		exit 0
 	else
@@ -222,8 +222,8 @@ test_ipv4_forward()
 
 test_ipv6_forward()
 {
-	RESULT6=$(ip netns exec "${LISTENER}" nc -w 1 -l -u ff0e::5:6 6000)
-	if [ "$RESULT6" == "2001:db8:3::2" ]; then
+	RESULT6=$(ip netns exec "${LISTENER}" timeout 15 socat - UDP6-LISTEN:6000,readbytes=128 || true)
+	if echo "$RESULT6" | grep -q "2001:db8:3::2"; then
 		printf "TEST: %-60s  [ OK ]\n" "IPv6 amt multicast forwarding"
 		exit 0
 	else
@@ -236,14 +236,14 @@ send_mcast4()
 {
 	sleep 2
 	ip netns exec "${SOURCE}" bash -c \
-		'echo 172.17.0.2 | nc -w 1 -u 239.0.0.1 4000' &
+		'printf "%s %128s" 172.17.0.2 | nc -w 1 -u 239.0.0.1 4000' &
 }
 
 send_mcast6()
 {
 	sleep 2
 	ip netns exec "${SOURCE}" bash -c \
-		'echo 2001:db8:3::2 | nc -w 1 -u ff0e::5:6 6000' &
+		'printf "%s %128s" 2001:db8:3::2 | nc -w 1 -u ff0e::5:6 6000' &
 }
 
 check_features
-- 
2.43.0



