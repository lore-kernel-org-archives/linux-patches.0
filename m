Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EA1846F;
	Tue, 30 Sep 2025 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244765; cv=none; b=FCxN3LfZYOLugE2UoBc0SQ7GWMDuqQY3CiiH10AeVbFVKTvtIe4wi+iitgsrRivCUt5z6FaF1wFMcjDMtLZ/4wBwKxZsodjII5FYItIna+L8yiAHsofN3ZSbaH763wN3xNSu7wDvs93oJ9QvHOxpsOOozGksaaeBDOOsBqCRCH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244765; c=relaxed/simple;
	bh=/8gJ1YE9DZFzWi2fdL7R5ul1dEPx0z2iiKYmVU8J6tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vA41xdDCDIUZ5GQ4/XUJEzVY60NoTNoucSS9ngxGO4AOhCexmAE8TCkJEW7MEzQOFGbcO7zr+ejHd3NZ8eJX04R8Sl51FkLr+jnCyS31SLVPUbFEfBW9CcYee0rSsxZXfsVjJfzML6R6xJZfk11rPeBwjqPeRDLCJawxaXq+uoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvvuCE1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvvuCE1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22634C4CEF0;
	Tue, 30 Sep 2025 15:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244765;
	bh=/8gJ1YE9DZFzWi2fdL7R5ul1dEPx0z2iiKYmVU8J6tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvvuCE1FMoZ9NhqrCDo8BpJLODt7whU3Su6s+STSDmU5AV3HcF+69dFG+QqBH7Ohg
	 KyVW5cg/nBh/W0jHk+keQW5gyOuBJHqiPkjFUDGutvB2/ir5ps2hTnpMGvvJOwaT+e
	 a+frjL66lO20Y7cvRtoHr96fMPR9/gCqtGEjPcb4=
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
Subject: [PATCH 6.16 107/143] i40e: add max boundary check for VF filters
Date: Tue, 30 Sep 2025 16:47:11 +0200
Message-ID: <20250930143835.497094332@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


