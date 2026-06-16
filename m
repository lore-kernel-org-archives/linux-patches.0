Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816462F745E;
	Tue, 16 Jun 2026 16:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627673; cv=none; b=sM3IM145l9u6i3WSk9jR7D2teJoI94fuXT6JgRoEnK+6L+ccAGlz/cMazLVQ8P/YR2zOcOQccqSX8aPzwe81KlkMdpROoKpRtLVDcUkp9F0B0g9jFOr1AWH5u9EiETCiKn+GSBRvP7EAPr6/QkVFlatgzIqlJQcv5SgOKtVm/YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627673; c=relaxed/simple;
	bh=sjkr17lOEohB/jjSabGmyuKEivuJravWNX1/ah6E8Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9u7SpdlrfkeV7aFEKWPXsaKTASR9pPWyoYL1iemphIfzQdD0jjUBF2JXWqi89WAPFfgW6Pv20RS5Pi+eceMkNoC88XCrT/NzLF1XKDp2mSs3opZOjxePseaV64+r5QBIjQhMaQjz8Oo3+MX03U8R6VNO0NovR0o4F6zmui8k8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgSR5ux0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgSR5ux0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EEB1F000E9;
	Tue, 16 Jun 2026 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627672;
	bh=P0eKm3ATBvp9+XWPoojDdhlkE6Og/Fa+BMWEQqk9S/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgSR5ux0qa419iKl5c3YANrjbbYLCEeM+nqVbrjRQHAqmalvXcKFKA2JJ9KXHyZf2
	 0vig5zsIFZ1WMp5xCWhnKTwAbUGfpeHu2Iw5Buz0j/mrsjXm8gSLkHZ9sIChwIy3Gd
	 bqVkThe+zDIUtoY8tqt/ICeFSXpktahCjOTV6Nas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 207/261] slimbus: qcom-ngd-ctrl: fix OF node refcount
Date: Tue, 16 Jun 2026 20:30:45 +0530
Message-ID: <20260616145054.639603625@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 120134fe75c6b0ae38f14eb8b548ad1e5761f912 upstream.

Platform devices created with platform_device_alloc() call
platform_device_release() when the last reference to the device's
kobject is dropped. This function calls of_node_put() unconditionally.
This works fine for devices created with platform_device_register_full()
but users of the split approach (platform_device_alloc() +
platform_device_add()) must bump the reference of the of_node they
assign manually. Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204421.116824-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1547,7 +1547,7 @@ static int of_qcom_slim_ngd_register(str
 			of_node_put(node);
 			return ret;
 		}
-		ngd->pdev->dev.of_node = node;
+		ngd->pdev->dev.of_node = of_node_get(node);
 		ctrl->ngd = ngd;
 
 		ret = platform_device_add(ngd->pdev);


