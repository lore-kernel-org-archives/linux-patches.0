Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A129917CA12;
	Mon, 10 Mar 2025 17:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629043; cv=none; b=n7hWy4TUEuFpWVcxj1DwzC25jD/mJZUkyiegZCIUK/R8WrnC5vn6tlFQ+LF1NVOs9fAqxr/Rt6J3roG7EnlhROwqkMBRr75KOtKvxtcwto4d0zm7BexiCDlmFBFukeaJwiu/ca/HcqZ5B8edmRAZZM+gK0sNOjPXd0TLzsyvWpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629043; c=relaxed/simple;
	bh=Pg7FaBPJR8sUzYnJsJgeN6Fmw80tOusAqc2LmjmQYYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOWN+wdr9ULu/gC1Owwnn4mHOQnm2/wE5aV5dgwlW2bO9s36gh+mq1X4xp1dCIQX0M3uLl6J/epsZ5ClC9UyAFxFJSo6n88QCS/qjTG5X2+KUpHvFSEBHDTIX+yxA9QOGIi4iV3JusfeU7gM6yw8DWDcctLGKbQcugpk5Jxchl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0kdM5u2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0kdM5u2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACC3C4CEE5;
	Mon, 10 Mar 2025 17:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629043;
	bh=Pg7FaBPJR8sUzYnJsJgeN6Fmw80tOusAqc2LmjmQYYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0kdM5u2lUPI6TSf8+w92//W4h5WWk1o5/TcPCqCRhXXlC2SNMhzg7AZV2Et3i6C1
	 13MnuHQhVJf4stUKzRWdZzXi3M9rHHFeiipuRjIaQe12HXQCSbIACQB0Npw5r6Eqf2
	 xLemvhRGLBDdIOdxZsrfqlw0MbVoUyDTA7K0ZkH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/620] dmaengine: ti: edma: fix OF node reference leaks in edma_driver
Date: Mon, 10 Mar 2025 18:00:04 +0100
Message-ID: <20250310170551.850369088@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit e883c64778e5a9905fce955681f8ee38c7197e0f ]

The .probe() of edma_driver calls of_parse_phandle_with_fixed_args() but
does not release the obtained OF nodes. Thus add a of_node_put() call.

This bug was found by an experimental verification tool that I am
developing.

Fixes: 1be5336bc7ba ("dmaengine: edma: New device tree binding")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20241219020507.1983124-3-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/edma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index 69292d4a0c441..560fe658b8942 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -217,7 +217,6 @@ struct edma_desc {
 struct edma_cc;
 
 struct edma_tc {
-	struct device_node		*node;
 	u16				id;
 };
 
@@ -2524,13 +2523,13 @@ static int edma_probe(struct platform_device *pdev)
 			if (ret || i == ecc->num_tc)
 				break;
 
-			ecc->tc_list[i].node = tc_args.np;
 			ecc->tc_list[i].id = i;
 			queue_priority_mapping[i][1] = tc_args.args[0];
 			if (queue_priority_mapping[i][1] > lowest_priority) {
 				lowest_priority = queue_priority_mapping[i][1];
 				info->default_queue = i;
 			}
+			of_node_put(tc_args.np);
 		}
 
 		/* See if we have optional dma-channel-mask array */
-- 
2.39.5



