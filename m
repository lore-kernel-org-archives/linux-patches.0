Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E486A352;
	Mon,  8 Apr 2024 13:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582767; cv=none; b=Pazj6fhq0UFUzGYbexcdsPeuU9EOrmoxUbW67zGmMqyJZO2h57IFcfO16KKUPwbuK+G3H5zsr4MuhZR1fe5UptTc9QbH5mKHOZwB59isyvHeL465DZucAQbZjUKv7YUJc/0ZTS1sRFX7r6VJKK7JrbtU1FGaMpJZf6Etf3p/u3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582767; c=relaxed/simple;
	bh=Koq+ZkmafyUriGD2fA6QV8lqfP0NLIVAAt2qWZkMQcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BR56WYMKEmCvI+h172HcppTmBQ6sfP2Ul3Kfls78sxnj6OBcrxIIauMywVkLybDm54kczQn8UhWjZrCL3gc2B4MzZqIevJg1SA2xKjKa3gcyZjisBibAawZnPOvAxu5cp9y2qPnFrnwVsmQlgMiAu9LZCABpCdSXlpSNxzLQcBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDS8Rgph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDS8Rgph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85322C433F1;
	Mon,  8 Apr 2024 13:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582766;
	bh=Koq+ZkmafyUriGD2fA6QV8lqfP0NLIVAAt2qWZkMQcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDS8RgphrdnipxyrJIVnub72N59TWvThI67mCqnwtdJZNPptAdmUhDN8mnKuMGrp5
	 XyhrbX+wr59zCDR5et1WD1uEDrPO9x1m5AyudL9Z9ByIdFQ58cp+17GUqM/GZNnoSo
	 rSeFKJjnHM3SgudKVnnLmHWlBrPSM8f+riiORZ9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 115/252] i40e: Fix VF MAC filter removal
Date: Mon,  8 Apr 2024 14:56:54 +0200
Message-ID: <20240408125310.203298420@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

commit ea2a1cfc3b2019bdea6324acd3c03606b60d71ad upstream.

Commit 73d9629e1c8c ("i40e: Do not allow untrusted VF to remove
administratively set MAC") fixed an issue where untrusted VF was
allowed to remove its own MAC address although this was assigned
administratively from PF. Unfortunately the introduced check
is wrong because it causes that MAC filters for other MAC addresses
including multi-cast ones are not removed.

<snip>
	if (ether_addr_equal(addr, vf->default_lan_addr.addr) &&
	    i40e_can_vf_change_mac(vf))
		was_unimac_deleted = true;
	else
		continue;

	if (i40e_del_mac_filter(vsi, al->list[i].addr)) {
	...
</snip>

The else path with `continue` effectively skips any MAC filter
removal except one for primary MAC addr when VF is allowed to do so.
Fix the check condition so the `continue` is only done for primary
MAC address.

Fixes: 73d9629e1c8c ("i40e: Do not allow untrusted VF to remove administratively set MAC")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20240329180638.211412-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3143,11 +3143,12 @@ static int i40e_vc_del_mac_addr_msg(stru
 		/* Allow to delete VF primary MAC only if it was not set
 		 * administratively by PF or if VF is trusted.
 		 */
-		if (ether_addr_equal(addr, vf->default_lan_addr.addr) &&
-		    i40e_can_vf_change_mac(vf))
-			was_unimac_deleted = true;
-		else
-			continue;
+		if (ether_addr_equal(addr, vf->default_lan_addr.addr)) {
+			if (i40e_can_vf_change_mac(vf))
+				was_unimac_deleted = true;
+			else
+				continue;
+		}
 
 		if (i40e_del_mac_filter(vsi, al->list[i].addr)) {
 			ret = -EINVAL;


