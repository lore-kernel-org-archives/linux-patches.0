Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B7812FB31;
	Wed, 19 Jun 2024 13:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802367; cv=none; b=KLi/fdUYYioFypORd89SFUELQF9k/HcrjR7eA4F401adth6ttkGm44QGFYvVvanBrRTSe1S9StpXxNw+EAyQ/fp87wu6F8m3FbdhcTt/6i7Gz6S4gBh1dzPfg87lpPvwjsWPC835TNpfoz/5dj2b4nD/+sQimUxJU/w/p9Muv0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802367; c=relaxed/simple;
	bh=pAXOIfG7gOYtRPzObOgPzZHPEI8hD7a1Sia3sSHWKho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/xYnIXQreCvbIM0zj68TmlbzkXx9p/tKkb97m1bZ9PsDI7X4wN3whyHKlQG/bYCs6Mm2SVq4VQRFVojcBcmW7tWwBdwv9bOotrX0ohwlyTVRtUEZ4R09C8wTWGKwMJj9TGhxC4APtsxUPX9BhSYDeny3jM85y05f4o14pmmaZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sl9NH2ai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sl9NH2ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E150C2BBFC;
	Wed, 19 Jun 2024 13:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802367;
	bh=pAXOIfG7gOYtRPzObOgPzZHPEI8hD7a1Sia3sSHWKho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sl9NH2ai6dbnzKNwL/RpSGvpu+5OtebH4oy2nrfRujfQoKS2t0/LpfAWH0EV+Bt3k
	 RIW2tM9F4aT7rQOfoIas2UQWQCDYUIaqV1xE5L1i+vZpaATfotAApcehwkuaq2AUXM
	 USMIhdNR4Q016w3BcRM/Tfjg5jhCFba3v0LZ7x1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongzhi Liu <hyperlyzcs@gmail.com>
Subject: [PATCH 6.6 172/267] misc: microchip: pci1xxxx: fix double free in the error handling of gp_aux_bus_probe()
Date: Wed, 19 Jun 2024 14:55:23 +0200
Message-ID: <20240619125612.943965933@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Yongzhi Liu <hyperlyzcs@gmail.com>

commit 086c6cbcc563c81d55257f9b27e14faf1d0963d3 upstream.

When auxiliary_device_add() returns error and then calls
auxiliary_device_uninit(), callback function
gp_auxiliary_device_release() calls ida_free() and
kfree(aux_device_wrapper) to free memory. We should't
call them again in the error handling path.

Fix this by skipping the redundant cleanup functions.

Fixes: 393fc2f5948f ("misc: microchip: pci1xxxx: load auxiliary bus driver for the PIO function in the multi-function endpoint of pci1xxxx device.")
Signed-off-by: Yongzhi Liu <hyperlyzcs@gmail.com>
Link: https://lore.kernel.org/r/20240523121434.21855-3-hyperlyzcs@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gp.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gp.c
@@ -111,6 +111,7 @@ static int gp_aux_bus_probe(struct pci_d
 
 err_aux_dev_add_1:
 	auxiliary_device_uninit(&aux_bus->aux_device_wrapper[1]->aux_dev);
+	goto err_aux_dev_add_0;
 
 err_aux_dev_init_1:
 	ida_free(&gp_client_ida, aux_bus->aux_device_wrapper[1]->aux_dev.id);
@@ -120,6 +121,7 @@ err_ida_alloc_1:
 
 err_aux_dev_add_0:
 	auxiliary_device_uninit(&aux_bus->aux_device_wrapper[0]->aux_dev);
+	goto err_ret;
 
 err_aux_dev_init_0:
 	ida_free(&gp_client_ida, aux_bus->aux_device_wrapper[0]->aux_dev.id);
@@ -127,6 +129,7 @@ err_aux_dev_init_0:
 err_ida_alloc_0:
 	kfree(aux_bus->aux_device_wrapper[0]);
 
+err_ret:
 	return retval;
 }
 


