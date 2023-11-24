Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2554139FC3;
	Fri, 24 Nov 2023 18:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsAz1+8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8396C433C8;
	Fri, 24 Nov 2023 18:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850264;
	bh=2mI1/mLRsfWcvFpBSjxxyiIkGMjXPgmR3ydhE8agFFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsAz1+8kzKSaGLtHYc31Eb0Nfnk00RVqJVMEJXCYZziBkr0vx/BFKxJhXTad4pIjq
	 RNzWeEOKFYcjFyvZvkzHnYX5gqOm6NeXeNHLGVQUsJvMDI/9VUULUXAFlQJNy54/Cc
	 NPxySxsvUalUI6TcWFFyXAcH/x+wnX3ijNLQzuyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 485/530] media: qcom: camss: Fix pm_domain_on sequence in probe
Date: Fri, 24 Nov 2023 17:50:51 +0000
Message-ID: <20231124172042.854543749@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 7405116519ad70b8c7340359bfac8db8279e7ce4 upstream.

We need to make sure camss_configure_pd() happens before
camss_register_entities() as the vfe_get() path relies on the pointer
provided by camss_configure_pd().

Fix the ordering sequence in probe to ensure the pointers vfe_get() demands
are present by the time camss_register_entities() runs.

In order to facilitate backporting to stable kernels I've moved the
configure_pd() call pretty early on the probe() function so that
irrespective of the existence of the old error handling jump labels this
patch should still apply to -next circa Aug 2023 to v5.13 inclusive.

Fixes: 2f6f8af67203 ("media: camss: Refactor VFE power domain toggling")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -1619,6 +1619,12 @@ static int camss_probe(struct platform_d
 	if (ret < 0)
 		goto err_cleanup;
 
+	ret = camss_configure_pd(camss);
+	if (ret < 0) {
+		dev_err(dev, "Failed to configure power domains: %d\n", ret);
+		goto err_cleanup;
+	}
+
 	ret = camss_init_subdevices(camss);
 	if (ret < 0)
 		goto err_cleanup;
@@ -1678,12 +1684,6 @@ static int camss_probe(struct platform_d
 		}
 	}
 
-	ret = camss_configure_pd(camss);
-	if (ret < 0) {
-		dev_err(dev, "Failed to configure power domains: %d\n", ret);
-		return ret;
-	}
-
 	pm_runtime_enable(dev);
 
 	return 0;


