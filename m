Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A47534D4D5;
	Fri, 21 Nov 2025 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732418; cv=none; b=uChwmLClT/tGE1CCemwhZQLL3j1AwuGn5isj75KHNfEPTlzgLBsnXzIO60jlsop6WFabVtzqk2tbe/FKLfxPGDFG8yvVaFDoWKELMP0gGpSYms51o+hwP+LVA87ydBBQfF4HIMwkQ4CwAS01hiq1/lsxfuFh8igcOOgnCVKLXi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732418; c=relaxed/simple;
	bh=BYVSfC+fc+MgS8G0St5LDZEDHK45npSciD8HWrzOIOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwfAvjebB8aMd3vcvvn4kQ5gHUUOO2vNEZX/eQEgDmNN3AA/8VI5kIX2AzOQZ5iXoI238OAMwvsl6QOFuK5Iqvv2BfXmnKsWfVgOGc96ry11DR52wwuqKytaQb3j7RKbTO+Vrmck/WsfSn1jVGEA3I4vR1vZ6947iDzaU3TItr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XegaNrjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XegaNrjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D246C4CEF1;
	Fri, 21 Nov 2025 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732418;
	bh=BYVSfC+fc+MgS8G0St5LDZEDHK45npSciD8HWrzOIOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XegaNrjd5h9oVN4kRdH4K9cFpzU6epnzSW6/oU+ANv0AkPHZC4TSBu3neYajiKbHy
	 qwipYl1BUaJu5DoHmFISvwBILIRK3yJyDDiL5NKxqVR03/n2yPLOtYEoZzBtSkVsL3
	 b9+jDtuIA09LUiT6rxa4tGS7xkrTuRMw14ZZOHTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Kehne <jens.kehne@agilent.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/529] mfd: da9063: Split chip variant reading in two bus transactions
Date: Fri, 21 Nov 2025 14:06:53 +0100
Message-ID: <20251121130235.081565639@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d715cf9a9e688..7b829bfe04bc7 100644
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



