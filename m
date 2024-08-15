Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ED51714A1;
	Thu, 15 Aug 2024 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729833; cv=none; b=VX7inUhnezrMGvXCmxwJglOQiuY7japwP9RCNEkxF2lp1ptHpglkQR4VwjnOESwlocOIodYZ/ut9sTQB+ehVrK3PU1V3baBFlOvgteLtAzOeqdGxNhCW/hbeMxX0qAJBBgBtVSyfBoIYYmhGMMLzJ94gqZuK3jJoPrSKI2phMq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729833; c=relaxed/simple;
	bh=RlRQzGMxtmUfMHwAggV/vODiKgp8qBpH0w6R/Oze5iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFB21U58kSWJHurDMM9j1imZmR6unWEhSkIfdjBhnHNuYGrHvkSt9J4Fv0u2n71jhQbHEAGl3/hixH7fZ3hu/OrnJku/bZrdJp/wRkyXw5z01iIy69pDjrpJV/F+dDzLoT0TwxDi3d4ufYK4mLJsMEI8dp4H6nQUq6GJFUkrbME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrlBcTOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrlBcTOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46E7C32786;
	Thu, 15 Aug 2024 13:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729833;
	bh=RlRQzGMxtmUfMHwAggV/vODiKgp8qBpH0w6R/Oze5iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrlBcTOBLsdsNFIDV84M7HB6fYy/tnyEA6iFwCs2RV+9J88OqVv3hliHBF8s5jdyI
	 DpIjaH9SQLTZeHRnDui3rMESmghiLUABkDhyuC2RctaVu1s/1Pd7VO9wxUWA59IY1O
	 ZZQUDqukE+w5SI6sFyeVv0t6cVWj+fqu+chFqB0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 221/484] mm/numa_balancing: teach mpol_to_str about the balancing mode
Date: Thu, 15 Aug 2024 15:21:19 +0200
Message-ID: <20240815131949.947754096@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit af649773fb25250cd22625af021fb6275c56a3ee upstream.

Since balancing mode was added in bda420b98505 ("numa balancing: migrate
on fault among multiple bound nodes"), it was possible to set this mode
but it wouldn't be shown in /proc/<pid>/numa_maps since there was no
support for it in the mpol_to_str() helper.

Furthermore, because the balancing mode sets the MPOL_F_MORON flag, it
would be displayed as 'default' due a workaround introduced a few years
earlier in 8790c71a18e5 ("mm/mempolicy.c: fix mempolicy printing in
numa_maps").

To tidy this up we implement two changes:

Replace the MPOL_F_MORON check by pointer comparison against the
preferred_node_policy array.  By doing this we generalise the current
special casing and replace the incorrect 'default' with the correct 'bind'
for the mode.

Secondly, we add a string representation and corresponding handling for
the MPOL_F_NUMA_BALANCING flag.

With the two changes together we start showing the balancing flag when it
is set and therefore complete the fix.

Representation format chosen is to separate multiple flags with vertical
bars, following what existed long time ago in kernel 2.6.25.  But as
between then and now there wasn't a way to display multiple flags, this
patch does not change the format in practice.

Some /proc/<pid>/numa_maps output examples:

 555559580000 bind=balancing:0-1,3 file=...
 555585800000 bind=balancing|static:0,2 file=...
 555635240000 prefer=relative:0 file=

Link: https://lkml.kernel.org/r/20240708075632.95857-1-tursulin@igalia.com
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
References: 8790c71a18e5 ("mm/mempolicy.c: fix mempolicy printing in numa_maps")
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2921,8 +2921,9 @@ out:
  * @pol:  pointer to mempolicy to be formatted
  *
  * Convert @pol into a string.  If @buffer is too short, truncate the string.
- * Recommend a @maxlen of at least 32 for the longest mode, "interleave", the
- * longest flag, "relative", and to display at least a few node ids.
+ * Recommend a @maxlen of at least 51 for the longest mode, "weighted
+ * interleave", plus the longest flag flags, "relative|balancing", and to
+ * display at least a few node ids.
  */
 void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 {
@@ -2931,7 +2932,10 @@ void mpol_to_str(char *buffer, int maxle
 	unsigned short mode = MPOL_DEFAULT;
 	unsigned short flags = 0;
 
-	if (pol && pol != &default_policy && !(pol->flags & MPOL_F_MORON)) {
+	if (pol &&
+	    pol != &default_policy &&
+	    !(pol >= &preferred_node_policy[0] &&
+	      pol <= &preferred_node_policy[ARRAY_SIZE(preferred_node_policy) - 1])) {
 		mode = pol->mode;
 		flags = pol->flags;
 	}
@@ -2958,12 +2962,18 @@ void mpol_to_str(char *buffer, int maxle
 		p += snprintf(p, buffer + maxlen - p, "=");
 
 		/*
-		 * Currently, the only defined flags are mutually exclusive
+		 * Static and relative are mutually exclusive.
 		 */
 		if (flags & MPOL_F_STATIC_NODES)
 			p += snprintf(p, buffer + maxlen - p, "static");
 		else if (flags & MPOL_F_RELATIVE_NODES)
 			p += snprintf(p, buffer + maxlen - p, "relative");
+
+		if (flags & MPOL_F_NUMA_BALANCING) {
+			if (!is_power_of_2(flags & MPOL_MODE_FLAGS))
+				p += snprintf(p, buffer + maxlen - p, "|");
+			p += snprintf(p, buffer + maxlen - p, "balancing");
+		}
 	}
 
 	if (!nodes_empty(nodes))


