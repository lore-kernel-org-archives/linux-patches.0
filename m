Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465C735C68A;
	Tue, 21 Jul 2026 21:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668151; cv=none; b=E5r+LuO7bdrOoAQC/tP2kDoGG4H2uV9ERY4MtlbgBbzFlnm++l4JhCW5Ffl2nm2ZifNX+Jsrf2i/nLohHoyCzk1+zEvMR8yH8u9QuFDB2OM0fhjK4kY/dN3BvX2UZerjhaOIdMuluLMX4RfVKjxcRSxQ19VW1HItY4Qptyhzs+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668151; c=relaxed/simple;
	bh=KcNMlHkaUXCXDuvGPB5UyO/msyQO27QEgfO6x3dh20U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pR4RJu3ipTEL45XhBjDbHkjUqLORR86T8XHri3mpdoYg7WyCFKeszEYCZ3uaFzwlEs/9sWHbTRC2gasGkifk2j6UBZHQ0IhM2rkOT1SWdAiUBqu2Z1yI59LINwnNNEpzGOBu4oCZOR204rbMgwv91CkH8v+xf7h+8OPX8La+LD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lIfibka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lIfibka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67C61F000E9;
	Tue, 21 Jul 2026 21:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668150;
	bh=wqkVCts54y/XRcRgQabAFC0Fg4ZOka2n25o6pxDRuiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lIfibkalMCLhJQhcAH6q75wWhljAOabfeHdCNNmqERs2PoRJTovPYqZ84iBESySR
	 WndYNTFkV9Zc0kNW8XiiUw+vvhktR4i6oO8be2ejXr7DElhYauVVlVdWdX9xcaAzNs
	 SIE0EAo8T7XsTn1VvQyOS3S/Ygvle+dz0QRKImB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 0068/1067] iio: light: tsl2591: return actual error from probe IRQ failure
Date: Tue, 21 Jul 2026 17:11:09 +0200
Message-ID: <20260721152426.092363480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

commit a00ffd15674bfaf8b906503c1600e3d8709af56c upstream.

When devm_request_threaded_irq() fails, probe logs the error and
then returns -EINVAL, dropping the real error code and breaking the
deferred-probe flow for -EPROBE_DEFER.

Return ret directly; the IRQ subsystem already prints on failure.

Fixes: 2335f0d7c790 ("iio: light: Added AMS tsl2591 driver implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2591.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/iio/light/tsl2591.c
+++ b/drivers/iio/light/tsl2591.c
@@ -1139,10 +1139,8 @@ static int tsl2591_probe(struct i2c_clie
 						NULL, tsl2591_event_handler,
 						IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 						"tsl2591_irq", indio_dev);
-		if (ret) {
-			dev_err_probe(&client->dev, ret, "IRQ request error\n");
-			return -EINVAL;
-		}
+		if (ret)
+			return ret;
 		indio_dev->info = &tsl2591_info;
 	} else {
 		indio_dev->info = &tsl2591_info_no_irq;


