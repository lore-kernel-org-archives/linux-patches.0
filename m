Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F17846F;
	Tue, 30 Sep 2025 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244756; cv=none; b=jMEIaryVTLHznbM0HEHTCfatOKab/cmq9MLEngPC/Btsf1iJUBauthkSxu2FXGTaHcBOBZj+RIlACeTENiNhN3vnlYscA36lDBIHYZAJIeiET5rjsBtWQvYtpNrKIEDeFykOnEQs/2rWUR7jQRD22a6RZoyXjpCK46Me09xtmPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244756; c=relaxed/simple;
	bh=0lbF0n7wg0qYQ9YYWWXNyg4HieNxxIGn2vj2BhmgXYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fe6IvXAO+jSA4teLey5+Fmfs7gsiXLkMh/4qGFzjP1xZ7WQgSLG9A5YXu9Kv854SqKjz9EWuv/svOwxvCHhVuH1fOJ7Ita2vLmG+ME99b3KAkTKRlFmpEbhkxuS9bwx8/t3ex2szPDMSniOQfdRXFAp3zgXNh0xS2b5apHCv5ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ij7J5aYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ij7J5aYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF510C113D0;
	Tue, 30 Sep 2025 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244756;
	bh=0lbF0n7wg0qYQ9YYWWXNyg4HieNxxIGn2vj2BhmgXYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ij7J5aYgzKuBwZ6YiD/eq73/7Q6WmZ9rvG7jAy6/Ub0T0GIaL7VUIGr4iXgnuXa43
	 ZsEiDsspdE78VQ0X8eBmobCi+hJm1vI8uEGhRz7VFGm0SljHzlt46zjD25b1Tf/3z8
	 PqSs8Cjbr7om+X1p/nOljZnrPOgvORqU870Ayi7s=
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
Subject: [PATCH 6.16 105/143] i40e: fix input validation logic for action_meta
Date: Tue, 30 Sep 2025 16:47:09 +0200
Message-ID: <20250930143835.417812934@linuxfoundation.org>
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
@@ -3605,7 +3605,7 @@ static int i40e_validate_cloud_filter(st
 
 	/* action_meta is TC number here to which the filter is applied */
 	if (!tc_filter->action_meta ||
-	    tc_filter->action_meta > vf->num_tc) {
+	    tc_filter->action_meta >= vf->num_tc) {
 		dev_info(&pf->pdev->dev, "VF %d: Invalid TC number %u\n",
 			 vf->vf_id, tc_filter->action_meta);
 		goto err;


