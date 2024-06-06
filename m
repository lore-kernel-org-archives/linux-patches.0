Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C111BF8E3;
	Thu,  6 Jun 2024 14:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683551; cv=none; b=WZoCuBWKxCnjdsebZVaBgdH3TNPazEI3b0hTTikyfl4J9JBUwkL9v/FbLgpHfdgGiO0NVT4PfOIq+B/fUD4XXrgFO8YqUgFqh1FfDomWfNTLApvXtPK80XMb4JtCgZ1m2UxRzzNGMiXP+vnnmiSwr2422i+/X0Xu7DrSJ75lSl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683551; c=relaxed/simple;
	bh=8vaQF4XI8Jh83cpUUSetyJW6E6xnUJ5CAaTn0882Cek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eukJ9+1oxblwTnBqQYXYKQJdY2YzQA2Nf5VWIC01bWTRXtr9t/S5H8Q/YZIPdOtViE5d9qEYnqW/byKlKVKBxzJfl1kvHKgkTMrHiH0i9pe1UvcH5N7gClu2MYHo2OmN8/NzAh0kNZPieWs3nera3II+CtOLmOoi5fxybqTsNEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZienEmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZienEmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE80C2BD10;
	Thu,  6 Jun 2024 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683551;
	bh=8vaQF4XI8Jh83cpUUSetyJW6E6xnUJ5CAaTn0882Cek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZienEmz8YJ1i9xUz3zu0yuDfYb/XzZc3Sj4n3Br7xiPs9HoxY2lgGcnQXzYaF7Ar
	 4gvznS0CrnXDILScyBbm39ORaJySK//T4gILTpxz8Eixm/BHxXI8ydqR5MTkUmKC1G
	 d17GR4L6Y2ZtXaf1L6TZQKCG45Apb4xBlqoHaPX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 404/473] selftests: net: kill smcrouted in the cleanup logic in amt.sh
Date: Thu,  6 Jun 2024 16:05:33 +0200
Message-ID: <20240606131713.167794831@linuxfoundation.org>
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



