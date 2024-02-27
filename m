Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18D3140391;
	Tue, 27 Feb 2024 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042349; cv=none; b=eDdql4thc+IAmHy71+Yv6KfvB+YvaBS7OYrxSQICnCCNLsbVYGky0v6yJ88juCdBgWc5/m7hiR4VYc3OigBOnJT0AJwxVvLScVdeNNe+zpBz6bJtTPlVTIVVf6tOAq0D+ZDQHFL9u6D5MLoJSpfqe90o0BDpea33j6kONpLcSy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042349; c=relaxed/simple;
	bh=UoJAD0sEb3xlUCye/bxqDEVNmMIFy4pNrwGRlwaX3r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plZG31egpXxFtYHFfp0hQTMJLklp9mgLyPfYf6ZlI/mnOacYA7BU5BxcoSKWVGeVOUbY3WpXxj4e1VFQW+Av3jABepuWuFVoMdpuAZRrDEhCVlWbEolqCiEPWjVlUZZmPiEbxtd8xpiTAMT05n4gl8KJtgMbpaqCPgAtA45bPlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0s8sq+5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0s8sq+5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52292C433C7;
	Tue, 27 Feb 2024 13:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042349;
	bh=UoJAD0sEb3xlUCye/bxqDEVNmMIFy4pNrwGRlwaX3r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0s8sq+5d418qa0NkMCKyL0J/YOM5qP2HEUuNwLOnzOMcEmn7XhhPzr+1yEqTQBbRA
	 Ze2iSHA1b0q8Dtl1qWYps57n7yepfmaX38Kn6dx6WYqYP/SnD9hzUaePtxaVa2RGI/
	 qllbs+NVn3uLz+W2u3FtihRM/uhcULn5oaTNCe9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/299] net: ipa: dont overrun IPA suspend interrupt registers
Date: Tue, 27 Feb 2024 14:26:14 +0100
Message-ID: <20240227131634.159895367@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



