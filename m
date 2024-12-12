Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040F5236938;
	Thu, 12 Dec 2024 16:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021943; cv=none; b=b8U6ZGvSvFQnRYK9il/XlRu4Sj3260eBDNHiCqYt4MM2+aF0OBApAA8XSpX786V6/Nm5PFhNIc4TXSVpU+yskFEeehTaTsbQAqFeUYv+5JIsWd/bGDblOPB06+2TunT/rPLYDfBrRlzHoiTXCoypx2qsuEgpupR7qhirsvMv8qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021943; c=relaxed/simple;
	bh=7pWATYix23j5YJnrvGP6VkNvBbElK0xKwYgmVldAeI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoIbZQO+dgSzCMcMuHqId0TNBb4Gp1CVg3g/RFonUjTwiIQZGvQPVikVZZDz0CECZwFhso9QaEdhF0a6l/wXZ7gaC+S+H+OM+tU078yEuMilRvyB47oZKIZhpSmJxDdquv5ffwFOxU4F/uAzLjEcnvX+h+2vfgpdrgJdflYDv+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSbjRfAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSbjRfAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65694C4CECE;
	Thu, 12 Dec 2024 16:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021942;
	bh=7pWATYix23j5YJnrvGP6VkNvBbElK0xKwYgmVldAeI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSbjRfAsSo4RtiVLPIEJp1T72f+PeJgpFN3D/e34d4InQr5smS54IxOg5q0CI0cwx
	 lv6+D6W21DRWM9kbCoQ1aZoHCPqdj9yB4qSqlS+VVGgdOu9A8oMv/HB1g0E+QFPebG
	 t1cFzGasy8LYt6uCEkHyrfwVzNs4rCCVErOQG2RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/565] timekeeping: Consolidate fast timekeeper
Date: Thu, 12 Dec 2024 15:55:00 +0100
Message-ID: <20241212144315.629803112@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 90be8d6c1f91e1e5121c219726524c91b52bfc20 ]

Provide a inline function which replaces the copy & pasta.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220415091921.072296632@linutronix.de
Stable-dep-of: 5c1806c41ce0 ("kcsan, seqlock: Support seqcount_latch_t")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ce3d1377cbc7a..7f755127bee41 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -431,6 +431,14 @@ static void update_fast_timekeeper(const struct tk_read_base *tkr,
 	memcpy(base + 1, base, sizeof(*base));
 }
 
+static __always_inline u64 fast_tk_get_delta_ns(struct tk_read_base *tkr)
+{
+	u64 delta, cycles = tk_clock_read(tkr);
+
+	delta = clocksource_delta(cycles, tkr->cycle_last, tkr->mask);
+	return timekeeping_delta_to_ns(tkr, delta);
+}
+
 static __always_inline u64 __ktime_get_fast_ns(struct tk_fast *tkf)
 {
 	struct tk_read_base *tkr;
@@ -441,12 +449,7 @@ static __always_inline u64 __ktime_get_fast_ns(struct tk_fast *tkf)
 		seq = raw_read_seqcount_latch(&tkf->seq);
 		tkr = tkf->base + (seq & 0x01);
 		now = ktime_to_ns(tkr->base);
-
-		now += timekeeping_delta_to_ns(tkr,
-				clocksource_delta(
-					tk_clock_read(tkr),
-					tkr->cycle_last,
-					tkr->mask));
+		now += fast_tk_get_delta_ns(tkr);
 	} while (read_seqcount_latch_retry(&tkf->seq, seq));
 
 	return now;
@@ -545,10 +548,7 @@ static __always_inline u64 __ktime_get_real_fast(struct tk_fast *tkf, u64 *mono)
 		tkr = tkf->base + (seq & 0x01);
 		basem = ktime_to_ns(tkr->base);
 		baser = ktime_to_ns(tkr->base_real);
-
-		delta = timekeeping_delta_to_ns(tkr,
-				clocksource_delta(tk_clock_read(tkr),
-				tkr->cycle_last, tkr->mask));
+		delta = fast_tk_get_delta_ns(tkr);
 	} while (read_seqcount_latch_retry(&tkf->seq, seq));
 
 	if (mono)
-- 
2.43.0



