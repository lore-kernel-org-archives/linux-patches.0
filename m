Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DF9197A91;
	Thu,  6 Jun 2024 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683294; cv=none; b=EJcNkx8v1k/YUewpkQCuorDEZOaUQe83TmMcOvbM6dLG41tVnkueMGBHBe2UeeSUQPnT08IqCn4CGZc8jttKp1aHGKv6YEoxpVz64XAW5hI1euvE3MF4xF54Y+3h/NYkT2tw4SiSzxDQW7ds0j4a1vVcI6iBH91eE69wmyOGito=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683294; c=relaxed/simple;
	bh=tx/VeiW4OR7b0Gpk1KDDOcofgJ/lvtPKMdvYKjcrqXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pns720QkcQv+ET2q99pVC9/wa5y4A3+HcM41OuiA3qSg384NN13Ktpc9PNK2dOZCIT4hO7Vls9DgM+IjkKOabSVqtPCqRepw6WDVwZnzFwGCcYvDi5ecK/xqWQnu+zZJs6hAue0E04Jw1e1CoOmQGtL9yaKF2Lq6dWdh5rCFY8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXCsJdjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXCsJdjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C08C2BD10;
	Thu,  6 Jun 2024 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683294;
	bh=tx/VeiW4OR7b0Gpk1KDDOcofgJ/lvtPKMdvYKjcrqXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXCsJdjcRvn5zieLwclu+82G6Uz8pb41R4a9rvcQmUi3WNgiy38ou7xN8rbwPzq70
	 HTi8KS6P0IWnRCgYJ/hqK3JxVO7841X8xh2l5sGLYquP0I8BFKIJTvWthis4E8vv+G
	 AL6j8BofF3+mH15chZtg9DVIhUwPtywU159T++Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/473] selftests: net: move amt to socat for better compatibility
Date: Thu,  6 Jun 2024 16:01:39 +0200
Message-ID: <20240606131705.563954160@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



