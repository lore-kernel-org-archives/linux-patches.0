Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA2B646;
	Wed,  6 Nov 2024 13:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899304; cv=none; b=hI6Vkfv63GehnSU0xei6pmJf8tD9Qprtgjb/nwl5pETs/wwQ0xyfiyJTQpl7ad4gmVJQrxuLTmX1dBpiU97taa+emzyW1cqpg6yAmER0ri2s4lOhU36UVDZq56WVSdA+AFJLfohqjAujA9l4xzEf7gGeCspUH3qglluWj4q4dlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899304; c=relaxed/simple;
	bh=4jVwr+idCqd82PMwoTMPSs/C9hJ4LATunhytU4b7/H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/gp4f5/OGR8/urYd1c8InmWVregYkMKNMokJjsG5QLoERq40JucP7AfcTxwQ2fzgsEWwtdE6AmekqIU6NoPds0uQhBxnHgGPX/e92l2W6mZnef7HlePFZj1s+HECaPenZbDtOOhXSqgrg9sQfDczBaNM+tZ1b0O8gwMNv99OrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AP8RRQKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AP8RRQKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EF1C4CED4;
	Wed,  6 Nov 2024 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899303;
	bh=4jVwr+idCqd82PMwoTMPSs/C9hJ4LATunhytU4b7/H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AP8RRQKCOhWPzOuzgEQeDt89Tc9NBK94a4r1y+jZAkdYenkbyh67nUhGMBW8ZNooo
	 Cvy4ZSnAKmtSzdHAM+4GRB/L4bkVaUE+HWfoHeCP+6hEKSc6loBwulR1rr8cN+IoVl
	 l2Rtcv9bUpPm/2tu+64whKlhuaZo6yocgkw91QQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 68/73] wifi: iwlwifi: mvm: fix 6 GHz scan construction
Date: Wed,  6 Nov 2024 13:06:12 +0100
Message-ID: <20241106120301.977624063@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 7245012f0f496162dd95d888ed2ceb5a35170f1a upstream.

If more than 255 colocated APs exist for the set of all
APs found during 2.4/5 GHz scanning, then the 6 GHz scan
construction will loop forever since the loop variable
has type u8, which can never reach the number found when
that's bigger than 255, and is stored in a u32 variable.
Also move it into the loops to have a smaller scope.

Using a u32 there is fine, we limit the number of APs in
the scan list and each has a limit on the number of RNR
entries due to the frame size. With a limit of 1000 scan
results, a frame size upper bound of 4096 (really it's
more like ~2300) and a TBTT entry size of at least 11,
we get an upper bound for the number of ~372k, well in
the bounds of a u32.

Cc: stable@vger.kernel.org
Fixes: eae94cf82d74 ("iwlwifi: mvm: add support for 6GHz")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219375
Link: https://patch.msgid.link/20241023091744.f4baed5c08a1.I8b417148bbc8c5d11c101e1b8f5bf372e17bf2a7@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1753,7 +1753,8 @@ iwl_mvm_umac_scan_cfg_channels_v6_6g(str
 			&cp->channel_config[i];
 
 		u32 s_ssid_bitmap = 0, bssid_bitmap = 0, flags = 0;
-		u8 j, k, s_max = 0, b_max = 0, n_used_bssid_entries;
+		u8 k, s_max = 0, b_max = 0, n_used_bssid_entries;
+		u32 j;
 		bool force_passive, found = false, allow_passive = true,
 		     unsolicited_probe_on_chan = false, psc_no_listen = false;
 


