Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9289E37CD32;
	Sat, 12 Sep 2026 09:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204789; cv=none; b=PTMCXMFj4ET5CzHgYK3V6vvH0Xro2jFUt5YHf0glklDh0o58G9t9RnKosWhOy596f68FwGoNLY2PKt88sLiqzF76sqx6/x59yda2ZZl3KQcn8krzRcwguhT26F15iNWxaxubdE0WHtu/n2yO2gKimp9Y1KMxjTR8ZtJEHLvUrKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204789; c=relaxed/simple;
	bh=Uh6TJkofCB3L5wOBSEgybkqKXKQFBBSeIKqzqleVbTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIOwxN0EQ+amgg4eRlNzkUz9THy/8NRtU/KZnxJ6D1ZELk4HnbPu1VAn/O7zhR93M+dG5x2KdEslpQSba1c6s9ctBI/CFiNPxQFTHerW8FXUgcDXoVVwc8YmyWzzmX08agvIf+FBoNRhvvu2bVnfLc4d0Wa9v4p03z899Ob5oqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shcov3p8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shcov3p8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979181F000FF;
	Sat, 12 Sep 2026 09:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204788;
	bh=7cDpFlQYZ2oQB3Zs9H4OkEGau6bkfsupecNDKFid9Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shcov3p8y98uL5JypUK5onoPzJ7asAN3Tt46CNnMREANyRI3OGU/inI/wz/O2JZXe
	 XxAo+vVgz1X6ZoF5WYF7vuQVhrNXk/RaBdeTjN12AEGIG+RRbbxOZXbZyPbTn2vKsh
	 Acd3+54ZLuF31pqZo7OrZ9A7aZN7JVB+xqfDMq3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jyoti, Anand B" <anand.b.jyoti@intel.com>,
	"Li, Yifan" <yifan2.li@intel.com>,
	Gao Jianfeng <jianfeng.gao@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1684/1815] powercap: intel_rapl: Sign-extend the PMU delta on counter wraparound
Date: Sat, 12 Sep 2026 08:57:14 +0200
Message-ID: <20260912065728.516614548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li, Yifan <yifan2.li@intel.com>

[ Upstream commit a8b842366f8ff469fe0fc700ba53770ded847ea9 ]

The RAPL PMU misreports energy when the hardware energy counter
overflows and wraps back to zero.  perf event counts are defined to
increase monotonically, but a single wraparound makes the PMU event
count jump backwards by nearly the full counter range, and consumers
that take the difference of two reads in unsigned arithmetic then
underflow and report an absurd value.

On a Panther Lake system (energy unit 61.035 uJ, counter range
262144 J) the package counter wraps every ~2.9 hours at 25 W, and
turbostat prints one bogus sample per wraparound, per domain:

  PkgTmp  PkgWatt         CorWatt GFXWatt RAMWatt SysWatt
  44      24.97           16.30   3.90    1.87    2145386370.35
  43      2145240612.10   16.13   4.02    1.91    40.46

The RAPL energy counters are 32-bit wide on every register interface:
MSR, MMIO and TPMI all describe ENERGY_COUNTER with a GENMASK(31, 0)
mask.  rapl_read_data_raw() applies that mask, so event_read_counter()
returns the counter zero-extended in a u64.

rapl_event_update() then computes

	delta = new_raw_count - prev_raw_count;

without reducing the result modulo 2^32.  While the counter does not
wrap this is correct, but once the hardware counter wraps,
new_raw_count < prev_raw_count and delta becomes (true_delta - 2^32),
a large negative value.  Declaring delta as s64 only makes that value
representable; it does not correct it.  That bogus delta is scaled and
added to event->count, which is where the backwards jump comes from.

Fix it the way arch/x86/events/rapl.c has done since the RAPL PMU was
first introduced: shift both values up so that the 64-bit subtraction
reduces modulo 2^32, then shift the difference back down with an
arithmetic shift to sign-extend it.

This is correct as long as at most one wraparound happens between two
updates, which the existing overflow hrtimer already guarantees: its
period is half of the counter range at the 200 W reference used in
rapl_package_add_pmu_locked().

The problem has been present since the powercap RAPL PMU was added, but
only affected TPMI RAPL until commit 748d6ba43afd ("powercap:
intel_rapl: Enable MSR-based RAPL PMU support") routed MSR RAPL through
the same PMU, which exposed it on client platforms such as Panther Lake.

Fixes: 575024a8aa7c ("powercap: intel_rapl: Introduce APIs for PMU support")
Reported-by: Jyoti, Anand B <anand.b.jyoti@intel.com>
Signed-off-by: Li, Yifan <yifan2.li@intel.com>
Signed-off-by: Gao Jianfeng <jianfeng.gao@intel.com>
Tested-by: Jyoti, Anand B <anand.b.jyoti@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://patch.msgid.link/20260814031008.750911-1-yifan2.li@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 1006d183d5081..6b7d11a0abc5d 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -32,6 +32,9 @@
 
 #define ENERGY_STATUS_MASK		GENMASK(31, 0)
 
+/* Width of the RAPL energy counters, see the *_ENERGY_STATUS_MASK defines */
+#define RAPL_CNTR_WIDTH			32
+
 #define POWER_UNIT_OFFSET		0x00
 #define POWER_UNIT_MASK			GENMASK(3, 0)
 
@@ -1227,6 +1230,7 @@ static u64 rapl_event_update(struct perf_event *event)
 	struct rapl_package_pmu_data *data = event_to_pmu_data(event);
 	u64 prev_raw_count, new_raw_count;
 	s64 delta, sdelta;
+	int shift = 64 - RAPL_CNTR_WIDTH;
 
 	/*
 	 * Follow the generic code to drain hwc->prev_count.
@@ -1243,8 +1247,13 @@ static u64 rapl_event_update(struct perf_event *event)
 	 * Now we have the new raw value and have updated the prev
 	 * timestamp already. We can now calculate the elapsed delta
 	 * (event-)time and add that to the generic event.
+	 *
+	 * Careful, the counter is narrower than u64 and is not
+	 * sign-extended above its physical width.  Shift both values up
+	 * so that the subtraction wraps, then shift the result back down.
 	 */
-	delta = new_raw_count - prev_raw_count;
+	delta = (new_raw_count << shift) - (prev_raw_count << shift);
+	delta >>= shift;
 
 	/*
 	 * Scale delta to smallest unit (2^-32)
-- 
2.53.0



