Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BE01F7569;
	Tue,  3 Dec 2024 14:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237962; cv=none; b=TL9yuIhjzf3YBlu0V01htSXWQH6UnJXtL2manfC9VC6Q/yACoG+a8I3txt86cvoE+v1UD+pCJegLUlS7IyblW2udUeruWuOr8ZC3fa8wTUbmmC85uki/gOv/YFDtBJF8Bd3oX7m7awtmFFcaF8aGk8mwXjWKECGa+EomGtAPyR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237962; c=relaxed/simple;
	bh=MxPh5gR3Dx7MVH2XfM2Lc5alaPSnUqanVJE0opTDvNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Onzcc/TbLCtBpJCEG8H4X9/7XodfyxlxRfAXxTyYi8mQM5ykpAijkp/GS+q+SHRYinIKdcDS7oK0itcvoETr5RbxydNsPXsHjhBCbCH6ngzDftOcqGCeZ/rt4U0eqnte7htYbQYLIslbPvv1kvG/hx9N+prF7CJ8wjMMmyHcP+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgTrVl2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgTrVl2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C793C4CECF;
	Tue,  3 Dec 2024 14:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237962;
	bh=MxPh5gR3Dx7MVH2XfM2Lc5alaPSnUqanVJE0opTDvNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgTrVl2pSJnmH3WAPI4FXzcGwTaK3ykuy3PK1T8jW/D3jHKqpZDd1r8x94S1BqDG7
	 WncIid74RtcVv48X4mrPo8VDr2aIW20HhPDv4TxeNbvcQzEYDzg1nqZ9UDpR1Td4Se
	 98YbvMQPb4F1e6rMwsprH8LD4+UHObcAmvtmnpLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 119/817] hwmon: (pmbus/core) clear faults after setting smbalert mask
Date: Tue,  3 Dec 2024 15:34:51 +0100
Message-ID: <20241203144000.359837434@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index e592446b26653..019c5982ba564 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -3199,7 +3199,17 @@ static int pmbus_regulator_notify(struct pmbus_data *data, int page, int event)
 
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



