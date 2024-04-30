Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FFB12C46B;
	Tue, 30 Apr 2024 10:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474047; cv=none; b=OvDWQNiH1B2kFnjCeod9+RHg/AdcU9HSI34xqjpqwUX2I103Hi26WCEmjeTUW2vcD5PAX4worm51Ekj/DBwBrGu3IpU+s2JhTggDYnnp8Gj84zz0tPM8tsj5T7U3T7wUDWo7VKWTxAX2enL0d9m9F08bCI8c0zeS8JI4zaSW4mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474047; c=relaxed/simple;
	bh=+ZbmwHrxWAmehqliXWvA9HmzQX4+R6gAGukuIOsL8gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9TD6frRtPowq3c3wgWywnupdODugw/2SAumiH8YgTbEKOSnnljuf7wMsHvarSTpI23MYG0d8RffYTaWIJZ70coDUPu2QBl3lb7dxUIQGfYGQuJsCVhcB7CUM01UVZ8H0TsQZv8PXLMurBqL4rYoJr7EF2t/BlcavQcsepoZQdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSPGM68w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSPGM68w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E75C2BBFC;
	Tue, 30 Apr 2024 10:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474047;
	bh=+ZbmwHrxWAmehqliXWvA9HmzQX4+R6gAGukuIOsL8gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSPGM68w4YTOTPyr6ftjWpRje1SuyuTAJ/Px4TZM/tS+2pNt88305AjAEUxxEwSWx
	 zi7d+lV/AIrAPEkaPh+TRudFLgWmIK2n3K5uNk8lTSpVboVF353sSMdJn56eNBq8vK
	 roIeL7bDAssBd0zekuLsiRiEUXYkR6OlRQs89tYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 043/228] wifi: iwlwifi: mvm: return uid from iwl_mvm_build_scan_cmd
Date: Tue, 30 Apr 2024 12:37:01 +0200
Message-ID: <20240430103105.056591367@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit bada85a3f584763deadd201147778c3e791d279c ]

This function is supposed to return a uid on success, and an errno in
failure.
But it currently returns the return value of the specific cmd version
handler, which in turn returns 0 on success and errno otherwise.
This means that on success, iwl_mvm_build_scan_cmd will return 0
regardless if the actual uid.
Fix this by returning the uid if the handler succeeded.

Fixes: 687db6ff5b70 ("iwlwifi: scan: make new scan req versioning flow")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://msgid.link/20240415114847.5e2d602b3190.I4c4931021be74a67a869384c8f8ee7463e0c7857@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 7b6f1cdca067e..97d44354dbbb5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2815,7 +2815,8 @@ static int iwl_mvm_build_scan_cmd(struct iwl_mvm *mvm,
 		if (ver_handler->version != scan_ver)
 			continue;
 
-		return ver_handler->handler(mvm, vif, params, type, uid);
+		err = ver_handler->handler(mvm, vif, params, type, uid);
+		return err ? : uid;
 	}
 
 	err = iwl_mvm_scan_umac(mvm, vif, params, type, uid);
-- 
2.43.0



