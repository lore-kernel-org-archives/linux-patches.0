Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4E12590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1093C433EF;
	Sun, 22 Jan 2023 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400810;
	bh=ARtUTEYeEcVa1SzE6l1zpfZXyO+7TnKvetts8Ouv/s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujPpXydfAtN/wqP0ay3FaIWkIbeNcw6d97UJRomM0Gt3nE14KGl40IsytEk04mQR9
	 +2082swYU13+GAwEMwccwrS+dNVaCrha5wWLL7XmBTDsYdVUv6tDjCWN8M55vv97IM
	 B/VCHI1PFCmPlxGkG9hg0tXcRXZPzvnDF1utuGao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 117/117] soc: qcom: apr: Make qcom,protection-domain optional again
Date: Sun, 22 Jan 2023 16:05:07 +0100
Message-Id: <20230122150237.697046756@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stephan Gerhold <stephan@gerhold.net>

commit 599d41fb8ea8bd2a99ca9525dd69405020e43dda upstream.

APR should not fail if the service device tree node does not have
the qcom,protection-domain property, since this functionality does
not exist on older platforms such as MSM8916 and MSM8996.

Ignore -EINVAL (returned when the property does not exist) to fix
a regression on 6.2-rc1 that prevents audio from working:

  qcom,apr remoteproc0:smd-edge.apr_audio_svc.-1.-1:
    Failed to read second value of qcom,protection-domain
  qcom,apr remoteproc0:smd-edge.apr_audio_svc.-1.-1:
    Failed to add apr 3 svc

Fixes: 6d7860f5750d ("soc: qcom: apr: Add check for idr_alloc and of_property_read_string_index")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221229151648.19839-3-stephan@gerhold.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/apr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -317,9 +317,10 @@ static int apr_add_device(struct device
 		goto out;
 	}
 
+	/* Protection domain is optional, it does not exist on older platforms */
 	ret = of_property_read_string_index(np, "qcom,protection-domain",
 					    1, &adev->service_path);
-	if (ret < 0) {
+	if (ret < 0 && ret != -EINVAL) {
 		dev_err(dev, "Failed to read second value of qcom,protection-domain\n");
 		goto out;
 	}


