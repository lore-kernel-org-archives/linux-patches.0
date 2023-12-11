Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111114437B;
	Mon, 11 Dec 2023 18:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGtCLnWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADCBC433C8;
	Mon, 11 Dec 2023 18:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320341;
	bh=Nl4if6akzPR+kb+UJGAVE7D+rd690+/PhbLSaDH9MlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGtCLnWpDIVa6BBwQ+ITSlpexwwYiN0DwCvh2tyN3lSlFXEt0j+F39OBV+z3LlOHT
	 BJliLWENWW9yMufmznnp1MaDrnIdE3PcJ9uySodzhl7uuaVxC3k2QkejfYVr82+BfH
	 kG3kRcVKjc4ZRPjSQdOcupeNHe7g29ln6HhGatKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Grundler <grundler@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hayes Wang <hayeswang@realtek.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/194] r8152: Add RTL8152_INACCESSIBLE to r8156b_wait_loading_flash()
Date: Mon, 11 Dec 2023 19:20:16 +0100
Message-ID: <20231211182037.743248097@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 8a67b47fced9f6a84101eb9ec5ce4c7d64204bc7 ]

Delay loops in r8152 should break out if RTL8152_INACCESSIBLE is set
so that they don't delay too long if the device becomes
inaccessible. Add the break to the loop in
r8156b_wait_loading_flash().

Fixes: 195aae321c82 ("r8152: support new chips")
Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2cee9b2a21615..8b463a9c5e44c 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5403,6 +5403,8 @@ static void r8156b_wait_loading_flash(struct r8152 *tp)
 		int i;
 
 		for (i = 0; i < 100; i++) {
+			if (test_bit(RTL8152_INACCESSIBLE, &tp->flags))
+				break;
 			if (ocp_read_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL) & GPHY_PATCH_DONE)
 				break;
 			usleep_range(1000, 2000);
-- 
2.42.0



