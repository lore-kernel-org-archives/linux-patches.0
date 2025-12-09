Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00101A9B46;
	Tue,  9 Dec 2025 00:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239398; cv=none; b=ErI5MXTRn6+FVjnmc8big2KB8f1prDXRzzr0ZukkRZZ6o6LGyvomtuipHoGYBkGUzmylpLd0ikIaSL+BFYAfsMTmxBD3+5A+aCYvS/sWXYPZhomF4jCCVImNBEEaooIJ4ShhhXg5hUVr7QKTIar8+qX33PR6gwLb8XQ0YmI1CiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239398; c=relaxed/simple;
	bh=wiRysEFUkuhH+VlDpC3sA3h+zQjzRcu4gDivr+e3HQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSuHo8oI7iT/iPOYmt15ydDV3HyWiGMAWx9WURJMnHBJfRUHTrY4lTypBIbW0jJ1PGKpSymd71iWgm+9dYEvFAOM2ouYyX3yMIPikz4bu7u7qoS0znLjAM8K+9+Qah5dBv1HVVjfI92QlU0/IgPZQk1XrUcZ2USDO1hokbyVcCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUj2ROSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUj2ROSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3ED6C4CEF1;
	Tue,  9 Dec 2025 00:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239398;
	bh=wiRysEFUkuhH+VlDpC3sA3h+zQjzRcu4gDivr+e3HQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUj2ROSNIFLuS5zziufvGbzRJ33rQ6Ko5lMvZWb4H9vZdGbDAhKBIn82hq7CLjVuL
	 tAEUruA69S3eqq2lUhzJfw+6Fo1i5IlQ4INz7nIZIaNiiwJUjw41ABhHbE9GxZgQut
	 hfv0+8ZiHu7tH2lmVQEEEnPXBaMtJKrHtIQBs9kN6HyLYaeR+OLjWSYYaDqcF9Qn1G
	 455nMlwAzqanpWBD1VX3+5WnZs7g9SVIOW/OKiArSxibDt8nvVDvQ0kRYj7Kt/wYrk
	 atjfRtl719Yi2yddGcX2ccAL+5nZN/aHarzyeIkuVnVhSufmzHx4ZKX8N9BDfPKa1q
	 lI1YfZs0PfNLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ipv6: clean up routes when manually removing address with a lifetime
Date: Mon,  8 Dec 2025 19:14:55 -0500
Message-ID: <20251209001610.611575-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c7dc5b5228822d2389e6e441f10169e460bcc67a ]

