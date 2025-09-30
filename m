Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C79C1EB5E3;
	Tue, 30 Sep 2025 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245537; cv=none; b=qO0V3uGB1yH4DtshL+YAEiecrAbKOOHszAvSfG1XXjrV88gNlBGud8bcLy0eCJHq2PH/RlxMWJrld2wgPFd8lLr8zpaiJTvkXryzii9dFQGSA6lv8NC2Cs0lumbIFUwYIUEjQ+58FXQpFqsCf1NY3tYlwOhySLamRgMGQ32lwO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245537; c=relaxed/simple;
	bh=c22Q9c5/bAQWP0crl7owqRlFTFqDSOnzpCw5q2b0xA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPxiO97L1hc/+XH8zS85LoX6hIS9jZPrNieQ0PA1z92ycjta8ydFRRBb4oG+r9dsg2+vcLt1cLxFG4HMRMWqGvZf1kLP8skjv+dyiwyl1kprCENgTtgUnhy1zRFWqK5TQ7AGtbt5e40Fgxna+1LaO1rWcp8cNxnS0/bBZHfX9zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4eaT4SQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4eaT4SQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BB1C4CEF0;
	Tue, 30 Sep 2025 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245537;
	bh=c22Q9c5/bAQWP0crl7owqRlFTFqDSOnzpCw5q2b0xA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4eaT4SQQT6IOxuoRw8sRy/CcdbrxMin18OtQIiq9elJDgrhX97402pwQlcD2uHo1
	 zO8L8s60gtLzoOFUSYPnO7KuI7u8Yjg6QWS8l1x+qpOO1vjcz+xCf0oIvhiQok1BV9
	 W7a6hLYD2XYuLlvpXtU5qxdygtM6BTMP7j55cduw=
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
Subject: [PATCH 6.1 47/73] i40e: fix input validation logic for action_meta
Date: Tue, 30 Sep 2025 16:47:51 +0200
Message-ID: <20250930143822.569327786@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

From: Lukasz Czapnik <lukasz.czapnik@intel.com>

commit 9739d5830497812b0bdeaee356ddefbe60830b88 upstream.

Fix condition to check 'greater or equal' to prevent OOB dereference.

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
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3525,7 +3525,7 @@ static int i40e_validate_cloud_filter(st
 
 	/* action_meta is TC number here to which the filter is applied */
 	if (!tc_filter->action_meta ||
-	    tc_filter->action_meta > vf->num_tc) {
+	    tc_filter->action_meta >= vf->num_tc) {
 		dev_info(&pf->pdev->dev, "VF %d: Invalid TC number %u\n",
 			 vf->vf_id, tc_filter->action_meta);
 		goto err;


