Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E844A41C2EB;
	Tue, 10 Mar 2026 11:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142136; cv=none; b=DBAzv/3Py2m77QjAZl5UsKG7Tg5TWvoGFs1wc803zX+1jnTGLytkSBa0fhz87L/AUuwdBqiVXINCrrrhKvSqN3JNxDY++st37EFvWF/mGTiCpUNfwm+B3WWvqEq5POJ9j3ejUCKGgJyZvsF9KQqinKYln+Vl95NXY6Je7yZsUoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142136; c=relaxed/simple;
	bh=nbCblIHbUjK8RCPFyBQTZbbZl06he8wRDc6HKvqPjBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drsf3t3tF/Rdd2PZKyxLt61Jfo3pL4QoVPyb92IXmjK9KUEbqrdfrRvQtk8EIfK38W5f0U5JQJtI8AW9jDPxFeqyg4icGd8NNDSRslj+eAU1OqOzsd/OlzxVAgkfMGt/MPtJujnUO7kiOvRmUe07nwYjUf9tk0WfqnhZYAT8ZXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z60E79zC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z60E79zC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F645C2BC9E;
	Tue, 10 Mar 2026 11:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142135;
	bh=nbCblIHbUjK8RCPFyBQTZbbZl06he8wRDc6HKvqPjBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z60E79zCco9xQUFSFaKdgITCZMBnNkqiLOCRR0RiODr+enkMEyKOtws/SLfKBCj93
	 iIgGwA1gJ/PCbQdcSS6HYj3nbipxCLf12KonaWJoIwzLB7TX55gla9z7o4K/bm71x6
	 ypiu1SDiUYebONizSxa5JvU/QApZP7yf3odQlRqWNmNOAsw+9SlhAojtU6n4l1hfUz
	 PwM+k6vrPC0vKXBqMr5t2lkReUYnVQvpiXhhE7Cly0AdQAUChqAz13H5ojxIw3RyDf
	 vmivY/NbUt14m52nJxVESucOmcOTeSyaDbRrHchogNLWSj2kC0HBwzRnqeMg82PKnu
	 VA/XteSDoYJ+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 223/314] e1000e: clear DPG_EN after reset to avoid autonomous power-gating
Date: Tue, 10 Mar 2026 07:18:02 -0400
Message-ID: <11e56ea9668276f9f347559f3c709646ba3ee847.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

[ Upstream commit 0942fc6d324eb9c6b16187b2aa994c0823557f06 ]

Panther Lake systems introduced an autonomous power gating feature for
the integrated Gigabit Ethernet in shutdown state (S5) state. As part of
it, the reset value of DPG_EN bit was changed to 1. Clear this bit after
performing hardware reset to avoid errors such as Tx/Rx hangs, or packet
loss/corruption.

Fixes: 0c9183ce61bc ("e1000e: Add support for the next LOM generation")
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/defines.h | 1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/defines.h b/drivers/net/ethernet/intel/e1000e/defines.h
index ba331899d1861..d4a1041e456dc 100644
--- a/drivers/net/ethernet/intel/e1000e/defines.h
+++ b/drivers/net/ethernet/intel/e1000e/defines.h
@@ -33,6 +33,7 @@
 
 /* Extended Device Control */
 #define E1000_CTRL_EXT_LPCD  0x00000004     /* LCD Power Cycle Done */
+#define E1000_CTRL_EXT_DPG_EN	0x00000008 /* Dynamic Power Gating Enable */
 #define E1000_CTRL_EXT_SDP3_DATA 0x00000080 /* Value of SW Definable Pin 3 */
 #define E1000_CTRL_EXT_FORCE_SMBUS 0x00000800 /* Force SMBus mode */
 #define E1000_CTRL_EXT_EE_RST    0x00002000 /* Reinitialize from EEPROM */
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index df4e7d781cb1c..f9328caefe44b 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -4925,6 +4925,15 @@ static s32 e1000_reset_hw_ich8lan(struct e1000_hw *hw)
 	reg |= E1000_KABGTXD_BGSQLBIAS;
 	ew32(KABGTXD, reg);
 
+	/* The hardware reset value of the DPG_EN bit is 1.
+	 * Clear DPG_EN to prevent unexpected autonomous power gating.
+	 */
+	if (hw->mac.type >= e1000_pch_ptp) {
+		reg = er32(CTRL_EXT);
+		reg &= ~E1000_CTRL_EXT_DPG_EN;
+		ew32(CTRL_EXT, reg);
+	}
+
 	return 0;
 }
 
-- 
2.51.0