When an IPv6 address with a finite lifetime (configured with valid_lft
and preferred_lft) is manually deleted, the kernel does not clean up the
associated prefix route. This results in orphaned routes (marked "proto
kernel") remaining in the routing table even after their corresponding
address has been deleted.

This is particularly problematic on networks using combination of SLAAC
and bridges.

1. Machine comes up and performs RA on eth0.
2. User creates a bridge
   - does an ip -6 addr flush dev eth0;
   - adds the eth0 under the bridge.
3. SLAAC happens on br0.

Even tho the address has "moved" to br0 there will still be a route
pointing to eth0, but eth0 is not usable for IP any more.

Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251113031700.3736285-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Analysis of Commit: ipv6: clean up routes when manually removing
address with a lifetime

## 1. COMMIT MESSAGE ANALYSIS

**Subject:** Fixes route cleanup when IPv6 addresses with finite
lifetimes are deleted manually

**Key Problem Described:**
- When an IPv6 address configured with `valid_lft` and `preferred_lft`
  is manually deleted, the kernel fails to clean up the associated
  prefix route
- Results in orphaned routes (marked "proto kernel") remaining in the
  routing table
- Particularly problematic with SLAAC + bridges (a real-world scenario)

**Tags:**
- `Reviewed-by: David Ahern` (network subsystem maintainer)
- `Reviewed-by: Ido Schimmel` (networking contributor)
- `Signed-off-by: Jakub Kicinski` (Linux networking maintainer)

**Notable Missing Tags:**
- No `Cc: stable@vger.kernel.org`
- No `Fixes:` tag

## 2. CODE CHANGE ANALYSIS

The core fix is extremely minimal - a single condition change in
`net/ipv6/addrconf.c`:

**Before:**
```c
if (ifp->flags & IFA_F_PERMANENT && !(ifp->flags & IFA_F_NOPREFIXROUTE))
```

**After:**
```c
if (!(ifp->flags & IFA_F_NOPREFIXROUTE))
```

**Technical Mechanism:**
- `IFA_F_PERMANENT` flag is set for addresses WITHOUT a finite lifetime
- Addresses with `valid_lft`/`preferred_lft` set do NOT have
  `IFA_F_PERMANENT`
- The old code only cleaned up prefix routes for permanent (infinite
  lifetime) addresses
- Non-permanent addresses (those with lifetimes) would have their routes
  orphaned on manual deletion
- The fix removes the overly-restrictive `IFA_F_PERMANENT` check,
  ensuring route cleanup for ALL addresses that don't have
  `IFA_F_NOPREFIXROUTE`

**Root Cause:** Logic error - the condition was too restrictive, failing
to clean up routes for addresses with finite lifetimes.

## 3. CLASSIFICATION

- **Bug Fix:** Yes - fixes route leakage/orphaning
- **New Feature:** No - corrects existing cleanup behavior
- **Security:** No explicit security issue, but orphaned routes can
  cause routing problems

## 4. SCOPE AND RISK ASSESSMENT

**Lines Changed:**
- Core fix: 1 line modified (condition simplification)
- Test: ~20 lines added to selftest

**Risk Level: LOW**
- The `check_cleanup_prefix_route()` and `cleanup_prefix_route()`
  functions already exist and are tested
- The fix EXTENDS existing cleanup to more cases (non-permanent
  addresses)
- No new code paths introduced, just removes an unnecessary condition
- Well-reviewed by multiple networking maintainers

## 5. USER IMPACT

**Affected Users:**
- Anyone using IPv6 with finite address lifetimes (SLAAC, DHCPv6)
- Users managing bridges with IPv6 addresses
- Enterprise/data center environments with complex networking

**Severity:** Medium
- Orphaned routes can cause routing confusion and network connectivity
  issues
- The SLAAC + bridge scenario is common in real-world deployments
- Routes pointing to unusable interfaces cause operational problems

## 6. STABILITY INDICATORS

**Positive:**
- Three experienced networking maintainers involved (Kicinski, Ahern,
  Schimmel)
- Includes selftest (`kci_test_addrlft_route_cleanup`) for regression
  testing
- Simple, surgical change with clear intent

## 7. DEPENDENCY CHECK

- Self-contained fix with no dependencies on other commits
- The affected functions (`check_cleanup_prefix_route`, etc.) have
  existed for a long time
- Should apply cleanly to recent stable kernels

## ASSESSMENT SUMMARY

**Pros:**
1. Fixes a real, user-visible bug (orphaned routes)
2. Extremely minimal change (removes one condition)
3. Strong review from key networking maintainers
4. Low regression risk - extends existing behavior to more cases
5. Includes regression test
6. Addresses a practical scenario (SLAAC + bridges)

**Cons/Considerations:**
1. No explicit `Cc: stable@vger.kernel.org` tag - maintainers didn't
   request backport
2. No `Fixes:` tag - unknown when bug was introduced (likely long-
   standing)
3. The bug has workarounds (routes eventually expire, or can be manually
   deleted)

## VERDICT

This commit is a good candidate for stable backporting. It is:
- **Obviously correct:** The `IFA_F_PERMANENT` check makes no logical
  sense for route cleanup
- **Fixes a real bug:** Orphaned routes are a tangible problem affecting
  real users
- **Small and contained:** Single condition change in one file
- **Low risk:** Extends existing cleanup mechanism to more cases
- **Well-tested:** Reviewed by maintainers and includes regression test

The lack of stable tags is notable but not disqualifying. The fix is
clearly beneficial and the risk is minimal. Stable tree users dealing
with IPv6 address lifetimes and bridges would benefit from this fix.

**YES**

 net/ipv6/addrconf.c                      |  2 +-
 tools/testing/selftests/net/rtnetlink.sh | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 40e9c336f6c55..b66217d1b2f82 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1324,7 +1324,7 @@ static void ipv6_del_addr(struct inet6_ifaddr *ifp)
 		__in6_ifa_put(ifp);
 	}
 
-	if (ifp->flags & IFA_F_PERMANENT && !(ifp->flags & IFA_F_NOPREFIXROUTE))
+	if (!(ifp->flags & IFA_F_NOPREFIXROUTE))
 		action = check_cleanup_prefix_route(ifp, &expires);
 
 	list_del_rcu(&ifp->if_list);
diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 163a084d525d5..248c2b91fe42b 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -8,6 +8,7 @@ ALL_TESTS="
 	kci_test_polrouting
 	kci_test_route_get
 	kci_test_addrlft
+	kci_test_addrlft_route_cleanup
 	kci_test_promote_secondaries
 	kci_test_tc
 	kci_test_gre
@@ -323,6 +324,25 @@ kci_test_addrlft()
 	end_test "PASS: preferred_lft addresses have expired"
 }
 
+kci_test_addrlft_route_cleanup()
+{
+	local ret=0
+	local test_addr="2001:db8:99::1/64"
+	local test_prefix="2001:db8:99::/64"
+
+	run_cmd ip -6 addr add $test_addr dev "$devdummy" valid_lft 300 preferred_lft 300
+	run_cmd_grep "$test_prefix proto kernel" ip -6 route show dev "$devdummy"
+	run_cmd ip -6 addr del $test_addr dev "$devdummy"
+	run_cmd_grep_fail "$test_prefix" ip -6 route show dev "$devdummy"
+
+	if [ $ret -ne 0 ]; then
+		end_test "FAIL: route not cleaned up when address with valid_lft deleted"
+		return 1
+	fi
+
+	end_test "PASS: route cleaned up when address with valid_lft deleted"
+}
+
 kci_test_promote_secondaries()
 {
 	run_cmd ifconfig "$devdummy"
-- 
2.51.0

