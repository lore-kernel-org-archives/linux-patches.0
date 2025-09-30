Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409F17640E;
	Tue, 30 Sep 2025 15:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245344; cv=none; b=cOz9vY2h+r1DeGwpj0allANPh294m4q8wRPD523TK0PlasHaD4nXzMqStcLMNE18X++eVgAJJ/HCmTDRNwo5c9G/pXJ0NVYBPzlDpktzej3UuCKeW5LaOiWdwsLuiTO52++f6CHysVQsCk/5lZE46w3l95E1+IynYqtGnGeW5ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245344; c=relaxed/simple;
	bh=HweOL1REPrKFy1ACPY5OZCT21e7eG8/ERjo38Au5OFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqDccyiWI3nVYAciCpwvYt433gfJqgADR+Z50/y76NfWrv7mzVWo2dtFkH6hZGrjOJIxB8JeQbleoE5tznmxW6YUhksiPNC4x2DM88l3pPgExII2fbXOrXFyv8W1f97iDeYRSz1ZYCUUpGbJQ1LomlDYSVqgT1ga8ZUTBEbaRkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvSI5xe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvSI5xe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C4AC4CEF0;
	Tue, 30 Sep 2025 15:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245344;
	bh=HweOL1REPrKFy1ACPY5OZCT21e7eG8/ERjo38Au5OFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvSI5xe2O1yj0GVm3LHLLxGdMYmjiT7FEuMAnHx1CEXNKjFVw6+og82qsFaZMmZ4J
	 DXvjq5T7wQe5iM6bDPIX2wYyKwBwc7Exai4HWU3Xrw0eTH9qspvWxYXLCB7fUc2/Md
	 QqBZUpwFZPUUVbv9yCWk0s+ndNVxmM/Ty1GSfm04=
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
Subject: [PATCH 5.15 140/151] i40e: add max boundary check for VF filters
Date: Tue, 30 Sep 2025 16:47:50 +0200
Message-ID: <20250930143833.169775920@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3770,6 +3770,8 @@ err:
 				       aq_ret);
 }
 
+#define I40E_MAX_VF_CLOUD_FILTER 0xFF00
+
 /**
  * i40e_vc_add_cloud_filter
  * @vf: pointer to the VF info
@@ -3809,6 +3811,14 @@ static int i40e_vc_add_cloud_filter(stru
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
 	if (!cfilter)
 		return -ENOMEM;


