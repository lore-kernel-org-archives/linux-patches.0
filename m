Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0414F19A2A7;
	Thu,  6 Jun 2024 14:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683017; cv=none; b=Frq95aU1jd2/pSTs4Hg6CE3mh/p/RKyYi4aJCUHUAFFuAq10ewmR2MU+kW5Ux9xXG+nFTxZ3ob0DfaLl9EaC70wP/Z7qhAXdfAAo4kQvTfHt+U3YTXfw+QyyXBY2pJ1FbQDPCExFbF4TTB1nMWVdEMtnCEXnVORSI7+VRzK9AaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683017; c=relaxed/simple;
	bh=bLKeizKXlxEvn02vlT3DE7EelCRsiPPua27/ut6AF60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+nXaXdLlSy/9A3v8uC5pDR7SyjLWzQFFwtILgJZYfSyj8g8kztNz0ZxoKvuZ1z36PbLL2dPTQsGtEowwcrETEUzkZPgncOTZtTSreDe/95PO0BtcF+Khct1ej5V/274AATstO7YBpzsqzXrMtnJ4WNFsC1VHQuP3nupWJ8SW+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLU3bnrX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLU3bnrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F21C32781;
	Thu,  6 Jun 2024 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683016;
	bh=bLKeizKXlxEvn02vlT3DE7EelCRsiPPua27/ut6AF60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLU3bnrXTvDjiPzK9ZqAMUerwiHTzBziiWJo+CCOx5MNx+GCWXV+fGmDndlkIX66M
	 YD4Q8JWNpF0mnbClsQqU5g5q/dWXlnezDrMSVtJEbKpBPYoo0nE1ys/VwFbZoSzkHE
	 1pjFrufp156G6Knd+OK8dDwSXXXEZodeOTeYmUes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 235/374] selftests: net: kill smcrouted in the cleanup logic in amt.sh
Date: Thu,  6 Jun 2024 16:03:34 +0200
Message-ID: <20240606131659.690749387@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit cc563e749810f5636451d4b833fbd689899ecdb9 ]

The amt.sh requires smcrouted for multicasting routing.
So, it starts smcrouted before forwarding tests.
It must be stopped after all tests, but it isn't.

To fix this issue, it kills smcrouted in the cleanup logic.

Fixes: c08e8baea78e ("selftests: add amt interface selftest script")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/amt.sh | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/amt.sh b/tools/testing/selftests/net/amt.sh
index 5175a42cbe8a2..7e7ed6c558da9 100755
--- a/tools/testing/selftests/net/amt.sh
+++ b/tools/testing/selftests/net/amt.sh
@@ -77,6 +77,7 @@ readonly LISTENER=$(mktemp -u listener-XXXXXXXX)
 readonly GATEWAY=$(mktemp -u gateway-XXXXXXXX)
 readonly RELAY=$(mktemp -u relay-XXXXXXXX)
 readonly SOURCE=$(mktemp -u source-XXXXXXXX)
+readonly SMCROUTEDIR="$(mktemp -d)"
 ERR=4
 err=0
 
@@ -85,6 +86,11 @@ exit_cleanup()
 	for ns in "$@"; do
 		ip netns delete "${ns}" 2>/dev/null || true
 	done
+	if [ -f "$SMCROUTEDIR/amt.pid" ]; then
+		smcpid=$(< $SMCROUTEDIR/amt.pid)
+		kill $smcpid
+	fi
+	rm -rf $SMCROUTEDIR
 
 	exit $ERR
 }
@@ -167,7 +173,7 @@ setup_iptables()
 
 setup_mcast_routing()
 {
-	ip netns exec "${RELAY}" smcrouted
+	ip netns exec "${RELAY}" smcrouted -P $SMCROUTEDIR/amt.pid
 	ip netns exec "${RELAY}" smcroutectl a relay_src \
 		172.17.0.2 239.0.0.1 amtr
 	ip netns exec "${RELAY}" smcroutectl a relay_src \
-- 
2.43.0



