Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829193;
	b=VjzOX+ICeBMpisFHmHxHjq+O8zJAoGnVdoQpY1EhoKjCWVoEogjERHOCol7h/IpgiNZn
	 m2NRK7cogRSthqsgQQeaDqfzdUaMHyfg3yQeLwQNmyNHI6RWlo8rP0kmYAL664G85ywmL
	 3NCVE0yAZTq+VvWPLMFjbIuv6xDkp0ROFzPocomrLrmLD/t1ylrCCQzio5jjMl+xX0IRx
	 UTag8XXHTrKjAwGlYlIM97OWrB7ZraeAy6XBG2q20sAp0knokSzvDDXnYRilges31sZ2S
	 IKLsALmTPv4ags5T4LF575tes3Iya75UK4DFIvW5c+4IkPvpgOLp4Guq5fi18G4UQWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QJ5scyZqIEGSKD2drMNnfFlOEuj4K/I9xIcJ67pYPfo=;
	b=Ayd+Ow9nvc96pXak88nje6cJwgye4bQ9ytdVIj6KANLS4MhPfxN8cu50h6jbRomPL7yb
	 ZpPGFwQ7//dvh3VpEOZZQg+e1O2zvmIx2l+09beqcHmY2psulQqe+st9sbN03zVSdcQuL
	 +p2G8/bQx/ABw5rTuQ2KHydtmtZxj88m3g1Hw2I9buP7G3nbSNpw+IOh2nLdWPrLE8Hu3
	 SikC9O6BP11OXFFNUoY3JKLzWoovSYmBo2xEZ4Tqdv0Dk26NXyRN1W+vpbrGuNnnnLVkZ
	 R5vYW19Iq30vmiZYHUob4VsvUsQL6p84q0aM3xni1eToMqPNbTSLvXSwdXTmHebmX0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e93YQSus;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2423F606D83C;
	Wed,  4 Nov 2026 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e93YQSus
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC651F00919;
	Wed,  4 Nov 2026 21:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829192;
	bh=QJ5scyZqIEGSKD2drMNnfFlOEuj4K/I9xIcJ67pYPfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e93YQSus4fBf9PuTePiFVIIodRVvvj2sAMxSOzob1426iqQx8TjZ1Kj0zSa3Waz9Y
	 yTXSdeAtUmzZ7t4gNPPaXNufAHxis1izUUB3QHeN57zxRO0XGUIW6gpGjDGSVQtovD
	 ATWIhEJUmkDc7K0HZSg8K7NdVQza9Kf9UeSXhii0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 7.3 504/547] HID: roccat: pyra: reject short button reports
Date: Wed,  4 Nov 2026 16:11:28 -0500
Message-ID: <20261104211052.710577074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 493268f459bb6aeeecbc77f2204c11ad74d05213 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct pyra_mouse_event_button for button reports.  A truncated
report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: cb7cf3da0daa ("HID: roccat: add driver for Roccat Pyra mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-pyra.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -557,6 +557,9 @@ static int pyra_raw_event(struct hid_dev
 	if (pyra == NULL)
 		return 0;
 
+	if (size < sizeof(struct pyra_mouse_event_button))
+		return 0;
+
 	pyra_keep_values_up_to_date(pyra, data);
 
 	if (pyra->roccat_claimed)


