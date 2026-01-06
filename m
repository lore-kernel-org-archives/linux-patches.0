Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D71C352F8F;
	Tue,  6 Jan 2026 17:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720256; cv=none; b=EVB7XTnNA2ggsDzlXStMS68VwtN3mfFYrydD8NFhnZP3IS3uxNWDWclL/Nzs6h2rX9XGRuyZtZYTNnzJQ72i+zt4m+fUKvu24A1xiH/QtEk/yhV7dW4fv3siS9ZMJdWM4830ZhooU4yn+O0654179Qv1OCsNklB2NooA1JMS5Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720256; c=relaxed/simple;
	bh=L537cf6+WIsW2OnDn8lWMmf4YoECyiQZPv92qVV/sdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPkVr3Fr2qjaoVM67p19yFdTH2tDieU+zzmPdS+vTfQIEPIUj+TH8M77MEpHCylgzxeeuqKEV/bK+2QfFI7arBe5WUpvL30dEmOhWC+JdGXmuLooXH8rK6IrLXqPw/K/eucmawtfiCQ8p83JTzXfP4G4ixxvmqIGmD36GcpJ6uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScDFyY26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScDFyY26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C94C116C6;
	Tue,  6 Jan 2026 17:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720256;
	bh=L537cf6+WIsW2OnDn8lWMmf4YoECyiQZPv92qVV/sdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScDFyY26RvngCOk+YeHVNBO8L8e5JZ0r1e+OQLzu+65pL3uVeuTDo7C3K5F8K52fq
	 wSFy6dGJ28FRoc7bVz1CPK8O6SB/4GdAhIjZJHGm2QovW1OmZeYP0yXx+I1AwSyeX/
	 KcUHtu3sjIWgIvTrjh7Itvv4r6t/TtVBR14xf5P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Vladimir Zapolskiy <vz@mleia.com>
Subject: [PATCH 6.12 182/567] usb: ohci-nxp: fix device leak on probe failure
Date: Tue,  6 Jan 2026 17:59:24 +0100
Message-ID: <20260106170458.062133811@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit b4c61e542faf8c9131d69ecfc3ad6de96d1b2ab8 upstream.

Make sure to drop the reference taken when looking up the PHY I2C device
during probe on probe failure (e.g. probe deferral) and on driver
unbind.

Fixes: 73108aa90cbf ("USB: ohci-nxp: Use isp1301 driver")
Cc: stable@vger.kernel.org	# 3.5
Reported-by: Ma Ke <make24@iscas.ac.cn>
Link: https://lore.kernel.org/lkml/20251117013428.21840-1-make24@iscas.ac.cn/
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://patch.msgid.link/20251218153519.19453-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-nxp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -223,6 +223,7 @@ static int ohci_hcd_nxp_probe(struct pla
 fail_resource:
 	usb_put_hcd(hcd);
 fail_disable:
+	put_device(&isp1301_i2c_client->dev);
 	isp1301_i2c_client = NULL;
 	return ret;
 }
@@ -234,6 +235,7 @@ static void ohci_hcd_nxp_remove(struct p
 	usb_remove_hcd(hcd);
 	ohci_nxp_stop_hc();
 	usb_put_hcd(hcd);
+	put_device(&isp1301_i2c_client->dev);
 	isp1301_i2c_client = NULL;
 }
 


