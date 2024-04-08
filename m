Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5825778285;
	Mon,  8 Apr 2024 13:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582860; cv=none; b=dc2oKcllF/+rfGmiGGPfP2HrHxQNwjBOV/9wTKUtmIlasFZooqIwtfrcmd57lHwcQ/bWvKoRrWTmFoHYSqMuHrPon8TxlqyqlqaWhOyM66PyFX833fyu17700JwRK4gQfBpuKI4LuCOXPAJpr1m7RHO3GztLeP0dlkPViW8LlRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582860; c=relaxed/simple;
	bh=WJyeYpIES6JtQFOTvTXutyRm4jcTq+PD3PgTtyHlhA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM7qlWCZnSit3yznAl/lSdpIoRbEOjZodpsEwP0tSlZqbV949qMqr4DE0hDjBlT8Mcm5jvGLzxAMz3lIGSM6yjcpdGuSxX1h20IV+BtHBiZ7Wg4qKoi11qXZlanZHLXHac0KJ5vA8jb2QZrX0rK1trBDqoFnxTb3ol3oyVpzpB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/6N03Md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/6N03Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2262C433C7;
	Mon,  8 Apr 2024 13:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582860;
	bh=WJyeYpIES6JtQFOTvTXutyRm4jcTq+PD3PgTtyHlhA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/6N03MdCDb1tPyknxwKvkbLliaNvgXYZ4wKbq+pak7WsEofyTa8ci0XhaJeb8ZFq
	 rmnb9asMRv4zDsGENwAQZ3tNVoibs10SoQehkV3He+ymI8v+AcW0Cbvd8BCGxen3Xx
	 IjYYVHQJALvwYaQUAZ+4nP8oQDB9aFQBKBXLm1qE=
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
Subject: [PATCH 6.8 111/273] i40e: Fix VF MAC filter removal
Date: Mon,  8 Apr 2024 14:56:26 +0200
Message-ID: <20240408125312.748746262@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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


