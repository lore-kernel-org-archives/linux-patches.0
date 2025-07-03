Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091232EAD1B;
	Thu,  3 Jul 2025 14:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554737; cv=none; b=AOU/UX3Ol/w8PWTzx2NexIt9Kqwwe/78o3GlzgaYM27DUcS2cdb3gDGo/aP9r5AcjOkDjCjafuJx727necV+3adn3PZr73C5fgxq2GkxP/3H2uxHGjvc/pLVWMg633aO7STNaZ0yqCM72HDU/u8+WJ5SEF3P96EbOoPJU4O8FWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554737; c=relaxed/simple;
	bh=13q2OSv3Zk8DDrCI6rvq950BybUQAhOBWnEHencwljs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Enh2ZJTDLb/YQ755KSO2MKnOo3zWYDLJ2zvvUgawtJjnPMAixrZKtPEEia3TIY0dA952zwnueX69RokrguHrLO8PwKPlFcVv5qPPv/2fKuXiu9DCyRYqYfD0coWYzAF+jt7a00hVNHy6STpr/fT7XHFLjJ9c8NUew8My1d3dyQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LC7VKq6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LC7VKq6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68974C4CEE3;
	Thu,  3 Jul 2025 14:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554736;
	bh=13q2OSv3Zk8DDrCI6rvq950BybUQAhOBWnEHencwljs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LC7VKq6dcL+QAnK9eraQ4QM/2zQhHvjpCji6CEzZsQfxxdbIgbdKzP+hwxRJj/KeJ
	 NMfyQCAgyiSE5z95OPWEO1Cero1FAcAU5dKvzuFBwFRG+IC8naZim+tGh97f8oBteh
	 q3eiIQPJi7N1rCohXYVJZVQXxCWfk6m+X2Qib3TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 032/263] wifi: iwlwifi: mld: Move regulatory domain initialization
Date: Thu,  3 Jul 2025 16:39:12 +0200
Message-ID: <20250703144005.583877886@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit f81aa834bfa91c827f290b62a245e23c5ad2813c ]

The regulatory domain information was initialized every time the
FW was loaded and the device was restarted. This was unnecessary
and useless as at this stage the wiphy channels information was
not setup yet so while the regulatory domain was set to the wiphy,
the channel information was not updated.

In case that a specific MCC was configured during FW initialization
then following updates with this MCC are ignored, and thus the
wiphy channels information is left with information not matching
the regulatory domain.

This commit moves the regulatory domain initialization to after the
operational firmware is started, i.e., after the wiphy channels were
configured and the regulatory information is needed.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250604061200.f138a7382093.I2fd8b3e99be13c2687da483e2cb1311ffb4fbfce@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/fw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/fw.c b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
index 4b083d447ee2f..6be9366bd4b14 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
@@ -339,10 +339,6 @@ int iwl_mld_load_fw(struct iwl_mld *mld)
 	if (ret)
 		goto err;
 
-	ret = iwl_mld_init_mcc(mld);
-	if (ret)
-		goto err;
-
 	mld->fw_status.running = true;
 
 	return 0;
@@ -535,6 +531,10 @@ int iwl_mld_start_fw(struct iwl_mld *mld)
 	if (ret)
 		goto error;
 
+	ret = iwl_mld_init_mcc(mld);
+	if (ret)
+		goto error;
+
 	return 0;
 
 error:
-- 
2.39.5



