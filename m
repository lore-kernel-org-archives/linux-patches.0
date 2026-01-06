Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55C0366DA4;
	Tue,  6 Jan 2026 18:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722461; cv=none; b=ccFS2CItgFsVZS3HV8dN8W9zefyjVrOJwMvavcimxOKhWIc0sfH6esBwyGKnrdZ4qE+BYjVsKobzB0tKD6q2IiEdgcCeIINSKeOruqjUF7/oMlt92ktArzhrkvIOkMfnXLP0bbqJwDS7isiUISf60tp+RJFltNLfxjTv+5WgoPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722461; c=relaxed/simple;
	bh=bnXMXYLv+j9Y+vDckM0skJcSdKy980I4HzSFOAWEQ0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mzzg2h1Qa5FKGffAHMcOdSF5wtbUjw9/tkieBUvLUfTYX5i5nXy2kCrV4DiBzC74xS4Vvo8L9l9SWF+FsZZRzrNtZdA3K16jXO0iRqqlv0mvy61Qmq+29cLcUKrVdMz+1C9us+TlespgZSELf+q535g8J1PONdNyAgHruce+lBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQetIvYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQetIvYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13694C116C6;
	Tue,  6 Jan 2026 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722461;
	bh=bnXMXYLv+j9Y+vDckM0skJcSdKy980I4HzSFOAWEQ0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQetIvYNCOcBDcoSJyQIAc+kXCX94ED0ts30HNuq8///l4sbgFJR4CbcCBpXrYMMy
	 Vxvm5d/xZlTveHJEEo5Gs7ArRCeeRVVYQAEejfTd8oqSWVyJFRJeYRRZeoxkJ7/ZcE
	 //Lj5dgD9fYl7aKleFgxdG2e78AxqRms75y8EzC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 239/312] wifi: iwlwifi: Fix firmware version handling
Date: Tue,  6 Jan 2026 18:05:13 +0100
Message-ID: <20260106170556.497656558@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit ca5898222914f399797cea1aeb0ce77109ca2e62 upstream.

On my system the arithmetic done on the firmware numbers
results in a negative number, but since the types are
unsigned it gets interpreted as a large positive number.

The end result is that the firmware gets rejected and wifi
is defunct.

Switch to signed types to handle this case correctly.

iwlwifi 0000:0c:00.0: Driver unable to support your firmware API. Driver supports FW core 4294967294..2, firmware is 2.
iwlwifi 0000:0c:00.0: Direct firmware load for iwlwifi-5000-4.ucode failed with error -2
iwlwifi 0000:0c:00.0: Direct firmware load for iwlwifi-5000-3.ucode failed with error -2
iwlwifi 0000:0c:00.0: Direct firmware load for iwlwifi-5000-2.ucode failed with error -2
iwlwifi 0000:0c:00.0: Direct firmware load for iwlwifi-5000-1.ucode failed with error -2
iwlwifi 0000:0c:00.0: no suitable firmware found!
iwlwifi 0000:0c:00.0: minimum version required: iwlwifi-5000-1
iwlwifi 0000:0c:00.0: maximum version supported: iwlwifi-5000-5
iwlwifi 0000:0c:00.0: check git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

Cc: stable@vger.kernel.org
Fixes: 5f708cccde9d ("wifi: iwlwifi: add a new FW file numbering scheme")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220805
Link: https://patch.msgid.link/20251113222852.15896-1-ville.syrjala@linux.intel.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1599,7 +1599,7 @@ static void _iwl_op_mode_stop(struct iwl
  */
 static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 {
-	unsigned int min_core, max_core, loaded_core;
+	int min_core, max_core, loaded_core;
 	struct iwl_drv *drv = context;
 	struct iwl_fw *fw = &drv->fw;
 	const struct iwl_ucode_header *ucode;
@@ -1678,7 +1678,7 @@ static void iwl_req_fw_callback(const st
 	if (loaded_core < min_core || loaded_core > max_core) {
 		IWL_ERR(drv,
 			"Driver unable to support your firmware API. "
-			"Driver supports FW core %u..%u, firmware is %u.\n",
+			"Driver supports FW core %d..%d, firmware is %d.\n",
 			min_core, max_core, loaded_core);
 		goto try_again;
 	}


