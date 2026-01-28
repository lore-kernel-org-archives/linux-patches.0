Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EF32874FE;
	Wed, 28 Jan 2026 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615970; cv=none; b=EdnsdBRXPa9S+brYZyo6fhHRMQL8wonlK+jhTlSAHp7F/hf0LC43IhfxuXDwT71BzIuSvm1ABIk+xQGzmvWs4nDMavjry+RRBJz7fiBV9gyARo5UFUEvJHR/pwHbDw58w67IcMTKgLkp5nH7+J8DoidPth7DCtOVK7gsj3TPblI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615970; c=relaxed/simple;
	bh=UwYazVYLrgEEVl+vhJlv2XDp8T2fpsCKeu1TZAE9z78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSIrMrXeLJ2Bgl6+DixGA9+/mDhNmS0pRmJVPu39Id6k8AqCpvNvhwf6Y+lcoGnETb6C+UXxLQU5gu41xwRFQDRQSPumNYkDrNpM5Lt2+vj1g/ZrgNsRpoSPBnrlel1PEWYLp58Q8AUiH1KNUG+FHgU3d2bzaY2Laf6PefIX0w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnbomqUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnbomqUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501EBC4CEF1;
	Wed, 28 Jan 2026 15:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615970;
	bh=UwYazVYLrgEEVl+vhJlv2XDp8T2fpsCKeu1TZAE9z78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnbomqUN40tIA6Zh1B4HdG1rCIdGKIsNnRVEoK8uRZQ3e84exhelCKw1vX3yw7/JL
	 s0ufO6BSmY9sfJSKL2fd2OvDV21rOPyft6a27leVty+cLrdkrE+UrlGWVWXVtWOKXx
	 v+hqLPC13VwQ7rGwS7TYmIzQaBW0xwFj2DqMUChk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/227] selftests: net: amt: wait longer for connection before sending packets
Date: Wed, 28 Jan 2026 16:23:01 +0100
Message-ID: <20260128145349.355058816@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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
index 3ef209cacb8ed..663744305e521 100755
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
@@ -246,14 +248,15 @@ test_ipv6_forward()
 
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



