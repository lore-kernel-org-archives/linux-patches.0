Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3219230E829;
	Sat, 30 May 2026 17:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161496; cv=none; b=qvJBAQBxgxJyYHSHVTkrB1tDbZdfEvhZEeJdpg2WdGm3Z0CXbVKYnyit68gTFumCBiI3YzjIiUU1en5/aZLC46wu3mfgcYcUewLTztzgS4wUWVIrr+BuXlGQUHEwmvHoOZhTYZDlZZg7Cf6dOvFxKnU2DkEXL2P7fojwSQSVXZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161496; c=relaxed/simple;
	bh=hhEivLXrgi8QxiMLeXIUvmZvqbUbtzWRtmbte63PWOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoKCy/s5X9qgZa4QLQa9TapTrV6zqgmTUkglZHWgtcHR2OVnfhvxvA0z0l/Pn4h3qw1mQKrXTwkhhpWvuc6P8511YWiYP1GR7V6Qdv38rY+iKAvUc4Iq/LsFYct4hTv+C2Gbdq6Bp02jYSWJL99d54Pf/vZhHj8t41w5gjK9P84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUjOUQ8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUjOUQ8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA6C1F00893;
	Sat, 30 May 2026 17:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161495;
	bh=nziOOc+nqFU3j2pD7OO+SD7D7fV8FP9l2CKh0lhsUjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uUjOUQ8/21uq4jQD/3YC7o6YOjeNIujWlUBDdPYpvJLG9d1TcbasvsFFHZRfZjV1p
	 KDYJ+V1cvWjO5G6gfWu3laSF6o4f1EdOKtbBhu9Gnkmy1mk/JgNYRzDww4LMk3WoXb
	 3Ow3r3xtVCth86hU0spyS6daXkKM+ssTJfYb5oNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 641/969] tty: hvc_iucv: fix off-by-one in number of supported devices
Date: Sat, 30 May 2026 18:02:45 +0200
Message-ID: <20260530160318.156082117@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit f2a880e802ad12d1e38039d1334fb1475d0f5241 ]

MAX_HVC_IUCV_LINES == HVC_ALLOC_TTY_ADAPTERS == 8.
This is the number of entries in:
  static struct hvc_iucv_private *hvc_iucv_table[MAX_HVC_IUCV_LINES];

Sometimes hvc_iucv_table[] is limited by:
(a)	if (num > hvc_iucv_devices) // for error detection
or
(b)	for (i = 0; i < hvc_iucv_devices; i++) // in 2 places
(so these 2 don't agree; second one appears to be correct to me.)

hvc_iucv_devices can be 0..8. This is a counter.
(c)	if (hvc_iucv_devices > MAX_HVC_IUCV_LINES)

If hvc_iucv_devices == 8, (a) allows the code to access hvc_iucv_table[8].
Oops.

Fixes: 44a01d5ba8a4 ("[S390] s390/hvc_console: z/VM IUCV hypervisor console support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260130072939.1535869-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvc_iucv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index 7d49a872de48a..9551269e106a4 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -130,7 +130,7 @@ static struct iucv_handler hvc_iucv_handler = {
  */
 static struct hvc_iucv_private *hvc_iucv_get_private(uint32_t num)
 {
-	if (num > hvc_iucv_devices)
+	if (num >= hvc_iucv_devices)
 		return NULL;
 	return hvc_iucv_table[num];
 }
-- 
2.53.0



