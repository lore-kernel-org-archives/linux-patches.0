Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C1B1A6822;
	Sun,  7 Jun 2026 10:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829281; cv=none; b=cOZYP23rYD1Z1yPZXTXUx7xt3l/SW9i7+Dy++l/ZwT384S4rkzFVlA2tFH6VSJvhcRUTMti4V5XfIMFzfzuQUBdxzVzh2DXGID6Q4xVTImY7GX9jAlJqfO+UDabOx/Recz29N/tcJzu7zIJjPopb/Cqu1wKtFTlKUHmsWOmYIIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829281; c=relaxed/simple;
	bh=xyg9zcKgpqFR46eSBu+yyUVviBOsQWTRUddZTtKNps8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxH+Zcxwfz3uIFv/ArHaY/WHxqaIw8llNstNM6vut4gYGyYXgjOAwyRgBjDISXoreY+QOk9GjfsFFUIhlepwIUYv9PTwjoWo0J5s/D2xOw3ACouvLoEZtg4BjzSTigeUbhK4E9Verbi+4l9YiyCVC1hI4HB8Nk7MKvcsmjbbPVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KH8TIBZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KH8TIBZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340C71F00893;
	Sun,  7 Jun 2026 10:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829280;
	bh=NdTOAfPw5+0LADle7PmKYhON3sXCV97QsE+Dj9cv7to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KH8TIBZUM6Ti4CsAf07rZE2lvrqefZnIigffT19M7xAiaddnMp1TSMSH95+t5fbV7
	 YCMB3UR7DXbx+TRyPe/w6y6fGMKtXGoF4dLAz0bGJm7GAiwr30BvIUjk0g4enNlqSi
	 ThnDgnSTOlK7X/06osaYzK1T0rchHp4yFcWz0JDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <error27@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.0 260/332] usb: typec: tipd: Fix error code in tps6598x_probe()
Date: Sun,  7 Jun 2026 12:00:29 +0200
Message-ID: <20260607095737.589709205@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

commit b02900c85a6423cf9b3dcc6b47bf060c85075e69 upstream.

Set the error code on these two error paths.  The existing code returns
success.

Fixes: 77ed2f4538da ("usb: typec: tipd: Use read_power_status function in probe")
Fixes: 04041fd7d6ec ("usb: typec: tipd: Read data status in probe and cache its value")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/agL9o7wUK1dOVBTy@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -1835,6 +1835,7 @@ static int tps6598x_probe(struct i2c_cli
 		goto err_role_put;
 
 	if (status & TPS_STATUS_PLUG_PRESENT) {
+		ret = -EINVAL;
 		if (!tps6598x_read_power_status(tps))
 			goto err_unregister_port;
 		if (!tps->data->read_data_status(tps))


