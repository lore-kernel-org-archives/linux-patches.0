Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FC21DFD91;
	Tue,  3 Dec 2024 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240330; cv=none; b=EJg/lxEH7AwK7BX/2f4WjMnitJjJ+FZ2ggs3enbPPlZscY+BWkCwTiCFhtv1861e/oPggrCBOef2B/QuKRLi4Qb/gQc2etTBX1OaQ4RxeY9f7wTsWMIq+jhVOtMOvrMcBErTJCrHw18DZP/7uIfhfZ8h4WG1DeiEdlMSyrecMDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240330; c=relaxed/simple;
	bh=5Ff2ASPgN7kZjlcuHKl1QGvrmOxDNLz7fNAvG7VBUr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js+xbz6V4lf7GRcYrZrgTdvcVbgvqlSjP6j0b9q+m3oSUFes1HiYLT4/4jH9Fz/SbOYzLUQ0mibT0tRmr1sau3OePRRQdgTWW1Qlw/Q3gyTHR3kCk7VUFzEUBxU66eAIrba17Hi+74GnYnl+ShSAMKJDq+KW92u9Ja71/u3SVLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7m7U4qN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7m7U4qN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811F6C4CECF;
	Tue,  3 Dec 2024 15:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240329;
	bh=5Ff2ASPgN7kZjlcuHKl1QGvrmOxDNLz7fNAvG7VBUr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7m7U4qNun5s4FmBwGccOOT+YYFIxMP2VUuaJdfZUjequiJ9D5wMCMBNkIPlSRzpJ
	 AFyDyVrq+ruaPchlUbtUl5loVZEXyFBFIAzpr3y2lwShAgUH63L3aSvDDdddxOP518
	 wrW1YEQ6wLUCT9S1j9JOum24FsRLCy40akui5lZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/826] hwmon: (pmbus/core) clear faults after setting smbalert mask
Date: Tue,  3 Dec 2024 15:36:38 +0100
Message-ID: <20241203144746.242537714@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 509c3a362675bc995771df74d545548f98e37621 ]

pmbus_write_smbalert_mask() ignores the errors if the chip can't set
smbalert mask the standard way. It is not necessarily a problem for the irq
support if the chip is otherwise properly setup but it may leave an
uncleared fault behind.

pmbus_core will pick the fault on the next register_check(). The register
check will fails regardless of the actual register support by the chip.

This leads to missing attributes or debugfs entries for chips that should
provide them.

We cannot rely on register_check() as PMBUS_SMBALERT_MASK may be read-only.

Unconditionally clear the page fault after setting PMBUS_SMBALERT_MASK to
avoid the problem.

Suggested-by: Guenter Roeck <linux@roeck-us.net>
Fixes: 221819ca4c36 ("hwmon: (pmbus/core) Add interrupt support")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Message-ID: <20241105-tps25990-v4-5-0e312ac70b62@baylibre.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index ce7fd4ca9d89b..a68b0a98e8d4d 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -3279,7 +3279,17 @@ static int pmbus_regulator_notify(struct pmbus_data *data, int page, int event)
 
 static int pmbus_write_smbalert_mask(struct i2c_client *client, u8 page, u8 reg, u8 val)
 {
-	return _pmbus_write_word_data(client, page, PMBUS_SMBALERT_MASK, reg | (val << 8));
+	int ret;
+
+	ret = _pmbus_write_word_data(client, page, PMBUS_SMBALERT_MASK, reg | (val << 8));
+
+	/*
+	 * Clear fault systematically in case writing PMBUS_SMBALERT_MASK
+	 * is not supported by the chip.
+	 */
+	pmbus_clear_fault_page(client, page);
+
+	return ret;
 }
 
 static irqreturn_t pmbus_fault_handler(int irq, void *pdata)
-- 
2.43.0



