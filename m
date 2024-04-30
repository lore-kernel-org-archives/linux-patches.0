Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606C512CDAE;
	Tue, 30 Apr 2024 11:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476409; cv=none; b=QyVFD8qsDTR6nIFqnwiUfcsleN/p4ntZ/RT1hSwmMMgpaxXSp3jt4++ETeAKOvPeT0sAWlFo1g6LTkRsBvQODjgmIiicKxedLpwNUaD9naA59lvws3FhHwmOTqjwQQlZ0AAzXjT6Bi6kCVlQwYawuCq+wlhB22/dKtpCzI2jtC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476409; c=relaxed/simple;
	bh=m8BHI10bUtVnXXK5hAd/q/GJ5iUf8fNLjWIeJNHp/U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0DC1Ydp2kUNcon4Mi+x5YD2wcO7N/uxILsJDaafciWuixZiLMxNkHVPXtVfLq/ZQYfxrvbfM7kE9AJy7AEwi+J8f9uNBlRQAC7GNwtObdIVuf3V5AeX0xkWmm15gfHqfrP3A8oox40nsIL89mPh8A/rvY2KLKiEFXif56gMxYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOAWOqM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOAWOqM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC8DC2BBFC;
	Tue, 30 Apr 2024 11:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476409;
	bh=m8BHI10bUtVnXXK5hAd/q/GJ5iUf8fNLjWIeJNHp/U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOAWOqM6CmGBtjQObEzZsB5jbVTuMX83rWlMyyjiyir5fUt4EPbq0hFPBIbOARXjB
	 674f9DpdX5JeWGyitMmpz9ZELLb53gXQDR8Wea5btqhyp7CejA0ZzQp1lhHwSYB+BE
	 geii6NzW3YPZt6yT/2pOqUDSgi+gBGesDnN2GDaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/110] wifi: iwlwifi: mvm: return uid from iwl_mvm_build_scan_cmd
Date: Tue, 30 Apr 2024 12:39:53 +0200
Message-ID: <20240430103048.283840608@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index acd8803dbcdd6..b20d64dbba1ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2650,7 +2650,8 @@ static int iwl_mvm_build_scan_cmd(struct iwl_mvm *mvm,
 		if (ver_handler->version != scan_ver)
 			continue;
 
-		return ver_handler->handler(mvm, vif, params, type, uid);
+		err = ver_handler->handler(mvm, vif, params, type, uid);
+		return err ? : uid;
 	}
 
 	err = iwl_mvm_scan_umac(mvm, vif, params, type, uid);
-- 
2.43.0



