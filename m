Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE0F143899;
	Thu, 13 Jun 2024 11:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279269; cv=none; b=KPDdogDBKeyLvQ8QkuZ73201u1ZTyjFzniJCtHnCbFPqASTj/uaJ/ivjsFVZI6Qk5Z1/eNnwrFyjvTkRvCVdhXTCrrTPaI+5YD3PNq+ycVbLibM7JqQvqA9f9SLdvHtHe8uSUlBasloK4IPK2lQTWM9tXUA8eCRnMvIpTbN+gQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279269; c=relaxed/simple;
	bh=xUFNT0HHfTvGPsmkp9t4yKHQEnnyj/3hvqM+SgooA44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkqcHBQH6IJY5kqilQZI9HAvqUXrTEQVAvT+aQ/6iOv3kcN5xu8f9h/pojuVpZyNi5GOcwIKdxLWt09Ib6BXyqQsLYp+bRU3fOIGU5fe3vmzWOGGtIQOWxSBh/Ok0ZJzcMfXBx8K64/QJv1F1l/OhPVSGvY83rEEqgiLpIlVrK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKkLjlyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKkLjlyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D744DC2BBFC;
	Thu, 13 Jun 2024 11:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279269;
	bh=xUFNT0HHfTvGPsmkp9t4yKHQEnnyj/3hvqM+SgooA44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKkLjlylhaKKFsDHH23wgI7mqAGOB1cNcvhx8OAnbug6UNES8BwZ7ilS8sP/EBBXz
	 v+St5iSir4vS7wbTNdtSSC148pSkAOeGzsw0Ek8+ahObQGtEYK3Ij2L0jyhnNlDv/G
	 8pbdh6j8NOeBv1QyGEOA48orVO2s8fN4qzh1TOnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.9 019/157] thermal/drivers/qcom/lmh: Check for SCM availability at probe
Date: Thu, 13 Jun 2024 13:32:24 +0200
Message-ID: <20240613113228.150118490@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit d9d3490c48df572edefc0b64655259eefdcbb9be upstream.

Up until now, the necessary scm availability check has not been
performed, leading to possible null pointer dereferences (which did
happen for me on RB1).

Fix that.

Fixes: 53bca371cdf7 ("thermal/drivers/qcom: Add support for LMh driver")
Cc: <stable@vger.kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240308-topic-rb1_lmh-v2-2-bac3914b0fe3@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/qcom/lmh.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/thermal/qcom/lmh.c
+++ b/drivers/thermal/qcom/lmh.c
@@ -95,6 +95,9 @@ static int lmh_probe(struct platform_dev
 	unsigned int enable_alg;
 	u32 node_id;
 
+	if (!qcom_scm_is_available())
+		return -EPROBE_DEFER;
+
 	lmh_data = devm_kzalloc(dev, sizeof(*lmh_data), GFP_KERNEL);
 	if (!lmh_data)
 		return -ENOMEM;


