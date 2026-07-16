Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3139A4314AD;
	Thu, 16 Jul 2026 14:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212204; cv=none; b=QXbKlLnXucf4lbQOlxKVoKGNBPqjLxnCVTCquDq0U1modoRL7hw27bfz9tE+177DTLcE9FGxSrcZCASTmDNCxG8XZoe/SAIa28Ey9u3N4RMVVpXTkhWZEbLPXP7V9aOpkszHEaFx1rbynaYttaB8IVT2DP7fLMLooWEp7sYS19g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212204; c=relaxed/simple;
	bh=qum9ldGfoZ9Ay4YgYjeLcpPcbpN0rdzidZKC310+YKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryxJKb5eFpofPU4U8T/JhvIbTFsMYaqiFukqu1jzlg5P4ZSb4lvPa6nrraHMJ1E0Ik7AbIinUgm6ZglnkEFTOsHoBvA3FQLyRkvylGIOqa7fTuJaha6//PGjILDOx+V2/HVOGOBjegvpVMPwXXxfAFJRo202Fi//njXhn8oXe1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEwHun55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEwHun55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B971F000E9;
	Thu, 16 Jul 2026 14:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212203;
	bh=t8q432Q7qjmaq7oSTPsQQXtXizaw6FlFDl+iAK8lMuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEwHun55CU+yobg8xkcJpZCHFP5WbDTw7SIUnD0uL1I8J21gbgjlzkxTPP77bDGrJ
	 7ys+DaIYLHWtIh+s+cOUjnD3LkCCx4bqUe85UHokvAyfF2U5plHSkqWupO8kQNKppV
	 hkMlNmkaJzKBWkm96F8Y/jWVDR0h5YBaqPPmQ1Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Teddy Astie <teddy.astie@vates.tech>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 195/349] time/jiffies: Register jiffies clocksource before usage
Date: Thu, 16 Jul 2026 15:32:09 +0200
Message-ID: <20260716133037.738722497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

commit f24df84cbe05e4471c04ac4b921fc0340bbc7752 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/jiffies.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

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
 


