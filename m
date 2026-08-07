Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B662B35E95F;
	Fri,  7 Aug 2026 14:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113906; cv=none; b=mQGeMJ267aTKBpn79gz48ajfXMgIe67+8nmr19dIfI+hCEZMIj/+ckfAx38Wwb3T745Z9GWOAjIiSggsmaSS8bv9K7H0bJbaLI0zeBkqLJEe9psdaL69NY8WcBHkLPxjBNYRi0XhSXhNb35dyNSNbRpNvMXFAiI2jGIEv2Sq5i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113906; c=relaxed/simple;
	bh=JJ/VrUb49zIgI/WfZb22X+IhsTtga0Jp9HGhwcxQUTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DowZnwudC/5F1d8U0zzw1+5r25JYqNudGgEeoHvLsibZvEjIHMCUs3mEdH6rmTsYh3Q07fKA+nO6yXPATC0eIDFze8HNvIvZnbjNhEVS0GZPN+msrqZ9H7qAiNYw7uHcnKKr6OjOQ8SKWCNfPo/joWPKF2/UwnooSUvcaZn5qPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysd1GMtC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysd1GMtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66D31F00A3A;
	Fri,  7 Aug 2026 14:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113897;
	bh=mVbjpZoX/CHNf4/U1pq83OJYgrhHYDhqa4Faf2ELvzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysd1GMtCRo56K/c26NGVYFwJ9WO5Hrbf1N46EMNpa9Q0BJLpGB8Hk6ZSU9irjeKMP
	 meGM6fqPqlzNvIfJ96P20TE3reqWiOexbnthO/3/+eMFD3dWTeaRHta/NYQAq7wsI4
	 pBxAIBXmjlFrYX4bB4JPAr9ssxz4JmFqOoCSqUyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Aleksandr Mezin <mezin.alexander@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/337] hwmon: (nzxt-smart2) DMA-align output buffer
Date: Fri,  7 Aug 2026 16:34:34 +0200
Message-ID: <20260807143420.049996651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 080bbf42faf77e6489ab30d5114c5f8f6ccbb1b8 ]

Sashiko reports:

When send_output_report() calls hid_hw_output_report(), the underlying USB
HID core calls usb_interrupt_msg() which maps this buffer directly for DMA.

When the DMA mapping flushes or invalidates the cacheline, it will corrupt
the adjacent variables (mutex, update_interval) that were modified
concurrently by the CPU. This causes memory corruption due to cacheline
sharing on non-coherent CPU architectures (such as ARM or MIPS). The DMA
API debugging tool (CONFIG_DMA_API_DEBUG) will trigger runtime warnings
for this violation.

Any operation that triggers send_output_report() (like setting a fan speed
or updating the interval) causes the USB DMA mapping. On systems with
non-coherent caches, this structural bug causes immediate and deterministic
memory corruption.

Align the output buffer to ARCH_DMA_MINALIGN to fix the problem.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 53e68c20aeb1 ("hwmon: add driver for NZXT RGB&Fan Controller/Smart Device v2.")
Cc: Aleksandr Mezin <mezin.alexander@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nzxt-smart2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/nzxt-smart2.c b/drivers/hwmon/nzxt-smart2.c
index 6f8febda4277c..66c5886f411a6 100644
--- a/drivers/hwmon/nzxt-smart2.c
+++ b/drivers/hwmon/nzxt-smart2.c
@@ -203,7 +203,7 @@ struct drvdata {
 	 */
 	struct mutex mutex;
 	long update_interval;
-	u8 output_buffer[OUTPUT_REPORT_SIZE];
+	u8 output_buffer[OUTPUT_REPORT_SIZE] __aligned(ARCH_DMA_MINALIGN);
 };
 
 static long scale_pwm_value(long val, long orig_max, long new_max)
-- 
2.53.0



