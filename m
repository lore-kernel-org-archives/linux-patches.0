Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC74D2D6E63;
	Wed, 28 Jan 2026 15:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614618; cv=none; b=I8ULJe29a5GAMcTgnIHjg+t9GIG0yCYXuM+3hjrKof33BNjaYjME30/ZyGZkKEdVF6eTmPv/CpWnmzmk9urEX5BkrG+g2axEIhmpb3pTS51ly3gUGDB2sHc+BmOFR8dWZ89yyL8oSTPWoLkd39RaueJ98AQwFwNQ16p4IZPhSoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614618; c=relaxed/simple;
	bh=ZRjx3J/Wt4hs3u0jrNgyPrTQ6VVsqOdvuk/xBzEQGIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P93Op9/leaO+T18J80WwIQDLFCbxD1xIKevRYMlhtf+2w/b3B+resnhM+LTHbM/UBEfGED/iRFlmaSLeKoJflIvLFpkBDZ1TEHzJWv2r4q/C0EqF4WUtSJeciXc45k++xvxdZQWgP8k1elURloOisHkG0Hh6ANHwEZKfZ8M4J9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QawucV5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QawucV5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C18C4CEF1;
	Wed, 28 Jan 2026 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614618;
	bh=ZRjx3J/Wt4hs3u0jrNgyPrTQ6VVsqOdvuk/xBzEQGIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QawucV5Lb5RMyYh+gJZ0eOZCkoup20SW8ph3ZFOcqhZ8OPYnJlP8GUwE4MSzuSmh8
	 51pN82a5ZVMMnhzA5GU5Ez0Y9eBDgv1YsixguD22qi3n9oLqrTLlsjvz4DP2pTcMWa
	 xo/2zUhPc5IGCAbEqDGuajmU6/Fs5k2elZesSSMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/254] selftests: net: amt: wait longer for connection before sending packets
Date: Wed, 28 Jan 2026 16:22:30 +0100
Message-ID: <20260128145351.067074810@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 04708606fd7bdc34b69089a4ff848ff36d7088f9 ]

Both send_mcast4() and send_mcast6() use sleep 2 to wait for the tunnel
connection between the gateway and the relay, and for the listener
socket to be created in the LISTENER namespace.

However, tests sometimes fail because packets are sent before the
connection is fully established.

Increase the waiting time to make the tests more reliable, and use
wait_local_port_listen() to explicitly wait for the listener socket.

Fixes: c08e8baea78e ("selftests: add amt interface selftest script")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://patch.msgid.link/20260120133930.863845-1-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/amt.sh | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/amt.sh b/tools/testing/selftests/net/amt.sh
index 7e7ed6c558da9..ea40b469a8c11 100755
--- a/tools/testing/selftests/net/amt.sh
+++ b/tools/testing/selftests/net/amt.sh
@@ -73,6 +73,8 @@
 #       +------------------------+
 #==============================================================================
 
+source lib.sh
+
 readonly LISTENER=$(mktemp -u listener-XXXXXXXX)
 readonly GATEWAY=$(mktemp -u gateway-XXXXXXXX)
 readonly RELAY=$(mktemp -u relay-XXXXXXXX)
@@ -240,14 +242,15 @@ test_ipv6_forward()
 
 send_mcast4()
 {
-	sleep 2
+	sleep 5
+	wait_local_port_listen ${LISTENER} 4000 udp
 	ip netns exec "${SOURCE}" bash -c \
 		'printf "%s %128s" 172.17.0.2 | nc -w 1 -u 239.0.0.1 4000' &
 }
 
 send_mcast6()
 {
-	sleep 2
+	wait_local_port_listen ${LISTENER} 6000 udp
 	ip netns exec "${SOURCE}" bash -c \
 		'printf "%s %128s" 2001:db8:3::2 | nc -w 1 -u ff0e::5:6 6000' &
 }
-- 
2.51.0



