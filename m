Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DF22E2F0E;
	Mon,  4 May 2026 13:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902909; cv=none; b=oGGE8cXbi3eRnS7wh4PMz96LWGrEJxLOcgZxz8FCihz3GKNCDSfeetJwbD5lPqPwHfqm5CLyrikYSOc2qJInp4ing2PMqoj4Jwf23WOV7gYsMx5cRvLszOjXK4HdLy+wWi9bfyJ2NTC43NIyMkWS2S8Dy54e1MQEnmA1x8lrhKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902909; c=relaxed/simple;
	bh=ZzT6g+KrMqS+1Obuin2H7A6Pb9SMEgv95NxzT/1xa8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hH+VoyCHgsa4Z8VIcWNYJ4uCwnZ+ec2ZQDZIhrQQNMr8NYfGLgg6iBLJ2dVTI+Q1kAihu1g9qDYDmxPgt4iyJB+MhFgVoFoubtBRhodH5iRm0bVmNdoWMUzftv9OFLGhTYKps3tc6TiQrUR3L5QgQ6Iegt5tH+xbZBOmn7M2ymE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRUnodNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRUnodNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB18C2BCF4;
	Mon,  4 May 2026 13:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902909;
	bh=ZzT6g+KrMqS+1Obuin2H7A6Pb9SMEgv95NxzT/1xa8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRUnodNfJtSGNDrGRz6gx85hvjgKFaNFODVi14uIgb6dqgStHqwtuaaSweoU1kVF6
	 m7Dk//Kle4D08x0lwxijA0Q1RBtbudGEK2mrhxZWex046VL9A4wYWi5j6OnAQZvkmx
	 DX5fIktHzWnFxjb4G++l7g3m9qognrrPOhHogljU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 7.0 005/307] usb: chipidea: otg: not wait vbus drop if use role_switch
Date: Mon,  4 May 2026 15:48:10 +0200
Message-ID: <20260504135143.027487860@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit a4e99587102a83ee911c670752fbca694c7e557f upstream.

The usb role switch will update ID and VBUS states at the same time, and
vbus will not drop when execute data role swap in Type-C usecase. So lets
not wait vbus drop in usb role switch case too.

Fixes: e1b5d2bed67c ("usb: chipidea: core: handle usb role switch in a common way")
Cc: stable@vger.kernel.org
Acked-by: Peter Chen <peter.chen@kernel.org>
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260402071457.2516021-3-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/otg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/chipidea/otg.c
+++ b/drivers/usb/chipidea/otg.c
@@ -187,8 +187,8 @@ void ci_handle_id_switch(struct ci_hdrc
 
 		ci_role_stop(ci);
 
-		if (role == CI_ROLE_GADGET &&
-				IS_ERR(ci->platdata->vbus_extcon.edev))
+		if (role == CI_ROLE_GADGET && !ci->role_switch &&
+		    IS_ERR(ci->platdata->vbus_extcon.edev))
 			/*
 			 * Wait vbus lower than OTGSC_BSV before connecting
 			 * to host. If connecting status is from an external


