Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE371E2602;
	Mon, 12 May 2025 17:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071862; cv=none; b=c7AWS8d6EstbmfAICgLPOQuijvr5E4PNvmdPomUq0+0/oVrZ0hUwnITSL5S/gaK7KswhWtjfi5nnsvVknsWVmK92bp11XPSCO0mo4nuIR8hCMiS7I4t8txru53B++6nb6QshWMzNJkd9nJ6IuUknttOtixRtl8JAUiLJq1UtY64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071862; c=relaxed/simple;
	bh=lgIKvho5X2H6bHL7NKc2VUXNICD55CVn+ZravJmaLU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJq33E/+tXkf7VKi3vYj+pMb8R9e19oZSewqiOuIT4OudPyFswXUdN+tEvmBm8AQ4l+RjAmvmSObbN6cuAYrgVNIRpgJkncUxPXp+KHL8himoG0gPt7IvZxBL6WVO5OQzLAGPICInCr3z0D3gIrBPFyxmjPrNPuv8W1Zc4PAqLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTVx3v6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTVx3v6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66D0C4CEE7;
	Mon, 12 May 2025 17:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071862;
	bh=lgIKvho5X2H6bHL7NKc2VUXNICD55CVn+ZravJmaLU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTVx3v6qaCnDPz3kQci/QMAUnRXMzjeiqlIQQIx2YejoUWoLb4/IfTUjSeWgGo+hj
	 OBg/4Pi/aoNZWVzXW1XVvRlktGzLmp7vsOOZBRFI0kevobOOpAWEtQ4D+xH0Xh4Wzg
	 gGAbIYA8VOK72MHOp/bhxUy1cBe4rbrzpuypxnXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikael Gonella-Bolduc <mgonellabolduc@dimonoff.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Alistair Francis <alistair@alistair23.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.14 055/197] Input: cyttsp5 - fix power control issue on wakeup
Date: Mon, 12 May 2025 19:38:25 +0200
Message-ID: <20250512172046.629176815@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikael Gonella-Bolduc <mgonellabolduc@dimonoff.com>

commit 7675b5efd81fe6d524e29d5a541f43201e98afa8 upstream.

The power control function ignores the "on" argument when setting the
report ID, and thus is always sending HID_POWER_SLEEP. This causes a
problem when trying to wakeup.

Fix by sending the state variable, which contains the proper HID_POWER_ON or
HID_POWER_SLEEP based on the "on" argument.

Fixes: 3c98b8dbdced ("Input: cyttsp5 - implement proper sleep and wakeup procedures")
Cc: stable@vger.kernel.org
Signed-off-by: Mikael Gonella-Bolduc <mgonellabolduc@dimonoff.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Link: https://lore.kernel.org/r/20250423135243.1261460-1-hugo@hugovil.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/cyttsp5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/cyttsp5.c
+++ b/drivers/input/touchscreen/cyttsp5.c
@@ -580,7 +580,7 @@ static int cyttsp5_power_control(struct
 	int rc;
 
 	SET_CMD_REPORT_TYPE(cmd[0], 0);
-	SET_CMD_REPORT_ID(cmd[0], HID_POWER_SLEEP);
+	SET_CMD_REPORT_ID(cmd[0], state);
 	SET_CMD_OPCODE(cmd[1], HID_CMD_SET_POWER);
 
 	rc = cyttsp5_write(ts, HID_COMMAND_REG, cmd, sizeof(cmd));


