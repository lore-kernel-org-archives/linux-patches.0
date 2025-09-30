Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3E1225D6;
	Tue, 30 Sep 2025 15:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246233; cv=none; b=CqTu/567+U+G8d2TJUKpgqoUk7yksBzSn5UcG5zlG9/B36wwtX2az3D7gx89pCnjwB0P7oRz+cd9I+4Mnkio9W1K5+989Xjf6t24I6dn6XAZ3y3DsIIzkz7TOYT1/wi7TslM3OmgyeuiAGx+6pX5XkqmRlIWgBq3Bh6gsOnwyhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246233; c=relaxed/simple;
	bh=QI1ByT3WAYVDUBYqD28eRMUFc/+L+04ZgkZ9/uytNos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYaMrM3uOymOqu+eF3bN/pk9wSBOTr3P5y9Oj7NqSGXCTbgBwkNUscrXPoXNAR4u3b4CtNGi+R+rBmGf/MIaI5NWjEPHNGKYZZHB8FWCimOH18YEQk7EWp2sd9auPLQwz4CVjGexPg4tD5viRDTXswDrBafDCzUCcX+yAnnK578=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDHHH1y6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDHHH1y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D88C4CEF0;
	Tue, 30 Sep 2025 15:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246233;
	bh=QI1ByT3WAYVDUBYqD28eRMUFc/+L+04ZgkZ9/uytNos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDHHH1y6+oonz93s/WsMB1p4R1AApHrl9XLwn4hJL0PBx6wXQl8yxVToUjPJ7cAUe
	 HIAjE07qrhCNPBjR9Qoj2p5Eh5ewhZxTIqgzifOvBqYLmqofVkEFhcHY5VwW7/JUf2
	 Sv8E9aex9m+uOo4W8V9NRBZZ/dlRMo18sX2mlE0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Czapnik <lukasz.czapnik@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.12 72/89] i40e: add max boundary check for VF filters
Date: Tue, 30 Sep 2025 16:48:26 +0200
Message-ID: <20250930143824.886866467@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

From: Lukasz Czapnik <lukasz.czapnik@intel.com>

commit cb79fa7118c150c3c76a327894bb2eb878c02619 upstream.

There is no check for max filters that VF can request. Add it.

Fixes: e284fc280473 ("i40e: Add and delete cloud filter")
Cc: stable@vger.kernel.org
Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3908,6 +3908,8 @@ err:
 				       aq_ret);
 }
 
+#define I40E_MAX_VF_CLOUD_FILTER 0xFF00
+
 /**
  * i40e_vc_add_cloud_filter
  * @vf: pointer to the VF info
@@ -3947,6 +3949,14 @@ static int i40e_vc_add_cloud_filter(stru
 		goto err_out;
 	}
 
+	if (vf->num_cloud_filters >= I40E_MAX_VF_CLOUD_FILTER) {
+		dev_warn(&pf->pdev->dev,
+			 "VF %d: Max number of filters reached, can't apply cloud filter\n",
+			 vf->vf_id);
+		aq_ret = -ENOSPC;
+		goto err_out;
+	}
+
 	cfilter = kzalloc(sizeof(*cfilter), GFP_KERNEL);
 	if (!cfilter) {
 		aq_ret = -ENOMEM;


