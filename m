Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0FC28C87C;
	Wed,  8 Apr 2026 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672126; cv=none; b=MXwTXQnfhhdXbWFkPawh8A57itATDj5y6m7xjiV5BB4x7Q0lQ1FxvWg3cNGeMPFcoRRRatCDyTdJkamTya9BTLn8gKFNetope+0z/ufOzAMd/Fs4/tjmEO4kYgSfdndKpR6F7bb65K9T5lqjdvVzoGcvlTm7tOAAn73MLqWvM9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672126; c=relaxed/simple;
	bh=8shrDCqomLkkUv3Dqw3rsP0i6qnOw0tZyXkImH7By1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfUm4oRmaCVxAbMiJuMeW2mgfFww+v0ylY8gS0S/i//UMWoBHvQnrKb719jumqmyeHt0nLqsyNzf9ePbLsw8HTO0g4h/dQnkp84DTugKD56H720xoZryRQAak4buAYlOo77+9Lwmd0tQKqXIs8F4B0s2R6qznRpqGFXxs6IvDHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGlg5JTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGlg5JTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215DEC2BC87;
	Wed,  8 Apr 2026 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672126;
	bh=8shrDCqomLkkUv3Dqw3rsP0i6qnOw0tZyXkImH7By1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGlg5JTNXKatEypm06LTYLy1sdHSodhk1q7u6lraXRhYslQAZerFSNCWyYByOU+Ur
	 /wZDtOf3iffqBLOUF1KuQHzdTUE3HqoGeQ86QLLXTsXRq9RcVyhOAa6fesbgZjKxAB
	 N2CAyqxL306rkB4yvJLZOjfl6i3j2YITo1QncKgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 200/312] wifi: iwlwifi: mvm: fix potential out-of-bounds read in iwl_mvm_nd_match_info_handler()
Date: Wed,  8 Apr 2026 20:01:57 +0200
Message-ID: <20260408175941.230448124@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2678,7 +2678,7 @@ static void iwl_mvm_nd_match_info_handle
 	if (IS_ERR_OR_NULL(vif))
 		return;
 
-	if (len < sizeof(struct iwl_scan_offload_match_info)) {
+	if (len < sizeof(struct iwl_scan_offload_match_info) + matches_len) {
 		IWL_ERR(mvm, "Invalid scan match info notification\n");
 		return;
 	}


