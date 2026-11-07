Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063240;
	b=KzDHk8kK0SoCy+8UM6ebq/z5fcSSKzSzDZ86+q5J2s05LK+nR5mjGDROa0lfZEbxKrZq
	 /aCsNfgsLNNGHnmwnKYfyEVywMf/f8s5Id4vOd8aWbcbtk+UxSo/xIOKiEqZwnMYqdC6z
	 GIepyZDhjAQemXjpgg6xtnBxAaY2G3E8HSw9nq2KHPRbCyEsfLRsNz9r6jcm+IJlvsbFG
	 1ADNIPII/ePQ3vRQImdEIeA/s/MbLUm1su9XEassJVmqp/ZYZXpmnU5NlcUXQFFMEfB+3
	 O7HEbCqSAJflb03wGfZgNZGOJRfoQzavldl7Ly6QZPwLWJNuttLsiVHSbHN8ncQiTXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lk3dCgz6oOabqECpxbrDhglsn65TVDK3RkkzOtTCMms=;
	b=LBAvpC+vLjOqci0DfPpWiC5JF1Lr/oQfRtBnWi+vsEWm9834wc5khaTwQJKvijh0o0+O
	 tVqwJNXy6c4gGqxwTNLpdz4vmft2DB58Q8jYY9TA3aBVDJC30oUWfWnpR1ay0X5RtgG3F
	 OvqMM9If8j3R3Ed8JDUG2cKJnh3PZx2wm6FF05Mq4Xc4Y2HvadveMYI1NqrR5eQh5JjUE
	 rvyqeoG72Tu+dlRWCT9VYB2Tch/63shQ7bVOY2Uxo8ecv9kMDqAG9ZZ5nGX7e+UWpK4zk
	 A35CbVkXODqywjzsQY1RFM4viAO03smmPFNIJ4OoJH2DjB6Eyen2B7tMJJHlAEH2s8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1iWcjEPz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFD4606A333;
	Sat,  7 Nov 2026 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1iWcjEPz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B7B1F0089F;
	Sat,  7 Nov 2026 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063239;
	bh=Lk3dCgz6oOabqECpxbrDhglsn65TVDK3RkkzOtTCMms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1iWcjEPzaazQnevDEj4lGLqCDrm2FKP5TWCMm1kt4PgBVh1NkS8JEpvlBW9RgmW01
	 KxddZ/zl74SIgsYEj0AMMjXqqFLSiMwhW/UWC1UzFwrbR9p2HGlezIlb/Yjda312m0
	 ZS1b1RocmxpYb61QNRSuLMGAC7yr0ktAXsKdr8uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 445/869] USB: cdc-acm: fix urb leak on disconnect
Date: Sat,  7 Nov 2026 08:52:07 -0500
Message-ID: <20261107134908.833440011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 648b08aa37c1b24a61662ad78964f2bca659ca26 ]

Make sure to drop the reference taken by usb_anchor_urb() when removing
URBs from the delayed URB anchor to prevent them from leaking when the
device is later disconnected.

Fixes: 140cb81ac8c6 ("USB: cdc-acm: fix broken runtime suspend")
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/20260917161217.2161883-1-vulab@iscas.ac.cn/
Cc: stable@vger.kernel.org	# 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20261009122934.464142-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index b980cb08d675b..884dc80868ca9 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -782,6 +782,7 @@ static void acm_port_shutdown(struct tty_port *port)
 		urb = usb_get_from_anchor(&acm->delayed);
 		if (!urb)
 			break;
+		usb_put_urb(urb);
 		wb = urb->context;
 		wb->use = false;
 		usb_autopm_put_interface_async(acm->control);
@@ -1710,7 +1711,7 @@ static int acm_resume(struct usb_interface *intf)
 			urb = usb_get_from_anchor(&acm->delayed);
 			if (!urb)
 				break;
-
+			usb_put_urb(urb);
 			acm_start_wb(acm, urb->context);
 		}
 
-- 
2.53.0



