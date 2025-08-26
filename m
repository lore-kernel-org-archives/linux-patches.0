Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC16345726;
	Tue, 26 Aug 2025 11:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207872; cv=none; b=O4vqV625JTCJsX2lX+4gJGSuhBq88RTOlDEJyqQ1oPoQeMBrdmUJkskuWjmcVJOMtNhUGJsUHg85R5cscK3u4rOEsj1kRljhC27MbinVthFH5+MYmP9IHJDEXBJ5AArKDeJL0kXuOo6EsfOOS6QVN2XbzGSDMehfu+/YHgtgzE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207872; c=relaxed/simple;
	bh=JvTQdVdIQwpOzKDKiQ8vaEPS2K7/EaB508a0oUix2zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6SYenaFyWseD3FIZUrmI2khEofcy+zMZO+U3PCtXEe+xjtyKDEGtg4rOQy+uKhX7FIFXT10Q7Jlwrg5kB90qaWk7zmFaAWiN/Mo3TIBnJmUt/08TbEgX75VoDUCc5wfzhKEJf1zG+wGv4sZCYO1IBVlJ7axXn6quH4SmompR34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFqnizCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFqnizCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D504C4CEF1;
	Tue, 26 Aug 2025 11:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207872;
	bh=JvTQdVdIQwpOzKDKiQ8vaEPS2K7/EaB508a0oUix2zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFqnizCIFw86C25AhQTS3fEaJ5l2/bvKgc+AF0XDLCJ4wjQBB87qVzN95YECIsApz
	 VJXf3BSRoq0SQgxSWmXf17LUqiM1HpsjNT702V7M3RDKlLPfRst4+JB0WD+2eup0dB
	 qHayoOTYCW8ycYLkHlkYry3KVP9c/Wbq2EUSRGUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.16 319/457] usb: typec: maxim_contaminant: disable low power mode when reading comparator values
Date: Tue, 26 Aug 2025 13:10:03 +0200
Message-ID: <20250826110945.236806977@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Amit Sunil Dhamne <amitsd@google.com>

commit cabb6c5f4d9e7f49bdf8c0a13c74bd93ee35f45a upstream.

Low power mode is enabled when reading CC resistance as part of
`max_contaminant_read_resistance_kohm()` and left in that state.
However, it's supposed to work with 1uA current source. To read CC
comparator values current source is changed to 80uA. This causes a storm
of CC interrupts as it (falsely) detects a potential contaminant. To
prevent this, disable low power mode current sourcing before reading
comparator values.

Fixes: 02b332a06397 ("usb: typec: maxim_contaminant: Implement check_contaminant callback")
Cc: stable <stable@kernel.org>
Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/stable/20250814-fix-upstream-contaminant-v1-1-801ce8089031%40google.com
Link: https://lore.kernel.org/r/20250815-fix-upstream-contaminant-v2-1-6c8d6c3adafb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/maxim_contaminant.c |    5 +++++
 drivers/usb/typec/tcpm/tcpci_maxim.h       |    1 +
 2 files changed, 6 insertions(+)

--- a/drivers/usb/typec/tcpm/maxim_contaminant.c
+++ b/drivers/usb/typec/tcpm/maxim_contaminant.c
@@ -188,6 +188,11 @@ static int max_contaminant_read_comparat
 	if (ret < 0)
 		return ret;
 
+	/* Disable low power mode */
+	ret = regmap_update_bits(regmap, TCPC_VENDOR_CC_CTRL2, CCLPMODESEL,
+				 FIELD_PREP(CCLPMODESEL,
+					    LOW_POWER_MODE_DISABLE));
+
 	/* Sleep to allow comparators settle */
 	usleep_range(5000, 6000);
 	ret = regmap_update_bits(regmap, TCPC_TCPC_CTRL, TCPC_TCPC_CTRL_ORIENTATION, PLUG_ORNT_CC1);
--- a/drivers/usb/typec/tcpm/tcpci_maxim.h
+++ b/drivers/usb/typec/tcpm/tcpci_maxim.h
@@ -21,6 +21,7 @@
 #define CCOVPDIS                                BIT(6)
 #define SBURPCTRL                               BIT(5)
 #define CCLPMODESEL                             GENMASK(4, 3)
+#define LOW_POWER_MODE_DISABLE                  0
 #define ULTRA_LOW_POWER_MODE                    1
 #define CCRPCTRL                                GENMASK(2, 0)
 #define UA_1_SRC                                1


