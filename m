Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DDE271456;
	Mon, 17 Aug 2026 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979578; cv=none; b=GW62xpCQ1v9nFT0/2RZ21xEDMP6w5eU9mJBwWCMH15DrMFd4j1GC+1p44Dtqy4Xvf34fl92gJ+JL7qKZF7SaqNDOOlrby+kG6S6XDdpeqjmn9puXOmyOpdi7JPaiUGWXM4UY+SpFKtCGHV6Z9gjgluQP3S5h9ZViqRiMCtEDMhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979578; c=relaxed/simple;
	bh=5NWbOK4Gq79sUwuLEXfX1MRbyvLUFablG092imPAIjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1kwHayZ+WqgTlmZztmjAJqntDvhGvtp+2CwvtjSs3iW7PuUMpaSDKZKkUdzfVAsZsEI2M6a4xuIPOePy/FcgPBdgKhZF30kmI/PW9slksti8VDEABnd9KuCugkfMNlucwAFN3zuU2Y6jvNa/9c/hEWhlVBm083btcb0rvsgbVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsV3ngCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsV3ngCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA121F00A3D;
	Mon, 17 Aug 2026 15:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979577;
	bh=CpfD1uSjY6TtLyp6RVcOR+ikpaZpvAYu7WmZ0jvImbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MsV3ngCR7kS0FrINXd0Q+EZ0OsiHQiPSgdsQoK+LLOOtw9wLKJ/OylRPf+CgaDrQ5
	 DgatiVYVXpQWto85XoEkEEzamE/xPT1JKJS8j2XKQbp2ErYKttGfStGDMY8ZgXlTRa
	 a8BNXe8BySCkxH/gW5FxH9lJj9SeGmZzHexauQI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Temerkhanov <sergey.temerkhanov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.1 272/609] ice: use READ_ONCE() to access cached PHC time
Date: Mon, 17 Aug 2026 15:29:28 +0200
Message-ID: <20260817132553.233041945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Sergey Temerkhanov <sergey.temerkhanov@intel.com>

commit 2915681b89f817677ab9f1166d95b595bc144f5f upstream.

ptp.cached_phc_time is a 64-bit value updated by a periodic work item
on one CPU and read locklessly on another.  On 32-bit or non-atomic
architectures this can result in a torn read.  Use READ_ONCE() to
enforce a single atomic load.

Fixes: 77a781155a65 ("ice: enable receive hardware timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260717185340.3595286-9-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -595,7 +595,7 @@ static u64 ice_ptp_extend_40b_ts(struct
 		return 0;
 	}
 
-	return ice_ptp_extend_32b_ts(pf->ptp.cached_phc_time,
+	return ice_ptp_extend_32b_ts(READ_ONCE(pf->ptp.cached_phc_time),
 				     (in_tstamp >> 8) & mask);
 }
 


