Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B953557F9;
	Tue,  6 Jan 2026 17:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720473; cv=none; b=CScpfvmoTF3xH/f00BfnjvRAu/JpAqtpDeJGvJ/2xWT5QuDzjUUzFy0228Ix8BTiUmejKa4cMnbGVdOgPZ/v9MaGGOheXpPniNRJDiP6XDfk3HVw5GT3xmR8fwx6KBUCXEUP0r0fmr2TEkAAp/ELXWBXBvUUkzpj+LnVxRbl1OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720473; c=relaxed/simple;
	bh=AyuB7l9dARyy+yTf+bWRJSUZpD/TKtJg8zrDFL2hjL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGVyfM4g2EvW0IqOH4WnxKkXKJZVp0IW92iA6Yi6Jv/ivHHgTgT5/jpAWTw1h6NL4VNcw8gq5S+Dee4AK5X1BaESAgcxAbwDgevZBj5z8VBoqO4uF2F9VxGtUFY/+9kAUsQE2C6jjCUwXRUtYwDWNwY8UHvTycIced9DBy4ZoBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zV88tNDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zV88tNDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24EEC116C6;
	Tue,  6 Jan 2026 17:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720473;
	bh=AyuB7l9dARyy+yTf+bWRJSUZpD/TKtJg8zrDFL2hjL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zV88tNDoOOULfbveLnf13dK2HzUXSGV4+KEEpQOSlkRMJNeAE3frDDZgE4UIDFdS0
	 GCkcVw5NjG/UGFIsm0IapExlcN1Mj2BIDlsmzZBbkH+aT1UrX9WTqPSDsYR6O9aaE9
	 xd68Q4lflb1p8SNWixtws8ShifE2HJ/5NyqJ0oQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.12 215/567] platform/chrome: cros_ec_ishtp: Fix UAF after unbinding driver
Date: Tue,  6 Jan 2026 17:59:57 +0100
Message-ID: <20260106170459.271541853@linuxfoundation.org>
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
@@ -671,6 +671,7 @@ static void cros_ec_ishtp_remove(struct
 
 	cancel_work_sync(&client_data->work_ishtp_reset);
 	cancel_work_sync(&client_data->work_ec_evt);
+	cros_ec_unregister(client_data->ec_dev);
 	cros_ish_deinit(cros_ish_cl);
 	ishtp_put_device(cl_device);
 }


