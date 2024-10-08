Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0411779B1;
	Tue,  8 Oct 2024 12:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390905; cv=none; b=tgb3Lsh/NI7ZHwnfHem9f3/qRvGkBJ9WdkseMHclB/RQN3XmfgIrK+c3n2FM5R2TeQyt1ubJkGbAPgV/wZxD3GUxd8Za1vjO8WwHaGBbPDCke/HyElj8tP1s4rTpq95qi0bq0AfRLGFuT7DH8u7izwV5pgBJCyxc7tVYs4PhT6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390905; c=relaxed/simple;
	bh=zdHQnjr8nd0rLw0EklwU1gCJgHcTXurLHloIQMBL1Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONdPu8fimptopdHy0A8C2UNsHI+nsjLCpD+f/IuZEGCOLz79mr03MEoPb5Bb9rvmydqaz3AgvpmsKoRlhhyN+0Z24c3+h/419QCm+E8hH0IDrDuA7VzONEutoGf2fWcFiqD0MxC+9ZWXT+SZjjzZfXtxQ7MBqyUQf0JB1l7O0rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCWcFEzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCWcFEzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3971BC4CEC7;
	Tue,  8 Oct 2024 12:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390905;
	bh=zdHQnjr8nd0rLw0EklwU1gCJgHcTXurLHloIQMBL1Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCWcFEzvgtmzey14FzUS1vH6xezdeIzHofgyDJDME5oMgmT0iK3Xuz6XR2sAe7ERg
	 G7FVLCKrUd9g+PfE0+YXe8dAckdFY0tLoAk0j3SrAmoZu4PArHo3wOYoj313K0EdsD
	 gkidvBGo54GADHqgqE0tDOK7Ugve+ngQpBGR0sXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.10 397/482] media: qcom: camss: Fix ordering of pm_runtime_enable
Date: Tue,  8 Oct 2024 14:07:40 +0200
Message-ID: <20241008115704.032368743@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1985,6 +1985,8 @@ static int camss_probe(struct platform_d
 
 	v4l2_async_nf_init(&camss->notifier, &camss->v4l2_dev);
 
+	pm_runtime_enable(dev);
+
 	num_subdevs = camss_of_parse_ports(camss);
 	if (num_subdevs < 0) {
 		ret = num_subdevs;
@@ -2021,8 +2023,6 @@ static int camss_probe(struct platform_d
 		}
 	}
 
-	pm_runtime_enable(dev);
-
 	return 0;
 
 err_register_subdevs:
@@ -2030,6 +2030,7 @@ err_register_subdevs:
 err_v4l2_device_unregister:
 	v4l2_device_unregister(&camss->v4l2_dev);
 	v4l2_async_nf_cleanup(&camss->notifier);
+	pm_runtime_disable(dev);
 err_genpd_cleanup:
 	camss_genpd_cleanup(camss);
 


