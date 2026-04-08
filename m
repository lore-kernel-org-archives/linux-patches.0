Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620A22BEFFF;
	Wed,  8 Apr 2026 18:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673855; cv=none; b=oLv5KQEvxqghr6Cw9I6SMJoUkAw0e4dybm8HcMLWPt2cSmdFPA/S5r2dUfsyNYOaMpYsCaOpvm/I4mrfeIfwSOeBH5UuGaY5WpA6eKr3Uo6lhdC0Cp+bXn0Ae1h8kiRTxXBF6HlWe0PpcCIhHJtRGIrKCmgAxHPk+pOsWeERvms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673855; c=relaxed/simple;
	bh=SNplQiqoSOcfYwe1S2YMv3WpOwJ5yiwgkGpvGDoXRHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omYbmt2KsSdMK4nMPO7owyisg3fBQPMICMY5uBMsRJI3CXWPuVYzZZK3S0optMyz83ZGRQqHNHoYHWJoJQIIWmswJ7AasFIGCH0XFlvdH2X0ppPA13jhVsV7b10/RHN2m0tdrFZyBjxjcYGJcS2DhlH0EOx/L9f2EXaDcGcYxac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7K97q2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7K97q2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC98DC2BC87;
	Wed,  8 Apr 2026 18:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673855;
	bh=SNplQiqoSOcfYwe1S2YMv3WpOwJ5yiwgkGpvGDoXRHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7K97q2crkI+gKjUNGORvGWgzqcRBd1e0r3nhWsijZ6XBCP/oADFG50u46M6EfRk2
	 72u5yWQq8cQdR6FYBTb9QONoqRkJS9j47M75n39ZG7xEUE4U1qvtVDi8B3Z9l6fa+9
	 n7tpIwzx0VYIxkdhyrp+s7lTyjKw6yU/iJw28MX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 116/242] wifi: iwlwifi: mvm: fix potential out-of-bounds read in iwl_mvm_nd_match_info_handler()
Date: Wed,  8 Apr 2026 20:02:36 +0200
Message-ID: <20260408175931.429955769@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3195,7 +3195,7 @@ static void iwl_mvm_nd_match_info_handle
 	if (IS_ERR_OR_NULL(vif))
 		return;
 
-	if (len < sizeof(struct iwl_scan_offload_match_info)) {
+	if (len < sizeof(struct iwl_scan_offload_match_info) + matches_len) {
 		IWL_ERR(mvm, "Invalid scan match info notification\n");
 		return;
 	}


