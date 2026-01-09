Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044B42737EE;
	Fri,  9 Jan 2026 12:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961395; cv=none; b=gHSw28SjGSvGbI76G46mXu7Fu2VHTko0Yci1D2OQvyhOfVGCSbYa+KBsHp3XRkYMQmUGjG6HsGauOlfJ/h7pP/zgByABL6OZNC4XBgYqNV4ishem0ZhO7aDJ6w2Ij0tEbtP1Ed2204GRidQ7l5apP11kuKc5PiuPDpShLWTn2jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961395; c=relaxed/simple;
	bh=aSAJcwYU/yiiek91OI2wzZTpcVPeYT7d9Cl3KELy56M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2U5GdtlWsyv5XbR8WWzKpIQJhR38NGY2chSLOnUu1Ya/PihqOKGlGlmdyx6hWayO9pH8H2x/DwSIFhGl/6w3Nivl4fIl10Kn64/e1PDeF9VFg1LOqnueI5GElrBS1dtlOYk0jwimjuhz7QnwtL+GAjtPUKMt5ZCfnP/woRf7Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xn9n5j2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xn9n5j2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89175C4CEF1;
	Fri,  9 Jan 2026 12:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961394;
	bh=aSAJcwYU/yiiek91OI2wzZTpcVPeYT7d9Cl3KELy56M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xn9n5j2S06GEGS6tooZyvDdD1Q1TeG+lwEeJJGGzDfry7gfvdIm66PptN3LidUPEX
	 22zu9DjoNc3Br2TiNhksKVLZ/IiGyobKn9uNEmYdrRlBwRS1jfc/h+Pzu0Kx5j9qLR
	 ZvRgbDAEbsu6TKRYIG/KwYLz0eaMVCB++C11g3xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Amitai Gottlieb <amitaig@hailo.ai>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.6 736/737] firmware: arm_scmi: Fix unused notifier-block in unregister
Date: Fri,  9 Jan 2026 12:44:35 +0100
Message-ID: <20260109112201.793006570@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitai Gottlieb <amitaig@hailo.ai>

In scmi_devm_notifier_unregister(), the notifier-block argument was ignored
and never passed to devres_release(). As a result, the function always
returned -ENOENT and failed to unregister the notifier.

Drivers that depend on this helper for teardown could therefore hit
unexpected failures, including kernel panics.

Commit 264a2c520628 ("firmware: arm_scmi: Simplify scmi_devm_notifier_unregister")
removed the faulty code path during refactoring and hence this fix is not
required upstream.

Cc: <stable@vger.kernel.org> # 5.15.x, 6.1.x, and 6.6.x
Fixes: 5ad3d1cf7d34 ("firmware: arm_scmi: Introduce new devres notification ops")
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Amitai Gottlieb <amitaig@hailo.ai>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/notify.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/firmware/arm_scmi/notify.c
+++ b/drivers/firmware/arm_scmi/notify.c
@@ -1539,6 +1539,7 @@ static int scmi_devm_notifier_unregister
 	dres.handle = sdev->handle;
 	dres.proto_id = proto_id;
 	dres.evt_id = evt_id;
+	dres.nb = nb;
 	if (src_id) {
 		dres.__src_id = *src_id;
 		dres.src_id = &dres.__src_id;


