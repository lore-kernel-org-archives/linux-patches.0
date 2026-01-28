Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C837E2C11FD;
	Wed, 28 Jan 2026 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615241; cv=none; b=EI836WVjoVJUTcL9uBqUUtAieiQ0+wle5ZWGi41Ohwe2/Pls0UvV/TpGFiwnb1vQRlVmvza8t/DRGeFo+/s9dbH6douVUVYjLXLP+FFsFPVU1ALWGmfcRKs19Fbn35pbG0knoq9+3/sp9ZsJtqK/8aT8Z7wb9dV6ldbHlpg9XUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615241; c=relaxed/simple;
	bh=ulMXj80pwiQnlgdlStH/A1sIJlSE/xxQvFHrQaoxGDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mv8fqiUmA3zqrRCHrOtFWQDKPZR2n5UUlwfvr2cMarATJHldn357ikc2ftw+nNuxdisIhQSmNCFi2d18DnGj84gTp5TZuGDznzpViJ0meWRH0oTsnwai1+OESZw/NzPpjgEMt4Uo4cm5tf+tTluxZcV/7TDVbe4HbJYtZ9EHUuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wP8TvAuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wP8TvAuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD78C4CEF1;
	Wed, 28 Jan 2026 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615241;
	bh=ulMXj80pwiQnlgdlStH/A1sIJlSE/xxQvFHrQaoxGDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wP8TvAuwNBXriFWG1pEkzqzo+9xmciFswv1D4wPGOqSbMaiCjDAgJ7+fkHAMXI9YT
	 nQG1ZAe+XDlEI/9zbMoQOBlLaZ0TLjI3DNTII7A68nmlbePAUhPAHbjlRWyE4YRvMx
	 o7XkzgR+HeDoZC9q0iAQXcJwutJcHoxPQ28WcLqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/169] selftests: net: amt: wait longer for connection before sending packets
Date: Wed, 28 Jan 2026 16:22:51 +0100
Message-ID: <20260128145337.174418042@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d458b45c775b4..42957561c414a 100755
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



