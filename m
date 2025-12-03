Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D99B33B6D9;
	Wed,  3 Dec 2025 16:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779029; cv=none; b=Y/qNyrG3JvDjsjFDSWfVvj509OW2529eAmY/LrApdOrrz2vDnyoH/miT8PsOG5UsFmryGdPcwHu83J+CxlAFEMnvOj9JB461Sj81N+FC8aKsoPflHq05RTs/DmBLltTZtDOlQglXQ6dkkudo42Kb8U+VqEJ9Yp0vzEsYrItIPfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779029; c=relaxed/simple;
	bh=0VNT+6BNgwz0fMUU3Sz9XmVzWcmagrwdTyi4DByJeW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhYTcwQ94h8Fcnmk6Q8+yFdDI/OnvPvIXAtzviUmol+RhcV8GfRrXTXxqZBIUKYLwy5XcX8wyMvgZKS7lk5Y7vCyOOk1oTmnrw+7d58BRjh9BrN3PbCkqciKGb76p38shmq/Gc/91JLEMRD1FJXp3spOMxCuGcb5itKzJlPLGew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdG3UISD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdG3UISD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E4EC4CEF5;
	Wed,  3 Dec 2025 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779029;
	bh=0VNT+6BNgwz0fMUU3Sz9XmVzWcmagrwdTyi4DByJeW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdG3UISDnRLUuX2pQJGAMT3E4WqvpYQcAvAlDT95G10ZVta/8qed6cT+API1qbSKe
	 yrj/1hE4U3Sum8HNyZTJM34SYU7hyPqysYIUXNEIsHKYg0GfjpEQ7+83rOkv/Zwdwa
	 SlLnSTdbwcUQQk1i/eo52ZqIRqqxBFPdHB5AYwH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Kehne <jens.kehne@agilent.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/568] mfd: da9063: Split chip variant reading in two bus transactions
Date: Wed,  3 Dec 2025 16:22:14 +0100
Message-ID: <20251203152445.562919160@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Kehne <jens.kehne@agilent.com>

[ Upstream commit 9ac4890ac39352ccea132109e32911495574c3ec ]

We observed the initial probe of the da9063 failing in
da9063_get_device_type in about 30% of boots on a Xilinx ZynqMP based
board. The problem originates in da9063_i2c_blockreg_read, which uses
a single bus transaction to turn the register page and then read a
register. On the bus, this should translate to a write to register 0,
followed by a read to the target register, separated by a repeated
start. However, we found that after the write to register 0, the
controller sometimes continues directly with the register address of
the read request, without sending the chip address or a repeated start
in between, which makes the read request invalid.

To fix this, separate turning the page and reading the register into
two separate transactions. This brings the initialization code in line
with the rest of the driver, which uses register maps (which to my
knowledge do not use repeated starts after turning the page). This has
been included in our kernel for several months and was recently
included in a shipped product. For us, it reliably fixes the issue,
and we have not observed any new issues.

While the underlying problem is probably with the i2c controller or
its driver, I still propose a change here in the interest of
robustness: First, I'm not sure this issue can be fixed on the
controller side, since there are other issues related to repeated
start which can't (AR# 60695, AR# 61664). Second, similar problems
might exist with other controllers.

Signed-off-by: Jens Kehne <jens.kehne@agilent.com>
Link: https://lore.kernel.org/r/20250804133754.3496718-1-jens.kehne@agilent.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9063-i2c.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/da9063-i2c.c b/drivers/mfd/da9063-i2c.c
index 343ed6e96d87e..6e48348cff054 100644
--- a/drivers/mfd/da9063-i2c.c
+++ b/drivers/mfd/da9063-i2c.c
@@ -37,9 +37,13 @@ enum da9063_page_sel_buf_fmt {
 	DA9063_PAGE_SEL_BUF_SIZE,
 };
 
+enum da9063_page_sel_msgs {
+	DA9063_PAGE_SEL_MSG = 0,
+	DA9063_PAGE_SEL_CNT,
+};
+
 enum da9063_paged_read_msgs {
-	DA9063_PAGED_READ_MSG_PAGE_SEL = 0,
-	DA9063_PAGED_READ_MSG_REG_SEL,
+	DA9063_PAGED_READ_MSG_REG_SEL = 0,
 	DA9063_PAGED_READ_MSG_DATA,
 	DA9063_PAGED_READ_MSG_CNT,
 };
@@ -65,10 +69,21 @@ static int da9063_i2c_blockreg_read(struct i2c_client *client, u16 addr,
 		(page_num << DA9063_I2C_PAGE_SEL_SHIFT) & DA9063_REG_PAGE_MASK;
 
 	/* Write reg address, page selection */
-	xfer[DA9063_PAGED_READ_MSG_PAGE_SEL].addr = client->addr;
-	xfer[DA9063_PAGED_READ_MSG_PAGE_SEL].flags = 0;
-	xfer[DA9063_PAGED_READ_MSG_PAGE_SEL].len = DA9063_PAGE_SEL_BUF_SIZE;
-	xfer[DA9063_PAGED_READ_MSG_PAGE_SEL].buf = page_sel_buf;
+	xfer[DA9063_PAGE_SEL_MSG].addr = client->addr;
+	xfer[DA9063_PAGE_SEL_MSG].flags = 0;
+	xfer[DA9063_PAGE_SEL_MSG].len = DA9063_PAGE_SEL_BUF_SIZE;
+	xfer[DA9063_PAGE_SEL_MSG].buf = page_sel_buf;
+
+	ret = i2c_transfer(client->adapter, xfer, DA9063_PAGE_SEL_CNT);
+	if (ret < 0) {
+		dev_err(&client->dev, "Page switch failed: %d\n", ret);
+		return ret;
+	}
+
+	if (ret != DA9063_PAGE_SEL_CNT) {
+		dev_err(&client->dev, "Page switch failed to complete\n");
+		return -EIO;
+	}
 
 	/* Select register address */
 	xfer[DA9063_PAGED_READ_MSG_REG_SEL].addr = client->addr;
-- 
2.51.0



