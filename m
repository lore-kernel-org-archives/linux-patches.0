Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB55C3ABD99;
	Mon, 17 Aug 2026 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975494; cv=none; b=X52YZXCIvfDmqXvNnIrtvUfcn22zIk7HADHK+w2yGFGYCBdQoJ+WajAtWnveQ+bfyf/8+2VZFM5aAaSEQM7PA2LGFrsSMn7sNxeD4iO/7t01quwfBQ8h9ZQ/51MusvUc+WDU0s2S3KyLxeoPzpVDXx/2oJhQE35Iq7MOjMjOlyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975494; c=relaxed/simple;
	bh=DytvyLR81OxCDLQD04GBsQDfmhOPFpPgotnVnNQoSzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGEDSGL48KPzrOuq5fAYvr+xaXErLkwO0nONtx1EyiVQqxlKOVeQ8VYjkKxa+QhR5AeAoPmk32EKFWfxxXPa1ULq1iRX42ZFHC826kyt9S6vW6CGOkTNeHk63yAR1p2+7d52PAwAMII9U6UH5TEztOgpnDWekMm1biy+P8oH/6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOIYb3Ti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOIYb3Ti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6221F000E9;
	Mon, 17 Aug 2026 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975493;
	bh=g7gmTpbRe7nxF5sHMyWCr4JeKFb9Ejz7JFUNiYnIhBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zOIYb3Ti/S0Gf+Bt5H4oh3V0aU4O9Snd7lmRdsEmaLkFxaUaL59iaPbA1AxyCCphL
	 7XxxfcRAjCRwZkZUIshdMMZjCgLxHpSjU01MGd0di8WFc3dZsg+vqAZ6EP915QknVJ
	 OU0WZjn14VXUjYGbcAa+M3ns+ancP93O3TYClEWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 5.10 047/389] usb: chipidea: fix usage_count leak when autosuspend_delay is negative
Date: Mon, 17 Aug 2026 15:28:06 +0200
Message-ID: <20260817132540.846250587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit fc3afb5728e297994863f8a2a01b88a920bbf53e upstream.

The probe() calls pm_runtime_use_autosuspend(), but remove() does not call
pm_runtime_dont_use_autosuspend(). This can lead to a usage_count leak if
autosuspend_delay is set to a negative value.

The pm_runtime_use_autosuspend() also notes that it's important to undo
this with pm_runtime_dont_use_autosuspend() at driver exit time.

Fixes: 1f874edcb731 ("usb: chipidea: add runtime power management support")
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-sonnet-4.6
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260716104126.2763454-1-xu.yang_2@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -1238,6 +1238,7 @@ static int ci_hdrc_remove(struct platfor
 		usb_role_switch_unregister(ci->role_switch);
 
 	if (ci->supports_runtime_pm) {
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		pm_runtime_get_sync(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_put_noidle(&pdev->dev);


