Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB82DBA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B47C433D2;
	Tue,  7 Mar 2023 17:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211567;
	bh=JCnY6fWj1Mw4hH8m+25swBiBUQgvT7porpghlKP5510=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUhsZxIftrqU2Sr/g1lRhBh2MFtW7cSHCE7x+YTR+vgDKRNfgBJs5OZ4Sht1og8xi
	 FyRGps0nQzbizrT/XlZ+VADK46H5kUeKOqQO+nCiHt+47qWdlnNbhmMlBXFC7XtVZG
	 cZScEThA2jXbo1Ij7Wo9afbctgbLQn8FwumjuQCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.2 0905/1001] wifi: ath11k: allow system suspend to survive ath11k
Date: Tue,  7 Mar 2023 18:01:17 +0100
Message-Id: <20230307170101.294472510@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Len Brown <len.brown@intel.com>

commit 7c15430822e71e90203d87e6d0cfe83fa058b0dc upstream.

When ath11k runs into internal errors upon suspend,
it returns an error code to pci_pm_suspend, which
aborts the entire system suspend.

The driver should not abort system suspend, but should
keep its internal errors to itself, and allow the system
to suspend.  Otherwise, a user can suspend a laptop
by closing the lid and sealing it into a case, assuming
that is will suspend, rather than heating up and draining
the battery when in transit.

In practice, the ath11k device seems to have plenty of transient
errors, and subsequent suspend cycles after this failure
often succeed.

https://bugzilla.kernel.org/show_bug.cgi?id=216968

Fixes: d1b0c33850d29 ("ath11k: implement suspend for QCA6390 PCI devices")

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230201183201.14431-1-len.brown@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -979,7 +979,7 @@ static __maybe_unused int ath11k_pci_pm_
 	if (ret)
 		ath11k_warn(ab, "failed to suspend core: %d\n", ret);
 
-	return ret;
+	return 0;
 }
 
 static __maybe_unused int ath11k_pci_pm_resume(struct device *dev)


