Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2244503FD;
	Thu, 30 Jul 2026 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428011; cv=none; b=K954spPAdrdFAvOjSUHs0dMzOPTT7xNKCYIAu/Zci+uJ7r6dSN2oXhxDRKhzapb2L+jnGkW0Vs165vvlTY+DRpo4dxVYm0XqAgcX3QIF2JnS/FMmirtCqoS3ND28Q54PDfkY4c5/zomYhIxn7X6gpOsP2hKoolm/aqE4i3CGz2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428011; c=relaxed/simple;
	bh=vgEp3plvUfnX+kFmZ1Iwg7qEnBvB0DXuRHXiDx7BRf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWoie8kk/Sqn8+g7VDdcbTWwNgiVF0/gzy6+fQ1m/a5jPdByDHLuyFf0OlYEsip+LgkbZNIqvNolLw6M5MhFf3Nifraaz+IDRmaMlAJ1/bShsW8RlXpRp8p6JJ/MKGpl6ydtpPQJSVTwq+hPejzNcmvDyCUTi+MFfLQh56qWfic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5BhIMka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5BhIMka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8CA1F000E9;
	Thu, 30 Jul 2026 16:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428010;
	bh=A7wTXu3LwHvfF7jSijiX+NjDMuzkb16YcsCTICApcJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5BhIMkaTvvf+rEOPfQLlgGpFcrkReW1VXhMs2mmiOiIkojyrG7k+qb9qsT07mbgR
	 +p/gAoCHvQOmBbJMl7ASeT/QQppS6j49WxV0r+Wps0juGJWMFhKl+TaHuQuIQuJJzk
	 KH+KMzQioDSb7RbJFmD6LYNbxqqlGU4D2V3U6L54=
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
Subject: [PATCH 6.6 328/484] ice: use READ_ONCE() to access cached PHC time
Date: Thu, 30 Jul 2026 16:13:45 +0200
Message-ID: <20260730141430.611181189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


