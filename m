Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CF41EC00A;
	Tue, 15 Oct 2024 12:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994382; cv=none; b=mkoEXtoOvxYLH+iocvDzUiK/hjNLAXOXEHu4a0jzuyFap2j/30Kxyxo2HFrn39o0uQNlk2lnCI/8U3CgT4bigvddv8DmG/3sV9mKQXguEmfYGpsWtfrx+FAnZzh3UVwVuHw/U+5+RM5g1hurOsLEX3r4DC/jY8gjwakkD+tvnyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994382; c=relaxed/simple;
	bh=W9s8a0oGHflaT3bRY5GtnYPze6AGx+SF7HKvBosOiHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0YQQdMar8L013Pn8Gdhkx+HNWd0b+21F6RjgiPaZWfa9YrKcrAJlBjA2Q9DrstWlz51lTJTlTlTc3MXt+d5xiwb6+w/Le2NnYY2STqG2tQzZ2McOIDUHim15P4xSCUYR/SPsogkVwcx5Egd/G8ITz8liWfvZEAfiNyaDuvc51w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MFR6xij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MFR6xij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8FEC4CEC6;
	Tue, 15 Oct 2024 12:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994382;
	bh=W9s8a0oGHflaT3bRY5GtnYPze6AGx+SF7HKvBosOiHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MFR6xij3JXVCVkZJeCsT0YHQR7/GP6PG+G9hdEXFMz8uvom3Dc2aY+NEDBSSDnrD
	 LbWlckbL4wHGEWwSTxQ3zo9pdrlT6UZNvxcbeNU/QuMOOpx9lcJzSntRqElfoZDYD3
	 DX4qLevD9gt+FPZvh357XMtHIWOmc5hW8Y9hUEiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 690/691] selftests: net: more strict check in net_helper
Date: Tue, 15 Oct 2024 13:30:38 +0200
Message-ID: <20241015112507.703439768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit a71d0908e32f3dd41e355d83eeadd44d94811fd6 upstream.

The helper waiting for a listener port can match any socket whose
hexadecimal representation of source or destination addresses
matches that of the given port.

Additionally, any socket state is accepted.

All the above can let the helper return successfully before the
relevant listener is actually ready, with unexpected results.

So far I could not find any related failure in the netdev CI, but
the next patch is going to make the critical event more easily
reproducible.

Address the issue matching the port hex only vs the relevant socket
field and additionally checking the socket state for TCP sockets.

Fixes: 3bdd9fd29cb0 ("selftests/net: synchronize udpgro tests' tx and rx connection")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/192b3dbc443d953be32991d1b0ca432bd4c65008.1707731086.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/net_helper.sh |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/net_helper.sh
+++ b/tools/testing/selftests/net/net_helper.sh
@@ -8,13 +8,16 @@ wait_local_port_listen()
 	local listener_ns="${1}"
 	local port="${2}"
 	local protocol="${3}"
-	local port_hex
+	local pattern
 	local i
 
-	port_hex="$(printf "%04X" "${port}")"
+	pattern=":$(printf "%04X" "${port}") "
+
+	# for tcp protocol additionally check the socket state
+	[ ${protocol} = "tcp" ] && pattern="${pattern}0A"
 	for i in $(seq 10); do
-		if ip netns exec "${listener_ns}" cat /proc/net/"${protocol}"* | \
-		   grep -q "${port_hex}"; then
+		if ip netns exec "${listener_ns}" awk '{print $2" "$4}' \
+		   /proc/net/"${protocol}"* | grep -q "${pattern}"; then
 			break
 		fi
 		sleep 0.1


