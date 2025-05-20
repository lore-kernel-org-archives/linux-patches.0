Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AE924728A;
	Tue, 20 May 2025 14:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750058; cv=none; b=XO68ZWigDT7dw/25t6lnKJ5p98WtvuiWT5YSpaE2idf2o1eqp2OFe1axiUi/0fZDrDDQN6JHN47Yv7xA8/SbXV2PTIlN+dJKUdaykPlKAiEjNeRQQnmbMpLhBdM8XJ47evcQRzwaCuHjthzZQ0jzexKUaYutvAgZr7W4/MM834k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750058; c=relaxed/simple;
	bh=7RKjtybvrWh5mCrmO8fmPKwJ5TkkZEU1Kcn4F4Nm/dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlKSBdpDtlGKeQ7NrXH+XDCVPgXj0UdZT4q5Z+yg1Bpu0wIbNq02zFZAyWZIP0+CevipIvrvDQ0tyYDoqAVTkB8YVpOsXGoQlBWIi8ScF26GQV5AeZfdI65Ks4Vs8T2/11wTHpc1Di09XLjhR2ShictUDTHvloEc18wOQbrXCW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfQpct84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfQpct84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC07C4CEE9;
	Tue, 20 May 2025 14:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750058;
	bh=7RKjtybvrWh5mCrmO8fmPKwJ5TkkZEU1Kcn4F4Nm/dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfQpct84NHF/tSIFOHH0UFzZHnr0VsGMqVd3U+rZJxOc/paPDcvDDN+wHgTyoD/ar
	 XTmVcLWJ8C0hN1T27QLP6vEthfMR0eaYcpO+MR/WQ0mpf7ceA4KZSobfCU4IqWkt1K
	 J1UGcOzx0iHhGnktqD1BGLdeV7OC0y48Ql0lxXAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/143] HID: thrustmaster: fix memory leak in thrustmaster_interrupts()
Date: Tue, 20 May 2025 15:49:43 +0200
Message-ID: <20250520125811.152604630@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

[ Upstream commit 09d546303b370113323bfff456c4e8cff8756005 ]

In thrustmaster_interrupts(), the allocated send_buf is not
freed if the usb_check_int_endpoints() check fails, leading
to a memory leak.

Fix this by ensuring send_buf is freed before returning in
the error path.

Fixes: 50420d7c79c3 ("HID: hid-thrustmaster: Fix warning in thrustmaster_probe by adding endpoint check")
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-thrustmaster.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index 3b81468a1df29..0bf70664c35ee 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -174,6 +174,7 @@ static void thrustmaster_interrupts(struct hid_device *hdev)
 	u8 ep_addr[2] = {b_ep, 0};
 
 	if (!usb_check_int_endpoints(usbif, ep_addr)) {
+		kfree(send_buf);
 		hid_err(hdev, "Unexpected non-int endpoint\n");
 		return;
 	}
-- 
2.39.5



