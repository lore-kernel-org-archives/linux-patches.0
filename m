Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E34A14D2B3;
	Mon, 16 Sep 2024 12:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488498; cv=none; b=NWsj0hokn3tCxTyJ5oPTB1uQdRGB1imMKNrjGtAmLNeNe7t03DjQnSRTCiDvB8RslUHN6qpcxnJqNOWyGPIq+Hqo8+hZDAMUGrtCPe8GzKBZjrSJp/Q8r2l1dCUeC5SaYyAjslxEdX3wzZXujWYmv7fRegGL1Hqk7I9l5HuxrQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488498; c=relaxed/simple;
	bh=HRrV8XIFo8C6UHh6kQGQNKtQ5YJVzAgzK+1160eg3So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+Cj6fr2KOFBjzgRIXb9nJybyqB1oo1USoULLDyHTri7eGAd+LlT09/wTZT2eJG4BBt93Tik3yHijlFteyITburYNp3eH5H2aP/WVF/yEATm8p56UVQkAC7xmDkf0rj+jyBBSQRtfCfqe2X3/UkGxvOIlu8/7Y6DWsiBINM7ASg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LA7hG9+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LA7hG9+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AA1C4CEC4;
	Mon, 16 Sep 2024 12:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488498;
	bh=HRrV8XIFo8C6UHh6kQGQNKtQ5YJVzAgzK+1160eg3So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LA7hG9+65I3Tt2Ly9sYbDOVRINHITMNKtitbKhZUvE3eIKHs59c/iqxu+vwGCUpJT
	 1+kKZaEzimkvKUBguC+etyR+EiPceGRlXtUWquE9eoZKox5cMBsEfU/6EDyraoJm4D
	 u5S2nrJrEoNwYYCWlbXkpRr7zG0w7dVxFz9l6IyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 13/91] usbnet: ipheth: drop RX URBs with no payload
Date: Mon, 16 Sep 2024 13:43:49 +0200
Message-ID: <20240916114224.965225113@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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



