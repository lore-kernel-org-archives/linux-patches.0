Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF911AE01F;
	Mon, 14 Oct 2024 15:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919369; cv=none; b=A3ofJqsKIBWotckTlJjqC9Z+Y9tRpNfhNYb4xeypAouNnYg2SIjt7QdxrIgA/Bfpq3BRV+wnOzyYldqb80qCUAdmFqy2ZDmLmvoXzdp7q6MInypvIUjTP0lqyOX3EFCVYACZRnbUrjWBrcfcb/esekc/fZRtdNbL32EZ6/Ato3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919369; c=relaxed/simple;
	bh=ZvVBEv7IfVFRkln5l440PrnOaeDCmAUBpEQqmqptSaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEGzjw+NY9gz9u0PSbzDxaKXMA+armYMRqBykpK4S5cgV7/TLtClt5fRioOAoUrM1NOLurV8x0ide9MDDFfE4Re2o95MyIJDWxv8UdR1qUNorc7SRkw4FZyqlRcnlP51Uuu0O9DiYvAF5CqXdBlFS8tf2/KV3WnRrXHq6NH5JNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiCY4xvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiCY4xvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03720C4CED2;
	Mon, 14 Oct 2024 15:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919368;
	bh=ZvVBEv7IfVFRkln5l440PrnOaeDCmAUBpEQqmqptSaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiCY4xvzRueTi/5I4975MmfNrnESqkj8VqDHZVM2wqODPE+rVKr7ZYRgS4Bsaxej0
	 ZGcR9ZqsJHI/PAmhr0yVB1IdsoKMFkTRdR10MCQgnev4PtFyIAaUtSXcxsd8A4sg9f
	 3ympSsQAa3TgYhfnuiLrOJJT7bD6ymS/AWBSypks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 590/798] media: qcom: camss: Fix ordering of pm_runtime_enable
Date: Mon, 14 Oct 2024 16:19:04 +0200
Message-ID: <20241014141241.184296256@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit a151766bd3688f6803e706c6433a7c8d3c6a6a94 upstream.

pm_runtime_enable() should happen prior to vfe_get() since vfe_get() calls
pm_runtime_resume_and_get().

This is a basic race condition that doesn't show up for most users so is
not widely reported. If you blacklist qcom-camss in modules.d and then
subsequently modprobe the module post-boot it is possible to reliably show
this error up.

The kernel log for this error looks like this:

qcom-camss ac5a000.camss: Failed to power up pipeline: -13

Fixes: 02afa816dbbf ("media: camss: Add basic runtime PM support")
Reported-by: Johan Hovold <johan+linaro@kernel.org>
Closes: https://lore.kernel.org/lkml/ZoVNHOTI0PKMNt4_@hovoldconsulting.com/
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -1663,6 +1663,8 @@ static int camss_probe(struct platform_d
 
 	v4l2_async_nf_init(&camss->notifier);
 
+	pm_runtime_enable(dev);
+
 	num_subdevs = camss_of_parse_ports(camss);
 	if (num_subdevs < 0) {
 		ret = num_subdevs;
@@ -1700,8 +1702,6 @@ static int camss_probe(struct platform_d
 		}
 	}
 
-	pm_runtime_enable(dev);
-
 	return 0;
 
 err_register_subdevs:
@@ -1709,6 +1709,7 @@ err_register_subdevs:
 err_v4l2_device_unregister:
 	v4l2_device_unregister(&camss->v4l2_dev);
 	v4l2_async_nf_cleanup(&camss->notifier);
+	pm_runtime_disable(dev);
 err_genpd_cleanup:
 	camss_genpd_cleanup(camss);
 


