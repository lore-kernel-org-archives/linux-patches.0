Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062271;
	b=W7OlnvJH9ONtIqIjGmmVQ0xgky0AQ9DATRtv+AT8WCt6ZqEcCSTT1g3EouUORsOuXQbW
	 UVjvu1hVvOEeC35fMcbOs4JIB+RN1IXZFdCe8FD1EHu3/pPizety6C1PiHexTOvrevfbT
	 zkzZZXHC4j2oBPd5Gu+wZdSsK/5Y1s9NiQhOoW2AQrG2zp+OCxZYTy2ZYFBxzysWyVOI+
	 4/e5uSDu7IVUDVkeDH5qWwyxnk8golkQBZVUC/GM4MDDFmKaYwxm+6cun9nTjUBF80C17
	 lkWy7w9x5JzxFjqP1TRXPDmWpYpdxkZbY14rV5JDzyLW+45ZKvUJTj2QTnurgPHQ5rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ow5AYrxYY28m7ykUraEnDzFeuNjGaufcshbUs9y9olw=;
	b=vGmrAcPf99zrzFufz4z7jbC12/0kLnPWSzmwWx6XYX0GG7acG/YzbiGlYs8+NLZLhpD1
	 dxkOGahfPxaj0EjjEmbRMkDoDuuunXRDIGDNTZoCWJ0cMH6exE9No9atx1Fd1937rPXXq
	 knPnHUj2OHGeQvLEH2HMf4zCdXASgy3z5L+GvG2KC3Q5pvtAilhAC+tXhQsQ3xosQymGs
	 1ya/Hh/HJKqUsAAMNfkfOmbXKRDlVGKQsks9YNOCHW4ZqMWzl+AGwXwPq5Dldro7QDnpp
	 S4tXwKHjXAtYYfC5IGUQvWrcPnaT9SWv2PaFb3of6vKWdLQzlusKPfVKASGGVou8+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rF+pqF1c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310CD60A380D;
	Sat,  7 Nov 2026 14:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rF+pqF1c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D155F1F0089F;
	Sat,  7 Nov 2026 14:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062271;
	bh=Ow5AYrxYY28m7ykUraEnDzFeuNjGaufcshbUs9y9olw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rF+pqF1c/FxYOXgBKLboyCVBeM3ZWJi+LPFuJcjz/+1mq46FI0Xr+670/QNQvYgjp
	 kSAlbfr9vk8ROpOiwnkLD77S8UKmsKD0JnXqLOq2NXfJnEZuGCY41ymBGHO0DWxbc4
	 YKO7y2au2ZYSi4VwybQVGsAxAbYgZzGKu+A1SasU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1213/1536] USB: cdc-acm: fix urb leak on disconnect
Date: Sat,  7 Nov 2026 08:53:49 -0500
Message-ID: <20261107135031.825636310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



