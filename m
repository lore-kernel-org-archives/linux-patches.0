Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873884D8CE;
	Tue, 30 Sep 2025 14:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243971; cv=none; b=qWxcmitefhaFJsbABG+wdOXz3Lzofz+4N+Kp+x6OilG3oJBCUZkJEJ6eOI3GUQCPCJN1VVpOPzVsgc9TcRiDkyE7sFQx2kItf5SHlBnHKz25evL5qShwEFu+oM8wqk6vEWcZ59rkRYe6l8KrIieyBYQOvBBBjiY/y2w05FomfL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243971; c=relaxed/simple;
	bh=SqSDhe/IncZyMKu/hO9YC+w6givzcOXtpylNCmGyXK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKY4lSqqC4Pby/KZaD2r5Uvl5Q6utE3Sp6r3H/uo28Aty6ncwFoVTSvrlFfDNf+GNyLATVr9R1dTTPxtEcy3gqVNTwhSu1l6KmiYw7jQPPsmx50rxiFqVgu/75GqZqnZd+351x8iHmAB9k9yA90bHVrLox8n8oaeNzSzk/LPCDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTMFcdtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTMFcdtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E887EC4CEF0;
	Tue, 30 Sep 2025 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243971;
	bh=SqSDhe/IncZyMKu/hO9YC+w6givzcOXtpylNCmGyXK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTMFcdtbfbODHak+KMjXJ8jUwXfMPp1rwLMLsfxM5zahR31RFSAML3jCzbhwdQ/+J
	 d6WV1GfXdm/zY0igVx5Bq7kRi9cwAmX9A01UCcX0GZbYf9B12k9zfQ6uE0f4YYDd7X
	 oopHMFSlhx4XIwBhJ2PDm2HQJ7nusxdOIu3ZUc8Y=
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
Subject: [PATCH 5.4 72/81] i40e: add max boundary check for VF filters
Date: Tue, 30 Sep 2025 16:47:14 +0200
Message-ID: <20250930143822.718441499@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3665,6 +3665,8 @@ err:
 				       aq_ret);
 }
 
+#define I40E_MAX_VF_CLOUD_FILTER 0xFF00
+
 /**
  * i40e_vc_add_cloud_filter
  * @vf: pointer to the VF info
@@ -3704,6 +3706,14 @@ static int i40e_vc_add_cloud_filter(stru
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


