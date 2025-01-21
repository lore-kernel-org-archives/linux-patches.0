Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B8D1F709E;
	Tue, 21 Jan 2025 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482347; cv=none; b=Ra2zNaeQ1TKOxAVvIRUdDemSBTA/cioKxawhD30icYGe0blfXyQUqHideredN12NLRV08TI7N1OdH94FWd0j9AIRzSceGONfRus6SE9NBRhwpdkEvCBtf2M922xS62MyD6hm0O5SrpORch4FzZhy+2PDHvT7pfYe26Wa7mnniPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482347; c=relaxed/simple;
	bh=JXMPapz3PPwPVzXMYBIZuKDo9TYzUCzPWTWOMlljSxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxDim+K/Fkg+goGTWXbJsTRc6TSNMWjUDh+740RaguLPCcu/cM0/JU1e/bjiXgv175PRLnW2/DPrhf3wt2xxip1/Cigvnnq4r1CD+pFpVeDcUVPkAOCWbxD4+SsQc7W5bnzbRCGf50iXxLjlLSVEHWjHKZssOSiEnoT39xzDfoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVlA2ULt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVlA2ULt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE58C4CEDF;
	Tue, 21 Jan 2025 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482347;
	bh=JXMPapz3PPwPVzXMYBIZuKDo9TYzUCzPWTWOMlljSxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVlA2ULtDWEhome90jJzVIch/9yjZJVshPinl2rS0CWKWS/HohKHpyxmUAjMJR0YG
	 k1DTRZ1anzFPTqGfHuBzyALnRhhDyVHjH/2L2Ns+XtjHcBQPyKyX9P1vm9GP9zafLR
	 DFxGqzvQlnPwz1nDLRAXAF7Dn14vmfPybyh2w8Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/122] i2c: testunit: on errors, repeat NACK until STOP
Date: Tue, 21 Jan 2025 18:51:34 +0100
Message-ID: <20250121174534.759740908@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 6ad30f7890423341f4b79329af1f9b9bb3cdec03 ]

This backend requests a NACK from the controller driver when it detects
an error. If that request gets ignored from some reason, subsequent
accesses will wrongly be handled OK. To fix this, an error now changes
the state machine, so the backend will report NACK until a STOP
condition has been detected. This make the driver more robust against
controllers which will sadly apply the NACK not to the current byte but
the next one.

Fixes: a8335c64c5f0 ("i2c: add slave testunit driver")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-slave-testunit.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/i2c-slave-testunit.c b/drivers/i2c/i2c-slave-testunit.c
index 9fe3150378e86..7ae0c7902f670 100644
--- a/drivers/i2c/i2c-slave-testunit.c
+++ b/drivers/i2c/i2c-slave-testunit.c
@@ -38,6 +38,7 @@ enum testunit_regs {
 
 enum testunit_flags {
 	TU_FLAG_IN_PROCESS,
+	TU_FLAG_NACK,
 };
 
 struct testunit_data {
@@ -90,8 +91,10 @@ static int i2c_slave_testunit_slave_cb(struct i2c_client *client,
 
 	switch (event) {
 	case I2C_SLAVE_WRITE_REQUESTED:
-		if (test_bit(TU_FLAG_IN_PROCESS, &tu->flags))
-			return -EBUSY;
+		if (test_bit(TU_FLAG_IN_PROCESS | TU_FLAG_NACK, &tu->flags)) {
+			ret = -EBUSY;
+			break;
+		}
 
 		memset(tu->regs, 0, TU_NUM_REGS);
 		tu->reg_idx = 0;
@@ -99,8 +102,10 @@ static int i2c_slave_testunit_slave_cb(struct i2c_client *client,
 		break;
 
 	case I2C_SLAVE_WRITE_RECEIVED:
-		if (test_bit(TU_FLAG_IN_PROCESS, &tu->flags))
-			return -EBUSY;
+		if (test_bit(TU_FLAG_IN_PROCESS | TU_FLAG_NACK, &tu->flags)) {
+			ret = -EBUSY;
+			break;
+		}
 
 		if (tu->reg_idx < TU_NUM_REGS)
 			tu->regs[tu->reg_idx] = *val;
@@ -129,6 +134,8 @@ static int i2c_slave_testunit_slave_cb(struct i2c_client *client,
 		 * here because we still need them in the workqueue!
 		 */
 		tu->reg_idx = 0;
+
+		clear_bit(TU_FLAG_NACK, &tu->flags);
 		break;
 
 	case I2C_SLAVE_READ_PROCESSED:
@@ -151,6 +158,10 @@ static int i2c_slave_testunit_slave_cb(struct i2c_client *client,
 		break;
 	}
 
+	/* If an error occurred somewhen, we NACK everything until next STOP */
+	if (ret)
+		set_bit(TU_FLAG_NACK, &tu->flags);
+
 	return ret;
 }
 
-- 
2.39.5



