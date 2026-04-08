Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC0728C87C;
	Wed,  8 Apr 2026 18:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673181; cv=none; b=kPJ2UWNgwkXXzo2lsUPHY3pke4xKkD1tJvCfQwErvYhTMVOpBzF/qNf2a9OebfFvECvbOUSFPYWNSa0vZSHC6hgakSW5r9/0tJ2UuhthTO58qxhrunBo4sFM96XZ0N4dgD0vYlQjbs6iCe2F36NPMMGD+sbSTiuUeomxUiB/zeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673181; c=relaxed/simple;
	bh=hVWpQdAFFsS7Rd/rQ+WFW84H9B7ddyti6whKlfLhnHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrOul54Jc1AFC4XWt/nPXl4tbSOk8CRdhsn9Wi5IKt3Y+HkgwspkNAqzAL+RRDEYTsvAzLeO/EmmCtL0K3XOmGJu5hn3oj7zr8JQWYOlaao2b1NvQQTYMgC58Tdb8Vpii0ovx8YByr/FyJ/M2sAtzP1aJAA4TJITxgc/pNbyXZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPd+36/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPd+36/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D6FC19421;
	Wed,  8 Apr 2026 18:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673181;
	bh=hVWpQdAFFsS7Rd/rQ+WFW84H9B7ddyti6whKlfLhnHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPd+36/T/fPYHjpLOB0+megJZXsffoD6iyO/uZvdK+1ii5I0dNSuRq5HPUDmXaVu1
	 mYldsDtvlFEBeA3nGXc7DRNVd+9hFo1q2qtfBs+HfkjpDe2q9eoU8s7Tegin9Tv0d/
	 US3rvA5jNiom494iXFfJ7zsnY0bNLkJ5CO9ZzyYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 132/277] wifi: iwlwifi: mvm: fix potential out-of-bounds read in iwl_mvm_nd_match_info_handler()
Date: Wed,  8 Apr 2026 20:01:57 +0200
Message-ID: <20260408175938.802853702@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

commit 744fabc338e87b95c4d1ff7c95bc8c0f834c6d99 upstream.

The memcpy function assumes the dynamic array notif->matches is at least
as large as the number of bytes to copy. Otherwise, results->matches may
contain unwanted data. To guarantee safety, extend the validation in one
of the checks to ensure sufficient packet length.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Cc: stable@vger.kernel.org
Fixes: 5ac54afd4d97 ("wifi: iwlwifi: mvm: Add handling for scan offload match info notification")
Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Link: https://patch.msgid.link/20260207150335.1013646-1-a.velichayshiy@ispras.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2834,7 +2834,7 @@ static void iwl_mvm_nd_match_info_handle
 	if (IS_ERR_OR_NULL(vif))
 		return;
 
-	if (len < sizeof(struct iwl_scan_offload_match_info)) {
+	if (len < sizeof(struct iwl_scan_offload_match_info) + matches_len) {
 		IWL_ERR(mvm, "Invalid scan match info notification\n");
 		return;
 	}


