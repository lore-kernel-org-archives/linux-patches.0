Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790961CEAC8;
	Tue, 27 Aug 2024 15:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772789; cv=none; b=l4dWn1ogvA9+wA6dH30CrukejWEiwsjeJvKaOoobPx9uLxqU95ePCR0rVivULCTxgQaoRLEXF8aHowfSE26Ypit6OJ91GphAbKoUSv207D4vm3o1fqsaY5/Yy9ivPWZ+wvD7ORil72qddl8I6mFHHtvMBjQqAoEh1IMTsAvBZJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772789; c=relaxed/simple;
	bh=EmLn3JA/M7gr9KlHKV3Fx77kiADaQQEi/yLp+BbJQ/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8HaBTQSvbaqBhQS49glSKuCZ/4/Ml/ZOIzWJWeHgDF4498kCmmhHLgkDwyNLVJUsqQRSHsK/dkBHDojSRXkOPR/8EaxeBsQ3K2R/ybCsLC6plL4LPEXZiRzv1wrgGeUktU9p0URe7e+IO5U+hEis91BVN3jbolCNc0jFmFzaHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJOCcOiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJOCcOiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE340C61050;
	Tue, 27 Aug 2024 15:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772789;
	bh=EmLn3JA/M7gr9KlHKV3Fx77kiADaQQEi/yLp+BbJQ/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJOCcOiAZ34d0qRtFSGfpcj3dw4USn145ITSYhH+8JpOJAH/J+eW5A6fWQzjzrnts
	 XwSdwN6EO47JrnuRNuoG+1T74pm2lhCAIeIuIbo6jEWfvwhLLBFnGkB6dP9JQpUQDj
	 Uf82OAAH5T+aLHhSitSz7/mxNJuHPPwiathi9cmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 320/321] selftests: net: more strict check in net_helper
Date: Tue, 27 Aug 2024 16:40:28 +0200
Message-ID: <20240827143850.440458698@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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


