Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5F12BE653;
	Tue, 26 Aug 2025 11:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207048; cv=none; b=jVSXZ56Vnj8Uy1Mf/kIcAi8fwnKLFTLETyZU6QnLoaF166sTw4K6WhFp7DtbGTqNPI1XEP9hvPQuM+HraRVCes3q6x1XOoEczm56uGuLkReGAzZOOv9yflDUdO8Oa8j+EnrDwQnRRJ2e7zKEWKCrGjhGAiRUtJuyjXoK0en62LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207048; c=relaxed/simple;
	bh=i+5NaYNTvvPG1wfBIWCt8ts7+b7DcE23LzgRzmFcRoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WE1SNmoqt9kravvz32VzCveVGSxxpJXX3UKD+gHzcBukDhX67CXN/pntVk5wo8b4dmw7rtTrdEDygdCfEILKpfDtiXiiAnSOW67w35ZzAmgVv1nh9B+RosUSIYoUzTilSmpw6MvsRn5/tsnsZYgcmS0Toz1IanKCne2lwesbyPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy3lk0hR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy3lk0hR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2391DC4CEF1;
	Tue, 26 Aug 2025 11:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207047;
	bh=i+5NaYNTvvPG1wfBIWCt8ts7+b7DcE23LzgRzmFcRoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hy3lk0hRQORb2PLeC9OLOR+Vy7Mq3UW+kE6INBM84c/jqE+TJgcSEe1g4wTy+iO+Q
	 TMVXtY2qFCrsEJgks6nh8ypub0sv96SMQkMR0n1xOwKl9Rt2rs4DIAdYHCBul1CF/Q
	 XTN9sJFYlkNb9jZt6MmNx6CLgFLkuCNeUrLuSQU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 6.16 013/457] usb: dwc3: meson-g12a: fix device leaks at unbind
Date: Tue, 26 Aug 2025 13:04:57 +0200
Message-ID: <20250826110937.647767157@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 93b400f4951404d040197943a25d6fef9f8ccabb upstream.

Make sure to drop the references taken to the child devices by
of_find_device_by_node() during probe on driver unbind.

Fixes: c99993376f72 ("usb: dwc3: Add Amlogic G12A DWC3 glue")
Cc: stable@vger.kernel.org	# 5.2
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250724091910.21092-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -837,6 +837,9 @@ static void dwc3_meson_g12a_remove(struc
 
 	usb_role_switch_unregister(priv->role_switch);
 
+	put_device(priv->switch_desc.udc);
+	put_device(priv->switch_desc.usb2_port);
+
 	of_platform_depopulate(dev);
 
 	for (i = 0 ; i < PHY_COUNT ; ++i) {


