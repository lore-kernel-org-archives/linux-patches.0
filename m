Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAABC284678;
	Tue, 26 Aug 2025 11:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208749; cv=none; b=u+NziZsgB+15hl/2LhWWw+eXcgKZDTyMpHrLR00lPP7EhBY5FSff/L7knLiZmEdoisQ0LC7zV2cZIsRxvutoIvm/pXbvxrld4d7a/Dfx8k0kk/5vyIfAg2UZtS2Lt4NyFrtTPsN7gI7U4A+wZWIZ/D12XRDE/9ajskv+66UJl1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208749; c=relaxed/simple;
	bh=Py/Os3PvbtoZJ8T4WbFD8/UbR0zgruv8YbYEreRt6R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJNtBOLs3QwTKom58cQ55aWthkAJYDtCd3uxyVAyMpg/jRSQ/SPr4bC/VDYk4p2r0Z8kqsUR1Ale4ZbVWN1VpewU819SkBm5p2cxDJlR+/v6rkP+gtFYlj0527LNotVcmhxwDNXJVp1gniZFG2ZPU59RBZ1Zctq1KLoSizQG/u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wpNIXna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wpNIXna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083D3C4CEF1;
	Tue, 26 Aug 2025 11:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208749;
	bh=Py/Os3PvbtoZJ8T4WbFD8/UbR0zgruv8YbYEreRt6R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wpNIXnapS6Ia2kFVPhvO3vwoFfMRD4cqe+Lk6hiuvV2eE8AaBN+gbgF29e7gSf3R
	 H9kmfsrqTSjqNOINbXmxhvlRBAuE+Pjl8uz0GDaZfMDjQ3nLt9RKbHvONaA/V9eywC
	 tUbqn0K39nh+v7lxIuEuxA6GtmsO7cVhE/RtpZC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.12 230/322] usb: typec: maxim_contaminant: disable low power mode when reading comparator values
Date: Tue, 26 Aug 2025 13:10:45 +0200
Message-ID: <20250826110921.580039661@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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


