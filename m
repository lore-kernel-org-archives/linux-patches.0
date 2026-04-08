Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C3B37F8C2;
	Wed,  8 Apr 2026 18:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671964; cv=none; b=cvI2JKhhtQJn7DnquoF/94K/nf1Q4wPVkJmNklLl0xg6RWIkn8V+qOOrp5d8VGDzyFYJtWK2JFUIy0B4sCmj+d/plgCacIYSAelUhJuisynRqt1FOXNTi9C8UCkmyCbI5NtJ4mixZRAIT54fI5mIoAb2b4iFngGJG2Ryu2zwpvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671964; c=relaxed/simple;
	bh=KhkeNBoDQ9S9/t+BNFfgbH6FkyFepPyoTirFCu4b3fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJOMCk1lRfZShKVNLjkMzPRtPnyUwremuo2OWGW20z7Wm2DYZlDKul+yd02gWZJ0hFpCPvF/GRY47YQMyFkXgHulxWBIirMXgPHI/w/dE8mQf/NJ/8+FjkxA1tIkC8Q2/lDg5lTI1dFtCYizz6RGt27BDrFy0AfysVxDHc+KaY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnSCz5za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnSCz5za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE75DC19421;
	Wed,  8 Apr 2026 18:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671964;
	bh=KhkeNBoDQ9S9/t+BNFfgbH6FkyFepPyoTirFCu4b3fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnSCz5zaXi7UVRU8Q0gHW79Oav1o8z516InXzhEweU+evIDgeI4Fm3G48fmg9HExK
	 fKjh1lSUSONfgcp0i7CMubNCnaXlPqTAnhKYBPK+AxLY9f+UX42q/jdDF/OnJap5dr
	 QakviTNHRze7bWGGQihL3cevxaWYR0cdrgrGczeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/312] HID: wacom: fix out-of-bounds read in wacom_intuos_bt_irq
Date: Wed,  8 Apr 2026 20:00:54 +0200
Message-ID: <20260408175938.887849786@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Sevens <bsevens@google.com>

[ Upstream commit 2f1763f62909ccb6386ac50350fa0abbf5bb16a9 ]

The wacom_intuos_bt_irq() function processes Bluetooth HID reports
without sufficient bounds checking. A maliciously crafted short report
can trigger an out-of-bounds read when copying data into the wacom
structure.

Specifically, report 0x03 requires at least 22 bytes to safely read
the processed data and battery status, while report 0x04 (which
falls through to 0x03) requires 32 bytes.

Add explicit length checks for these report IDs and log a warning if
a short report is received.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 3837394f29a0b..614f2adab5635 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1253,10 +1253,20 @@ static int wacom_intuos_bt_irq(struct wacom_wac *wacom, size_t len)
 
 	switch (data[0]) {
 	case 0x04:
+		if (len < 32) {
+			dev_warn(wacom->pen_input->dev.parent,
+				 "Report 0x04 too short: %zu bytes\n", len);
+			break;
+		}
 		wacom_intuos_bt_process_data(wacom, data + i);
 		i += 10;
 		fallthrough;
 	case 0x03:
+		if (i == 1 && len < 22) {
+			dev_warn(wacom->pen_input->dev.parent,
+				 "Report 0x03 too short: %zu bytes\n", len);
+			break;
+		}
 		wacom_intuos_bt_process_data(wacom, data + i);
 		i += 10;
 		wacom_intuos_bt_process_data(wacom, data + i);
-- 
2.53.0



