Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94902C21F6;
	Tue, 12 Aug 2025 18:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024512; cv=none; b=VDIWxBIp0vHAl/Lx2Y1/AlREQrXRZiaMjH5WSBNzrMR7DhC3AwD+celV6QPfxlEzG3qz3ijbKb3xclXLCTIRxYSQtH73XKanDAzsdteoCCUoTcGfbs2rttaQFg5MSqhsz3E6Z2jpSDu7lKCb9R4z6aT2XVTGp5XFhBbz7sukRBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024512; c=relaxed/simple;
	bh=FtnzlqNSgSwmS5Y1UYfofBc2ZwNQ4xNx+DoEq7VeQec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3xZiygb3SadTf1McBrAhMwAm+P3wC87IhvTqKAmHKEdahvqIaTtNgdReIo10kJOOu9aasfdsbOBn1h9cXIMS+PcMrkQ3svzG9NQ7x7YZ0u0G1tAMHJBsElcD3GdWYB4KTesoFortrf4excfnzp/P2gJULxJnvVCbcxUxoT8b3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/1l5Qm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/1l5Qm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C74EC4CEF0;
	Tue, 12 Aug 2025 18:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024512;
	bh=FtnzlqNSgSwmS5Y1UYfofBc2ZwNQ4xNx+DoEq7VeQec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/1l5Qm9Y1JleKAfMqBnxIJZdjaAnXcDtTyNCE5fhts1do2xKOJIPdn4UhT6bm3X4
	 ZmTSMwqyuxHUKCLAkCH3m/V2e7wU1mISf1OJdZkqJCNIng441zbqSbkwMML9jWRwSI
	 PikZ2cgB9sksV1WLo6/nya0YPvY/wpqiFwGtVlQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 396/627] watchdog: ziirave_wdt: check record length in ziirave_firm_verify()
Date: Tue, 12 Aug 2025 19:31:31 +0200
Message-ID: <20250812173434.363296405@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 8b61d8ca751bc15875b50e0ff6ac3ba0cf95a529 ]

The "rec->len" value comes from the firmware.  We generally do
trust firmware, but it's always better to double check.  If
the length value is too large it would lead to memory corruption
when we set "data[i] = ret;"

Fixes: 217209db0204 ("watchdog: ziirave_wdt: Add support to upload the firmware.")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/3b58b453f0faa8b968c90523f52c11908b56c346.1748463049.git.dan.carpenter@linaro.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/ziirave_wdt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/watchdog/ziirave_wdt.c b/drivers/watchdog/ziirave_wdt.c
index fcc1ba02e75b..5c6e3fa001d8 100644
--- a/drivers/watchdog/ziirave_wdt.c
+++ b/drivers/watchdog/ziirave_wdt.c
@@ -302,6 +302,9 @@ static int ziirave_firm_verify(struct watchdog_device *wdd,
 		const u16 len = be16_to_cpu(rec->len);
 		const u32 addr = be32_to_cpu(rec->addr);
 
+		if (len > sizeof(data))
+			return -EINVAL;
+
 		if (ziirave_firm_addr_readonly(addr))
 			continue;
 
-- 
2.39.5



