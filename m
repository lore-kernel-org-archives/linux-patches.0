Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FE131E107;
	Mon, 27 Oct 2025 19:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592893; cv=none; b=elKIJVWtOkE9xeZ3xXJpKAbm2UnxB1dVDaRkpwLWb/ugNAv7IVtbtnFePhkX2chsxKW0o0TIZ6yrjHuO5hjCgFAHPClKlu/R/Wk5/R3mqU6XWqqh6La+5DK9jzvSfITVfxOsj6T4qkU67DwqtJZ9iQLywtkwjXcban2Io2MuWUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592893; c=relaxed/simple;
	bh=FBTt/RY6MyGUCttokx96deFBvFrPhxbKX6PAKKWoO4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVBUxJeL4EgdVmvWQknozaISDyrS/zub1VVEWY1BxJfOZHcy7rLRdtPTdRkxwxMaT8SUsAyB87RORG1asDMvJuPLd3MgZJB65yhsFcQsX/lY8yRw91/VJvMiiET9xq9RbwMAo24UgHkTbUS4NCGj8gnLqoONe6IFnrSKTIxbZDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyDaEbpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyDaEbpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E673C4CEF1;
	Mon, 27 Oct 2025 19:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592893;
	bh=FBTt/RY6MyGUCttokx96deFBvFrPhxbKX6PAKKWoO4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyDaEbpxbVTUGl/Uw6xH9zytmJaNdL1jebTw8u0Qd/zKM4+C8syNM1V5+Eeh76E/B
	 y6z21HotT8gQznFyb0cHkqPxyCaDxlyQMcYXwpCgiaLFXJ2JtoGSEfrPz5/Ok5NTQf
	 wdLpHRsMvDmUkfpHKcR+G5Oeuh+hvOKqleSL3gko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 052/117] Revert "cpuidle: menu: Avoid discarding useful information"
Date: Mon, 27 Oct 2025 19:36:18 +0100
Message-ID: <20251027183455.416267806@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 10fad4012234a7dea621ae17c0c9486824f645a0 upstream.

It is reported that commit 85975daeaa4d ("cpuidle: menu: Avoid discarding
useful information") led to a performance regression on Intel Jasper Lake
systems because it reduced the time spent by CPUs in idle state C7 which
is correlated to the maximum frequency the CPUs can get to because of an
average running power limit [1].

Before that commit, get_typical_interval() would have returned UINT_MAX
whenever it had been unable to make a high-confidence prediction which
had led to selecting the deepest available idle state too often and
both power and performance had been inadequate as a result of that on
some systems.  However, this had not been a problem on systems with
relatively aggressive average running power limits, like the Jasper Lake
systems in question, because on those systems it was compensated by the
ability to run CPUs faster.

It was addressed by causing get_typical_interval() to return a number
based on the recent idle duration information available to it even if it
could not make a high-confidence prediction, but that clearly did not
take the possible correlation between idle power and available CPU
capacity into account.

For this reason, revert most of the changes made by commit 85975daeaa4d,
except for one cosmetic cleanup, and add a comment explaining the
rationale for returning UINT_MAX from get_typical_interval() when it
is unable to make a high-confidence prediction.

Fixes: 85975daeaa4d ("cpuidle: menu: Avoid discarding useful information")
Closes: https://lore.kernel.org/linux-pm/36iykr223vmcfsoysexug6s274nq2oimcu55ybn6ww4il3g3cv@cohflgdbpnq7/ [1]
Reported-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3663603.iIbC2pHGDl@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/governors/menu.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -199,20 +199,17 @@ again:
 	 *
 	 * This can deal with workloads that have long pauses interspersed
 	 * with sporadic activity with a bunch of short pauses.
+	 *
+	 * However, if the number of remaining samples is too small to exclude
+	 * any more outliers, allow the deepest available idle state to be
+	 * selected because there are systems where the time spent by CPUs in
+	 * deep idle states is correlated to the maximum frequency the CPUs
+	 * can get to.  On those systems, shallow idle states should be avoided
+	 * unless there is a clear indication that the given CPU is most likley
+	 * going to be woken up shortly.
 	 */
-	if (divisor * 4 <= INTERVALS * 3) {
-		/*
-		 * If there are sufficiently many data points still under
-		 * consideration after the outliers have been eliminated,
-		 * returning without a prediction would be a mistake because it
-		 * is likely that the next interval will not exceed the current
-		 * maximum, so return the latter in that case.
-		 */
-		if (divisor >= INTERVALS / 2)
-			return max;
-
+	if (divisor * 4 <= INTERVALS * 3)
 		return UINT_MAX;
-	}
 
 	thresh = max - 1;
 	goto again;


