Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02351C7D76;
	Thu,  6 Jun 2024 14:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683707; cv=none; b=gsayFKSFUWFipHKQQ/Ci+04aYe8XBog8Yn1RwOefIeLVsnjfh9jMPidcfhqLn94fgxTuegsPWmSkJ1N0oaNwrvYoW1GqOuEL1qcXUnyzp+hZkSkwTzS6pHYkNQCcHJYCft1pnbiGH8iaybBjW6rbciL8+idFDTtG9g9uEqCIgMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683707; c=relaxed/simple;
	bh=tEBr8ClS1/wEOOgqvVXfuyyP+iNcb5s/u9D/DPAN8bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZhP1qnpQRreVVd36aiV59NoH1DsZfRYe/ZiPXFg3FL2MWus2YmI+Dq6j9X+1VMlfZ6EldtGv3VXXBhrQu45bud5bDBWDcQVloxDMsoSUbniFkWgzwHtfFkzMCVUQhcSxZP7SmDlv9xMn5vGXlPna1V9O78XH3rBpHaQpvUfzHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IffV1sdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IffV1sdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA3DC2BD10;
	Thu,  6 Jun 2024 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683707;
	bh=tEBr8ClS1/wEOOgqvVXfuyyP+iNcb5s/u9D/DPAN8bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IffV1sdhy015GuqI0jesdwCibBY3sPSup0R5a4ma5Ntb/bRxQ/+M9rsZIZvT1ykMT
	 QEaU5S89+8JDPPwllxOhAU9xY3odp6oUhUvVTIH1cwFp46/hNfn7vynbA2t1gKU1RQ
	 vMGh8w5KzVSWCAjljC/45xhpF7rjZV4UwaNqQzpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 635/744] selftests: net: kill smcrouted in the cleanup logic in amt.sh
Date: Thu,  6 Jun 2024 16:05:07 +0200
Message-ID: <20240606131752.849072366@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



