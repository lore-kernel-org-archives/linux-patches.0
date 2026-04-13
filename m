Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5DC2D8DA8;
	Mon, 13 Apr 2026 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096326; cv=none; b=amQ7P/v+3pyJuqhD0eppYid88UWWlUSrnvrMN6EEuOnIy7vc52a47KKnFWDU23iTyeRVV6BiAW6ndhkScSDdeFFcZxR9W20khay1hRnkYMiuLDXZOKbZLqnpVNAK5ODvPKwn5EQKz548irArAL/4c5bDzsRKvdFCHK0JqXrLgcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096326; c=relaxed/simple;
	bh=QqwJF1CjaAJaK9cA1uV97CX6H6i0IzEuKxiqnqKaw14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PROns3QzonRhRwRS9oi83KrKTmrm9HQVnzbVzok+KQ74b8vsmvqpst6YxUsW9qf/ESbVNmyJagpr88Ge+mRpX386VOfW5q1mRQsSxV2OtGiuidSV7/L3Y5oVkkrGw2iOVYyNHTB5e+917QV1KcjL3RwuBPGMvaoq9LO8AXEw9z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsMmu63p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsMmu63p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA118C2BCB7;
	Mon, 13 Apr 2026 16:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096326;
	bh=QqwJF1CjaAJaK9cA1uV97CX6H6i0IzEuKxiqnqKaw14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsMmu63pKWV+V7P6Y/4+b9NvPofZeBEgOGWsumgdGBuZdHPkjWWavfmFk8OcPJMn7
	 9tWk+NDkcFEa5FroKauGL2by0zMqbQI0+d2HlYeTfVE6ntZzN4w8LpAx1GDjznYOUO
	 juZVz24Zkh7W2Kn0VytRvv0Nvqu6/a5/IQo3j6fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.19 54/86] mmc: vub300: fix NULL-deref on disconnect
Date: Mon, 13 Apr 2026 18:00:01 +0200
Message-ID: <20260413155733.582035504@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit dff34ef879c5e73298443956a8b391311ba78d57 upstream.

Make sure to deregister the controller before dropping the reference to
the driver data on disconnect to avoid NULL-pointer dereferences or
use-after-free.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2365,8 +2365,8 @@ static void vub300_disconnect(struct usb
 			usb_set_intfdata(interface, NULL);
 			/* prevent more I/O from starting */
 			vub300->interface = NULL;
-			kref_put(&vub300->kref, vub300_delete);
 			mmc_remove_host(mmc);
+			kref_put(&vub300->kref, vub300_delete);
 			pr_info("USB vub300 remote SDIO host controller[%d]"
 				" now disconnected", ifnum);
 			return;


