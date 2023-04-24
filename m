Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267CF7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA58C433D2;
	Mon, 24 Apr 2023 13:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342635;
	bh=6bYd56gFgqhBFHTxN4I3UCZaFYDekYt3rvtdM2BkHZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ed0fa+pGVuloP3qPrr5IUZ8tqwrcSX5Akh2xLkvckERvADGta0sCZHpvpfRpdefAr
	 KhgbS5eWPyMDl9zon+rDNgRTInD3oXAo/N+w7vTifkbjAGJ569xYz3GC1Hz22XNO1a
	 7gtXMJJ33vYbyyelyXcMGdrXrUSiMZjnlhc3iVBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.4 09/39] i40e: fix i40e_setup_misc_vector() error handling
Date: Mon, 24 Apr 2023 15:17:12 +0200
Message-Id: <20230424131123.403801884@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
References: <20230424131123.040556994@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit c86c00c6935505929cc9adb29ddb85e48c71f828 ]

Add error handling of i40e_setup_misc_vector() in i40e_rebuild().
In case interrupt vectors setup fails do not re-open vsi-s and
do not bring up vf-s, we have no interrupts to serve a traffic
anyway.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index c5edee873ba54..351d4c53297f5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10336,8 +10336,11 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 					     pf->hw.aq.asq_last_status));
 	}
 	/* reinit the misc interrupt */
-	if (pf->flags & I40E_FLAG_MSIX_ENABLED)
+	if (pf->flags & I40E_FLAG_MSIX_ENABLED) {
 		ret = i40e_setup_misc_vector(pf);
+		if (ret)
+			goto end_unlock;
+	}
 
 	/* Add a filter to drop all Flow control frames from any VSI from being
 	 * transmitted. By doing so we stop a malicious VF from sending out
-- 
2.39.2



