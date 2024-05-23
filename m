Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70421E4B0;
	Thu, 23 May 2024 13:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470228; cv=none; b=CaJy/h42xx8Fmvnp51Yqa/aemQiuvyvEE4yDJUb3mpAGPg/xJ3pN7JKP9kaq0jHwzmgccHohbCWklR8hp+GT7xFa3NcLzChAPiN5ysliuPBSGfmLQxIkJjhXmKNqG9yrSRAniQUYFM8CI57V1ZTSSQ6gpdbzIUGZTDXq/eTeFEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470228; c=relaxed/simple;
	bh=aGhlp3JAedDgKRd6I0Tf5VtIpwB5f7S2rzEXI08umLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEPRt6tNnT+7bzIl79otpidSr3+o87QzlCSxQSCcoo4n73bYUp5W5hcDI62dVNEkOZFVR3+y/DuxU2pNzsotxEsR92S37fDGHwwcn2idI0PAifWtWnvgQRFQWgpv0BpTnZvGuRlAXH+Xecs78p9kL+kOOitGJKwk45amBZA6iig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToQSh2Ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToQSh2Ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E38C2BD10;
	Thu, 23 May 2024 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470228;
	bh=aGhlp3JAedDgKRd6I0Tf5VtIpwB5f7S2rzEXI08umLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToQSh2TyrWN6W1Bj71oBIPfZ8fSPrCKJzaLubKQEmPC6aI/LXyyNHQKwPDWShpxBk
	 0PhzWVt5McsqX8ODzsy3nq8j601w7Kt+MVH0QEMv8R28JvoJSptVAQVJ2RPVVUagD0
	 zPhZ6a24aoFGax3Vusjozs9ZrMuVXSUn6vmvV++4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.9 02/25] wifi: iwlwifi: Use request_module_nowait
Date: Thu, 23 May 2024 15:12:47 +0200
Message-ID: <20240523130330.480126336@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Greear <greearb@candelatech.com>

commit 3d913719df14c28c4d3819e7e6d150760222bda4 upstream.

This appears to work around a deadlock regression that came in
with the LED merge in 6.9.

The deadlock happens on my system with 24 iwlwifi radios, so maybe
it something like all worker threads are busy and some work that needs
to complete cannot complete.

Link: https://lore.kernel.org/linux-kernel/20240411070718.GD6194@google.com/
Fixes: f5c31bcf604d ("Merge tag 'leds-next-6.9' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/leds")
Signed-off-by: Ben Greear <greearb@candelatech.com>
Link: https://msgid.link/20240430234212.2132958-1-greearb@candelatech.com
[also remove unnecessary "load_module" var and now-wrong comment]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1484,7 +1484,6 @@ static void iwl_req_fw_callback(const st
 	size_t trigger_tlv_sz[FW_DBG_TRIGGER_MAX];
 	u32 api_ver;
 	int i;
-	bool load_module = false;
 	bool usniffer_images = false;
 	bool failure = true;
 
@@ -1732,19 +1731,12 @@ static void iwl_req_fw_callback(const st
 			goto out_unbind;
 		}
 	} else {
-		load_module = true;
+		request_module_nowait("%s", op->name);
 	}
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
 	complete(&drv->request_firmware_complete);
 
-	/*
-	 * Load the module last so we don't block anything
-	 * else from proceeding if the module fails to load
-	 * or hangs loading.
-	 */
-	if (load_module)
-		request_module("%s", op->name);
 	failure = false;
 	goto free;
 


