Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703452745E;
	Fri, 17 Oct 2025 15:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715759; cv=none; b=mtG6mfWdXRs6CP2TUjq98MHMLPGx5492UQyVQKETucDaYZL2GLWsObPxRlrRfKDzE9P8ExuxwL5Ybd/quBZbalRYJCZhhRxjXbUxddoBJOesge+CKFkYMxSn5WlsEW8gefh9GssmLocEuEOklZrB7KHKFXHynLDVoF2rnOmHcXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715759; c=relaxed/simple;
	bh=1qLApb7XZkZAW9zGjGYIOesdKwThh8uo1ZrE/udjfis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgQ0eq971ZBYjzH0vPDXhj4zCcRQzgaWTBzYF7hZTwognLqBxkdV/7Grk9IDMfKrqJqxDbpnGPXgWo/hz6Us5KR9nmQEzM4OzRdNA7xBOU40y4HxqxQNPdvZTyXWZcENMWYWZ6K20dliTdVlEQBKi796VilfBWnpwFu5ZRFDPs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwQmshfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwQmshfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02C9C4CEE7;
	Fri, 17 Oct 2025 15:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715759;
	bh=1qLApb7XZkZAW9zGjGYIOesdKwThh8uo1ZrE/udjfis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwQmshfzdo7Ootpo64J4bkI1HcejfcOoqAX61GXYO02dLylmghgeMa1wN8WoGDlF4
	 AZ1kqgygaCC+Ph/X/QpRa9UTu1Ogo38FGUb8ckrh5IuW/rNeSRKoRzXKBw7bHHK2WI
	 aLamnMu8MByf68T7jge5qC2ATZ9gRuTfEC36cXRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.17 327/371] media: iris: vpu3x: Add MNoC low power handshake during hardware power-off
Date: Fri, 17 Oct 2025 16:55:02 +0200
Message-ID: <20251017145213.906426724@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 93fad55aa996eef17a837ed95b1d621ef05d967b upstream.

Add the missing write to AON_WRAPPER_MVP_NOC_LPI_CONTROL before
reading the LPI status register. Introduce a handshake loop to ensure
MNoC enters low power mode reliably during VPU3 hardware power-off with
timeout handling.

Fixes: 02083a1e00ae ("media: platform: qcom/iris: add support for vpu33")
Cc: stable@vger.kernel.org
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_vpu3x.c | 32 +++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vpu3x.c b/drivers/media/platform/qcom/iris/iris_vpu3x.c
index 9b7c9a1495ee..bfc52eb04ed0 100644
--- a/drivers/media/platform/qcom/iris/iris_vpu3x.c
+++ b/drivers/media/platform/qcom/iris/iris_vpu3x.c
@@ -19,6 +19,9 @@
 #define WRAPPER_IRIS_CPU_NOC_LPI_CONTROL	(WRAPPER_BASE_OFFS + 0x5C)
 #define REQ_POWER_DOWN_PREP			BIT(0)
 #define WRAPPER_IRIS_CPU_NOC_LPI_STATUS		(WRAPPER_BASE_OFFS + 0x60)
+#define NOC_LPI_STATUS_DONE			BIT(0) /* Indicates the NOC handshake is complete */
+#define NOC_LPI_STATUS_DENY			BIT(1) /* Indicates the NOC handshake is denied */
+#define NOC_LPI_STATUS_ACTIVE		BIT(2) /* Indicates the NOC is active */
 #define WRAPPER_CORE_CLOCK_CONFIG		(WRAPPER_BASE_OFFS + 0x88)
 #define CORE_CLK_RUN				0x0
 
@@ -109,7 +112,9 @@ static void iris_vpu3_power_off_hardware(struct iris_core *core)
 
 static void iris_vpu33_power_off_hardware(struct iris_core *core)
 {
+	bool handshake_done = false, handshake_busy = false;
 	u32 reg_val = 0, value, i;
+	u32 count = 0;
 	int ret;
 
 	if (iris_vpu3x_hw_power_collapsed(core))
@@ -128,13 +133,36 @@ static void iris_vpu33_power_off_hardware(struct iris_core *core)
 			goto disable_power;
 	}
 
+	/* Retry up to 1000 times as recommended by hardware documentation */
+	do {
+		/* set MNoC to low power */
+		writel(REQ_POWER_DOWN_PREP, core->reg_base + AON_WRAPPER_MVP_NOC_LPI_CONTROL);
+
+		udelay(15);
+
+		value = readl(core->reg_base + AON_WRAPPER_MVP_NOC_LPI_STATUS);
+
+		handshake_done = value & NOC_LPI_STATUS_DONE;
+		handshake_busy = value & (NOC_LPI_STATUS_DENY | NOC_LPI_STATUS_ACTIVE);
+
+		if (handshake_done || !handshake_busy)
+			break;
+
+		writel(0, core->reg_base + AON_WRAPPER_MVP_NOC_LPI_CONTROL);
+
+		udelay(15);
+
+	} while (++count < 1000);
+
+	if (!handshake_done && handshake_busy)
+		dev_err(core->dev, "LPI handshake timeout\n");
+
 	ret = readl_poll_timeout(core->reg_base + AON_WRAPPER_MVP_NOC_LPI_STATUS,
 				 reg_val, reg_val & BIT(0), 200, 2000);
 	if (ret)
 		goto disable_power;
 
-	/* set MNoC to low power, set PD_NOC_QREQ (bit 0) */
-	writel(BIT(0), core->reg_base + AON_WRAPPER_MVP_NOC_LPI_CONTROL);
+	writel(0, core->reg_base + AON_WRAPPER_MVP_NOC_LPI_CONTROL);
 
 	writel(CORE_BRIDGE_SW_RESET | CORE_BRIDGE_HW_RESET_DISABLE,
 	       core->reg_base + CPU_CS_AHB_BRIDGE_SYNC_RESET);
-- 
2.51.0



