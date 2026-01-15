Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D0F3BFE4F;
	Thu, 15 Jan 2026 17:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499499; cv=none; b=ccBfu6rzN/bvnJNRuOxeGauj59A4tHxWsbaRH6fUyeZJBZWvamMhfBeVITVNOcQSfX185IO1QdPYoOYDHv0Clditj8J7mes9q80aafkqVMhwmwjHpvYfRUfD5qZSdskmd3BXNHR6sNbGjGVcvj4lIg9TnbT8wBKYwfNZx5RfwT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499499; c=relaxed/simple;
	bh=oSdbOeabvx+mvEOaeltobnEv7dc8DQuzZ0R8HhUIDyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAXyLSyJhOZMmOh3O1M55VeHKHdNPISRTnZcDFttmTgOyoMkOxNks8LZI8hQDfGQPIWEqRZzFLkYldLzNzsEr+xoOof4dxSGsf4g60ui9b37oXtPMpuULlmrzr0odfTYYLoa26NOCNFwavvN/XgBnMUcM4Os80Oe/vs2C0Av2VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGGAdEax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGGAdEax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FA4C116D0;
	Thu, 15 Jan 2026 17:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499499;
	bh=oSdbOeabvx+mvEOaeltobnEv7dc8DQuzZ0R8HhUIDyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGGAdEaxSBqfwKTC0WdP9KYPsOb9pY3B/zpEHwvQfn97wLWs9YNRiJVPG/7sHi7E7
	 BrzktkRfaMzwDE31JK54yrZti5Z6tj7qtyobNHUrBBDPa0WZTBomCm4JHba6H07yIN
	 RUR8vkVvBCFlL4FX0CQ6IDG3ioUrVSiCPLGZySA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.10 249/451] platform/chrome: cros_ec_ishtp: Fix UAF after unbinding driver
Date: Thu, 15 Jan 2026 17:47:30 +0100
Message-ID: <20260115164239.899422987@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 944edca81e7aea15f83cf9a13a6ab67f711e8abd upstream.

After unbinding the driver, another kthread `cros_ec_console_log_work`
is still accessing the device, resulting an UAF and crash.

The driver doesn't unregister the EC device in .remove() which should
shutdown sub-devices synchronously.  Fix it.

Fixes: 26a14267aff2 ("platform/chrome: Add ChromeOS EC ISHTP driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20251031033900.3577394-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_ishtp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/chrome/cros_ec_ishtp.c
+++ b/drivers/platform/chrome/cros_ec_ishtp.c
@@ -714,6 +714,7 @@ static int cros_ec_ishtp_remove(struct i
 
 	cancel_work_sync(&client_data->work_ishtp_reset);
 	cancel_work_sync(&client_data->work_ec_evt);
+	cros_ec_unregister(client_data->ec_dev);
 	cros_ish_deinit(cros_ish_cl);
 	ishtp_put_device(cl_device);
 


