Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD19145B0C;
	Mon, 16 Sep 2024 12:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488213; cv=none; b=BL8/rlQGEwoIbqgU9hqY5u89YY+nN3OF1ldjzlZdrU92fxUzt665BmIL9QhihU/nD0MuJl2w8MgsezWuU2JDshgeGSP5mpd03FNJ8CT6mI0edAwwB4Qo/Z5Kbix/PHLaY7TyXlVfKCRRH14Jn7CRXLn54O4BFcLqW0H4DQGZcPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488213; c=relaxed/simple;
	bh=txmMmRFj6kdXEGGrIj1RnNFijWQ5CYnHrFoAMdEomcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHsKtpes0ujRHEUs7LwcOEPoxvtf95a9u3o5WJFtuwhOFkFCJ348BhJBAw3evs86VkNoHvTEsn2ptiNSkrue0rNbHhbBdDuNdwW+fVgkbEIvP8/M6D3f6tjTdEDqosDf/Dwz/yPgxDxPoAhDuzrMHncaW+kqem6j+DsSdFGynX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ejs2rktG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ejs2rktG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2100C4CEC4;
	Mon, 16 Sep 2024 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488213;
	bh=txmMmRFj6kdXEGGrIj1RnNFijWQ5CYnHrFoAMdEomcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ejs2rktGOmIZIwqDOi1dBmJOdwFZA3Knklc2RsMSJyuLs3bZIIlwwLMdY9W1XPsiO
	 HaGjxWegaLIs9Tw93CiYR0nDKZaBDMG7+uujrlDMwgLB2isNngxbCvvNzOebyKldWD
	 p1R3qolqsGqZixjQi1MkqMKboE0RVpA7fbx87nA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 007/121] usbnet: ipheth: drop RX URBs with no payload
Date: Mon, 16 Sep 2024 13:43:01 +0200
Message-ID: <20240916114229.171224691@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Foster Snowhill <forst@pen.gy>

[ Upstream commit 94d7eeb6c0ef0310992944f0d0296929816a2cb0 ]

On iPhone 15 Pro Max one can observe periodic URBs with no payload
on the "bulk in" (RX) endpoint. These don't seem to do anything
meaningful. Reproduced on iOS 17.5.1 and 17.6.

This behaviour isn't observed on iPhone 11 on the same iOS version. The
nature of these zero-length URBs is so far unknown.

Drop RX URBs with no payload.

Signed-off-by: Foster Snowhill <forst@pen.gy>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ipheth.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 017255615508..f04c7bf79665 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -286,6 +286,12 @@ static void ipheth_rcvbulk_callback(struct urb *urb)
 		return;
 	}
 
+	/* iPhone may periodically send URBs with no payload
+	 * on the "bulk in" endpoint. It is safe to ignore them.
+	 */
+	if (urb->actual_length == 0)
+		goto rx_submit;
+
 	/* RX URBs starting with 0x00 0x01 do not encapsulate Ethernet frames,
 	 * but rather are control frames. Their purpose is not documented, and
 	 * they don't affect driver functionality, okay to drop them.
-- 
2.43.0



