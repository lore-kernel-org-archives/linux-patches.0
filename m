Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB6A43CEE7;
	Thu, 30 Jul 2026 14:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421551; cv=none; b=idpvX0hk3M75JQ9kuptrlAURKg53WnGMogA6gf10+RPsWhcpcdfpzJNMOvvKrxEx+1EfEnuqBSKcljbLNcpwgFjseUlFvReLbnmBzjLGFT0kWlk0mpsZEjANb6ZIQbD4q8loAgZf5pTigCLD4PxETnnge/C9jdCXz4EylZ9+Lqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421551; c=relaxed/simple;
	bh=Qgsrq/1vH/yWbC5crWYCa3YOJJ7r4yOdf2RvpNQ2MrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITdj+0ta3NtmOb9F5zvAOsUyO8ENo8hUmKuhAPHVRXr9vl3Rljbum/YAq2+vC1wyl5UqJBkkp2VpescPbpwkjTAK4nbDcu26Uz2uWivN38yFqv4NkFrO1WY/DEs8q5yB6z0zmVEk6V1DoJzvfj1ZGO8hfeeWLld1LjRqfPjW0cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWhG+WyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWhG+WyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AD71F000E9;
	Thu, 30 Jul 2026 14:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421548;
	bh=B7fxUeKHqOP2kRiUcBOdCGFDru8rTtluD1jOltN1Jak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XWhG+WyEMQallfZ4ofefJb6u44ESRUzsskRb45FIRTiBTU0NtxiErCbMi2J6ZwYLt
	 V8pHzmLpnQOfb5GcEMQ+pRf05mm7/ZY6V0FCMHGI6/udL1KwBKf9BWlODQ5ZWbQSc1
	 Dfx7FWA6eK1dY+AvZBRGl1N3dqdYYS/94KBxaXsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 7.1 142/744] usb: chipidea: fix usage_count leak when autosuspend_delay is negative
Date: Thu, 30 Jul 2026 16:06:55 +0200
Message-ID: <20260730141447.303819210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1253,6 +1253,7 @@ static void ci_hdrc_remove(struct platfo
 		usb_role_switch_unregister(ci->role_switch);
 
 	if (ci->supports_runtime_pm) {
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		pm_runtime_get_sync(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_put_noidle(&pdev->dev);


