Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6ECF2C0F60;
	Tue, 26 Aug 2025 14:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218317; cv=none; b=dNVDRZGySlG12OXWxuqa+DCARt1avLlu2jaw1FduADtb01wjrhfNeoWgYgQq2MgCDF/CpIFlbouAGMdvzb0ezmkWiphpk0Hs9VD25NzgmT4WC8PN97J3dE9Bv1vCCI8zzlqB7vEdkAuFC1tW/NaQrFDeFkpz/4YkGu9+H6PdzAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218317; c=relaxed/simple;
	bh=xpj8jN0E3M9Jr206p0zasaGyfgGAjFEpdkRXf5Vwuf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqiJtEISXzFzehYEW4diQV5Rz97eO6R6nj+oUW/z5qDvoCIw3QokMc1OQMtgVcbNgbp+9IwRg24dEHEVrf3xez6N/9Mb5jX/qewa5sNMxUxGwl0SFZHeL2ol6bY5HAqwu2sDiEbuT6Aa2OqHoLK4tjDJ7u9ZbpjfyIahY6UnklM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bh5+X/Fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bh5+X/Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A7DC4CEF1;
	Tue, 26 Aug 2025 14:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218317;
	bh=xpj8jN0E3M9Jr206p0zasaGyfgGAjFEpdkRXf5Vwuf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bh5+X/FjqgvxE7l+TCQ47/wGBBeKMxhhy5Wnw33iHq19qmKUeSeTff6i8Ftg239wd
	 ohdX4I6yQ9U6ZkTCFhJzJSBSqyGNDZPMhGPBc0ky/zB6rYW+KKQcHk1NUQI+qJKTo8
	 URCpAjP7t9r6tH3fZQx3ZbFrmsNF7/jziFRd7V1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 435/523] USB: cdc-acm: do not log successful probe on later errors
Date: Tue, 26 Aug 2025 13:10:45 +0200
Message-ID: <20250826110935.185526070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 79579411826647fd573dbe301c4d933bc90e4be7 ]

Do not log the successful-probe message until the tty device has been
registered.

Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210322155318.9837-9-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 64690a90cd7c ("cdc-acm: fix race between initial clearing halt and open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1510,8 +1510,6 @@ skip_countries:
 	acm->nb_index = 0;
 	acm->nb_size = 0;
 
-	dev_info(&intf->dev, "ttyACM%d: USB ACM device\n", minor);
-
 	acm->line.dwDTERate = cpu_to_le32(9600);
 	acm->line.bDataBits = 8;
 	acm_set_line(acm, &acm->line);
@@ -1531,6 +1529,8 @@ skip_countries:
 		usb_clear_halt(usb_dev, acm->out);
 	}
 
+	dev_info(&intf->dev, "ttyACM%d: USB ACM device\n", minor);
+
 	return 0;
 alloc_fail6:
 	if (!acm->combined_interfaces) {


