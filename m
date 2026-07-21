Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296CF415F14;
	Tue, 21 Jul 2026 19:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661366; cv=none; b=tU7s0q69NnPxaBqrW5vVbYUqpRQ8ud+Tr/EudHibrZ6uAfMNElizMTpY5DA+/+oIvPvPvub383cg6BHtNRGq9tFba8FLjQLYZgCv7/ZDrLQ7nME8gTQuGJ5b2CvMblyQVOgN9tsr7Eh/1IVUo3su35BZ1lowCDl7bXJ9NiRTMfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661366; c=relaxed/simple;
	bh=Cp0N8zoibTxrNIGe14Kv5LyxABY0+OCZuPvaMilFTfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAtcOR7IG3owJTp+P3aXrrkGA9W+o4NmmJ9fg4UZzcUunofhqaXdm1TvzqxiXkng50W4FnkmxCLbo4lrsDv6clnTqjA1vqW7htmFyXgtrtIvPvxdEg9ptK098cYeDki/xnMS255pLUaFtc1MJJnPo/7bEHfllnakNSb64srgOkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwZ9ajeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwZ9ajeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CA61F000E9;
	Tue, 21 Jul 2026 19:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661364;
	bh=Ln8IUz75l4rvyUQWEpv5SQlWrl+W3ru4WoLVsUfHW3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwZ9ajeLtYFq9wAUnlZAoxyPni33ggaeUwIVgqAtgAOY12DqHS26mUbzkJJxQxMfE
	 r9kK4aujUJXD8OzSP4JRLTUXQ8D+WppBmr3E4HiodTMlCx7mLEPmaEuh4idmTPL8cu
	 Tkjhhbf+qdmXJwcrFxWZChfeJYAfGU61vEyc/YUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Teddy Astie <teddy.astie@vates.tech>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0038/1276] time/jiffies: Register jiffies clocksource before usage
Date: Tue, 21 Jul 2026 17:08:01 +0200
Message-ID: <20260721152446.938428656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit f24df84cbe05e4471c04ac4b921fc0340bbc7752 ]

Teddy reported that a XEN HVM has a long boot delay, which was bisected to
the recent enhancements to the negative motion detection. It turned out
that the jiffies clocksource is used in early boot before it is registered,
which leaves the max_delta_raw field at zero. That causes the read out to
be clamped to the max delta of 0, which means time is not making progress.

Cure it by ensuring that it is initialized before its first usage in
timekeeping_init().

Fixes: 76031d9536a0 ("clocksource: Make negative motion detection more robust")
Reported-by: Teddy Astie <teddy.astie@vates.tech>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Teddy Astie <teddy.astie@vates.tech>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/87y0gn3fve.ffs@fw13
Closes: https://lore.kernel.org/all/1780914594.8631fc262581453bbf619ec5b2062170.19ea6c8227b000701b@vates.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/jiffies.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index bc4db9e5ab70c1..7ddedfa49b9dd8 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -61,15 +61,14 @@ EXPORT_SYMBOL(get_jiffies_64);
 
 EXPORT_SYMBOL(jiffies);
 
-static int __init init_jiffies_clocksource(void)
-{
-	return __clocksource_register(&clocksource_jiffies);
-}
-
-core_initcall(init_jiffies_clocksource);
+static bool cs_jiffies_registered __initdata;
 
 struct clocksource * __init __weak clocksource_default_clock(void)
 {
+	if (!cs_jiffies_registered) {
+		__clocksource_register(&clocksource_jiffies);
+		cs_jiffies_registered = true;
+	}
 	return &clocksource_jiffies;
 }
 
-- 
2.53.0



