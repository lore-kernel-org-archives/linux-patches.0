Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CAE19E7F9;
	Tue, 27 May 2025 17:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365630; cv=none; b=qTDZiPmrmUJyMAV7SuMw4giq9kc6ONSBbYO3fd8CNfcALwFZxmjgjDYvZcUJwoNiak3FXNQoiwngTn9nuR71HkHfTEkNiVFheo/WCmlrokTggdEMdvY7G/krPkQOT7m3u88Ojl2DiRXPy/eW/Rq7gpBs6OzFOZQ+et8580GeAUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365630; c=relaxed/simple;
	bh=pL409jbWgEVHonVhItSjOvKPP4+Xb3w1lUgCAPivJ/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W1wBYNp9Nag/f0j++eD4ICm7bpuYrZN+iBKI2Dx/H6/H8yQ4VLrYjUKv7b31qj+loDjS5hMXGcvHvkjuo4ZauObuyjPrf6Dw/3Eman99oGejsiZgVXRrCGIlB78GF3mM9yQNdARSUzuYeHDsr2iBgJNk14iSw48MOZlc/cKqFRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHQOxA/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHQOxA/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF87AC4CEE9;
	Tue, 27 May 2025 17:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365630;
	bh=pL409jbWgEVHonVhItSjOvKPP4+Xb3w1lUgCAPivJ/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHQOxA/2p5sFREiATHyMXigSSoZTtlRi5r5ZKaFmu2YqIK3cBeqoXDOlbQmP0kIOM
	 2W4JNLhyoWaBBU4+7nztI4B18mM9eZLFpG64Vr7uIH/wg0ATUy2FGfQC4GqC3VUXo5
	 PzwhSW/tPauKz7PFlwNY2k5/ZpKHEsEFDXSk8OFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 438/626] tools/power turbostat: Clustered Uncore MHz counters should honor show/hide options
Date: Tue, 27 May 2025 18:25:31 +0200
Message-ID: <20250527162502.802224035@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 1c7c7388e6c31f46b26a884d80b45efbad8237b2 ]

The clustered uncore frequency counters, UMHz*.*
should honor the --show and --hide options.

All non-specified counters should be implicityly hidden.
But when --show was used, UMHz*.* showed up anyway:

$ sudo turbostat -q -S --show Busy%
Busy%  UMHz0.0  UMHz1.0  UMHz2.0  UMHz3.0  UMHz4.0

Indeed, there was no string that can be used to explicitly
show or hide clustered uncore counters.

Even through they are dynamically probed and added,
group the clustered UMHz*.* counters with the legacy
built-in-counter "UncMHz" for show/hide.

turbostat --show Busy%
	does not show UMHz*.*.
turbostat --show UncMHz
	shows either UncMHz or UMHz*.*, if present
turbostat --hide UncMHz
	hides either UncMHz or UMHz*.*, if present

Reported-by: Artem Bityutskiy <artem.bityutskiy@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Tested-by: Artem Bityutskiy <artem.bityutskiy@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.8 |  1 +
 tools/power/x86/turbostat/turbostat.c | 13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index a3cf1d17163ae..e4b00e13302b3 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -199,6 +199,7 @@ The system configuration dump (if --quiet is not used) is followed by statistics
 \fBUncMHz\fP per-package uncore MHz, instantaneous sample.
 .PP
 \fBUMHz1.0\fP per-package uncore MHz for domain=1 and fabric_cluster=0, instantaneous sample.  System summary is the average of all packages.
+For the "--show" and "--hide" options, use "UncMHz" to operate on all UMHz*.* as a group.
 .SH TOO MUCH INFORMATION EXAMPLE
 By default, turbostat dumps all possible information -- a system configuration header, followed by columns for all counters.
 This is ideal for remote debugging, use the "--out" option to save everything to a text file, and get that file to the expert helping you debug.
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 77ef60980ee58..12424bf08551d 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -6445,7 +6445,18 @@ static void probe_intel_uncore_frequency_cluster(void)
 		sprintf(path, "%s/current_freq_khz", path_base);
 		sprintf(name_buf, "UMHz%d.%d", domain_id, cluster_id);
 
-		add_counter(0, path, name_buf, 0, SCOPE_PACKAGE, COUNTER_K2M, FORMAT_AVERAGE, 0, package_id);
+		/*
+		 * Once add_couter() is called, that counter is always read
+		 * and reported -- So it is effectively (enabled & present).
+		 * Only call add_counter() here if legacy BIC_UNCORE_MHZ (UncMHz)
+		 * is (enabled).  Since we are in this routine, we
+		 * know we will not probe and set (present) the legacy counter.
+		 *
+		 * This allows "--show/--hide UncMHz" to be effective for
+		 * the clustered MHz counters, as a group.
+		 */
+		if BIC_IS_ENABLED(BIC_UNCORE_MHZ)
+			add_counter(0, path, name_buf, 0, SCOPE_PACKAGE, COUNTER_K2M, FORMAT_AVERAGE, 0, package_id);
 
 		if (quiet)
 			continue;
-- 
2.39.5



