Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7C8343210;
	Fri, 17 Oct 2025 15:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715159; cv=none; b=QAeQSOXZFPmhgRY0OCFKqgQOFPGt7o7wd366Mh+dqJavMWmwft2I2FgFl0ivzPNOZhJCvd8VSfQf+Utrl9YaamsfdgpQZan1EKTZbyiikEQozN5bdjwoujY4k4ePhbmBskIGCyKnq0pTMufZZ3ZlT/kOMdO3AM+Iojtxb9lJSC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715159; c=relaxed/simple;
	bh=vDc+BjPQjXziPngOTZMy6gSBV38lnaAgoC15GI54Cqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfd3SFHHm9JWYK/tyjonyDiAg6DwQIsI5Qb5iliAN9849f/1BsfIE/ekczw8WG6UuVf8JFVNNkmThnJp4CR5ZynffMHtg316ytqO1jVTuFfxKzWl1hB0x9S75v1wP0t6jz5hd2E7keiP25YfQ0okdozRCUJViXZp/s0gWBdEU3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/6nfUFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/6nfUFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D2BC113D0;
	Fri, 17 Oct 2025 15:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715159;
	bh=vDc+BjPQjXziPngOTZMy6gSBV38lnaAgoC15GI54Cqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/6nfUFgeiuR3D079LuKWK2egd0poJkl21kiTl+AGeGRsDmFxUga5TCyzYt4hIKpi
	 ZZ9B46pnwyY2TBOpF6+9BW9uwu9QM91Q0I9I1BXsNwKwhhje/Iv0Dkr8GBE1FnwNk2
	 Tpo6iYLFGqgQb9Y1NDzzm7g4BSz4IcQgVVAaZdM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 118/371] selftests: netfilter: nft_fib.sh: fix spurious test failures
Date: Fri, 17 Oct 2025 16:51:33 +0200
Message-ID: <20251017145206.204560457@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a126ab6b26f107f4eb100c8c77e9f10b706f26e6 ]

Jakub reports spurious failure of nft_fib.sh test.
This is caused by a subtle bug inherited when i moved faulty ping
from one test case to another.

nft_fib.sh not only checks that the fib expression matched, it also
records the number of matches and then validates we have the expected
count.  When I did this it was under the assumption that we would
have 0 to n matching packets.  In case of the failure, the entry has
n+1 matching packets.

This happens because ping_unreachable helper uses "ping -c 1 -w 1",
instead of the intended "-W".  -w alters the meaning of -c (count),
namely, its then treated as number of wanted *replies* instead of
"number of packets to send".

So, in some cases, ping -c 1 -w 1 ends up sending two packets which then
makes the test fail due to the higher-than-expected packet count.

Fix the actual bug (s/-w/-W) and also change the error handling:
1. Show the number of expected packets in the error message
2. Always try to delete the key from the set.
   Else, later test that makes sure we don't have unexpected keys
   in there will always fail as well.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netfilter-devel/20250927090709.0b3cd783@kernel.org/
Fixes: 98287045c979 ("selftests: netfilter: move fib vrf test to nft_fib.sh")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/netfilter/nft_fib.sh | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
index 9929a9ffef652..04544905c2164 100755
--- a/tools/testing/selftests/net/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
@@ -256,12 +256,12 @@ test_ping_unreachable() {
   local daddr4=$1
   local daddr6=$2
 
-  if ip netns exec "$ns1" ping -c 1 -w 1 -q "$daddr4" > /dev/null; then
+  if ip netns exec "$ns1" ping -c 1 -W 0.1 -q "$daddr4" > /dev/null; then
 	echo "FAIL: ${ns1} could reach $daddr4" 1>&2
 	return 1
   fi
 
-  if ip netns exec "$ns1" ping -c 1 -w 1 -q "$daddr6" > /dev/null; then
+  if ip netns exec "$ns1" ping -c 1 -W 0.1 -q "$daddr6" > /dev/null; then
 	echo "FAIL: ${ns1} could reach $daddr6" 1>&2
 	return 1
   fi
@@ -437,14 +437,17 @@ check_type()
 	local addr="$3"
 	local type="$4"
 	local count="$5"
+	local lret=0
 
 	[ -z "$count" ] && count=1
 
 	if ! ip netns exec "$nsrouter" nft get element inet t "$setname" { "$iifname" . "$addr" . "$type" } |grep -q "counter packets $count";then
-		echo "FAIL: did not find $iifname . $addr . $type in $setname"
+		echo "FAIL: did not find $iifname . $addr . $type in $setname with $count packets"
 		ip netns exec "$nsrouter" nft list set inet t "$setname"
 		ret=1
-		return 1
+		# do not fail right away, delete entry if it exists so later test that
+		# checks for unwanted keys don't get confused by this *expected* key.
+		lret=1
 	fi
 
 	# delete the entry, this allows to check if anything unexpected appeared
@@ -456,7 +459,7 @@ check_type()
 		return 1
 	fi
 
-	return 0
+	return $lret
 }
 
 check_local()
-- 
2.51.0



