Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795651DF996;
	Tue,  8 Oct 2024 13:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393975; cv=none; b=NhVHah/ZnwsQQoS9YcqWvuAlUVtejz6HACBJNjaaPbjlD9rgRAdcky0y3vgE+JQ7qs/O5pnkDsiYDwmGQ5W2TdlIrSbfXKZnCwtTrw186gMlHu7iY6PhxsaNscyaNhoXJHobpLdKVZy+veAV7/0IvIX0KK/xBv/NHiZ88cAZwto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393975; c=relaxed/simple;
	bh=plFnwNu3clbLpmVsNUD+EPMH8TNfsA9DZaRMfrtPe5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq3t3xXmQ+GhaNu4yp3iohP3g5L90SdXMYQ3v/kRT20YQiW+WYwvEG2XwPgzczRHomF2wVh7QqrRWcEGq7DKMbUXQ0+uM48FGmc2F2GHiGByTiJnw7NVmr0G6oubmyQUy5XGw3ZbkBOSzwh8T3xVcVYJ3XJgN/ce9MEt5eQA9+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3XnIcaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3XnIcaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C713C4CEC7;
	Tue,  8 Oct 2024 13:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393975;
	bh=plFnwNu3clbLpmVsNUD+EPMH8TNfsA9DZaRMfrtPe5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3XnIcaFZI28G/4xL/zU5C3GSUirZDVDPKlXG4oz5gwrYDi2XxHZ9pDf2fqihW74S
	 LT+8Olyd0VGC+B56R8UaMomwN3Gzc4Z4yhqqxAWlk5wil7l7x+ydQdnaXwFEDkRXie
	 8yfqoTV2Dv8AxnUofK90atXM/6b5oHLAISEemEiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 292/386] media: qcom: camss: Fix ordering of pm_runtime_enable
Date: Tue,  8 Oct 2024 14:08:57 +0200
Message-ID: <20241008115640.877305955@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
@@ -1665,6 +1665,8 @@ static int camss_probe(struct platform_d
 
 	v4l2_async_nf_init(&camss->notifier, &camss->v4l2_dev);
 
+	pm_runtime_enable(dev);
+
 	num_subdevs = camss_of_parse_ports(camss);
 	if (num_subdevs < 0) {
 		ret = num_subdevs;
@@ -1701,8 +1703,6 @@ static int camss_probe(struct platform_d
 		}
 	}
 
-	pm_runtime_enable(dev);
-
 	return 0;
 
 err_register_subdevs:
@@ -1710,6 +1710,7 @@ err_register_subdevs:
 err_v4l2_device_unregister:
 	v4l2_device_unregister(&camss->v4l2_dev);
 	v4l2_async_nf_cleanup(&camss->notifier);
+	pm_runtime_disable(dev);
 err_genpd_cleanup:
 	camss_genpd_cleanup(camss);
 


