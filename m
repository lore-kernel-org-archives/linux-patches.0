Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11AF13AA2F;
	Tue, 27 Feb 2024 13:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041320; cv=none; b=Ow11J0pswWbFk4oz30aSor/UXgZBPxJdEvH1qxbkz2gDNjohy8j3GJqFhoX/d0vpuQytM/p/l11L1ORTsindZpiBlc09bg4ms0qrGY03gY0uAD7k85ViW5Yxm/nVrdpZyeTaZt5Fq+ldS3rfA8fQd27t7uBhI87aBJOZECY9f8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041320; c=relaxed/simple;
	bh=xJ5EsSYKMAeVJkJHloafoK42N0IJ5/DV81vQWEucIDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcNPSVcNJujaOmZ5w96eJ8DgTbHX0EjHFtvMMoEudIUSrU9RSPb0IYJAEjGDH/6nScll/g/AFgyqNL7x9OELhrdDKSallhrAGEig5/3pZOrd2EAZfU4MGm6SkrPGDFZ/37+PrjBP0mgFadqX72ZXyiht+Jyp6Z24BvAL6/TzXKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zW2hOYL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zW2hOYL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0A9C433C7;
	Tue, 27 Feb 2024 13:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041319;
	bh=xJ5EsSYKMAeVJkJHloafoK42N0IJ5/DV81vQWEucIDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zW2hOYL3245QgHvtSr3df+OxXUmi5eCsHUkWJXvqmREHQtTB35MHYzkHof24jt+u3
	 zpEmlJPAdaJLL/Xbvi469dFAYWDzC9BpW80lOWlreXrsJWnVYEzJxTQ9fnh/d/tHRv
	 XYzhz33du+tgnPnddUvbmbuF+W+XWfKx3U7AnlIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 297/334] net: ipa: dont overrun IPA suspend interrupt registers
Date: Tue, 27 Feb 2024 14:22:35 +0100
Message-ID: <20240227131640.626744641@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@linaro.org>

[ Upstream commit d80f8e96d47d7374794a30fbed69be43f3388afc ]

In newer hardware, IPA supports more than 32 endpoints.  Some
registers--such as IPA interrupt registers--represent endpoints
as bits in a 4-byte register, and such registers are repeated as
needed to represent endpoints beyond the first 32.

In ipa_interrupt_suspend_clear_all(), we clear all pending IPA
suspend interrupts by reading all status register(s) and writing
corresponding registers to clear interrupt conditions.

Unfortunately the number of registers to read/write is calculated
incorrectly, and as a result we access *many* more registers than
intended.  This bug occurs only when the IPA hardware signals a
SUSPEND interrupt, which happens when a packet is received for an
endpoint (or its underlying GSI channel) that is suspended.  This
situation is difficult to reproduce, but possible.

Fix this by correctly computing the number of interrupt registers to
read and write.  This is the only place in the code where registers
that map endpoints or channels this way perform this calculation.

Fixes: f298ba785e2d ("net: ipa: add a parameter to suspend registers")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 4bc05948f772d..a78c692f2d3c5 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -212,7 +212,7 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt)
 	u32 unit_count;
 	u32 unit;
 
-	unit_count = roundup(ipa->endpoint_count, 32);
+	unit_count = DIV_ROUND_UP(ipa->endpoint_count, 32);
 	for (unit = 0; unit < unit_count; unit++) {
 		const struct reg *reg;
 		u32 val;
-- 
2.43.0



