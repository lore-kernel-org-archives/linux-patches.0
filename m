Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046494;
	b=PkNoY/+0IubzvLaFO1mXuBviW+nuozO+fJmktomgZqfu90mOfDUGfRA6O3iRA+3scZtj
	 vQvDikn3O7BNu870c8LFYLiP9HJWJBOqlGZzFQlsChdgtchoGhtaLZ1rW+UPROAoRXSBa
	 5FzNiTZe4eY53W3IlunYB/2DXdfVUMVrWFhtVDXxGbTqUFuXnyGCgfz4CPxQUXEw2U5Of
	 a7r+Tn+5Yz+LOagpw03anXE7/fLKRUTKUHYxSZmj70/u1N3YTn08KZHdv5y0NwpeN5zZN
	 8HiuwxOlJVjbCyYNFSM2icfYURQ1KmC4pBWmwUAw8HSoi9haZRoQmzNIYCnD0cSO3hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qOoshTScYVtXNUCMItme82FoHB9gThoKM7d+1h9F3FI=;
	b=PSrnL3OYukNK7fKHyUuhNOU+nrszKJx5VCrAVhEPMXDTg3TZm6DIe6o13lq8UpTiHv4A
	 ACz4oqP99C2NvW/g3cMB80gGe1c9O96vRjKiXzBYs0wAvlpQE/DS8D/vlbjYegj383vFN
	 zLxGQbe+993C3mld205dIIhpDYoJwQTiyUS8wrl/d0GO16jjPImUIS8u+WjrQ7oeVmZ79
	 IdILKasfniU2drGOhV2QX83p2c0tySSpPS5WI0gS11h+t4fck6Vau9S9tgVs5llbpL1bs
	 aVzxdMH+xDkypYn1EXFHM29vJP/12N15LiK1PMGnBgMTCFTtjRQVcbaC6Hiuwmph3vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcFfbBs8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97341606A320;
	Thu, 19 Nov 2026 00:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcFfbBs8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87FD1F000C4;
	Thu, 19 Nov 2026 00:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046494;
	bh=qOoshTScYVtXNUCMItme82FoHB9gThoKM7d+1h9F3FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lcFfbBs8gGIr7fbwRbJo7fB4QShz70vzs5M8tXwsWJ98RZBLzLhbLHI57Z5YT6X3F
	 2QGahm7QKkgG/eo+Hy+Q9GGHV3eH7JFP1zcRI/HN7HknWEHlX3qGoyoIBkiXxWO3VM
	 MgwejN6ekS1XnwRHYxFoj+9ZQEsST08FHE8s34QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1302/2857] ALSA: caiaq: free the EP4 URB when input setup fails
Date: Wed, 18 Nov 2026 15:38:56 +0100
Message-ID: <20261118150248.355426035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit d21746bafdb8e1a5fc9bdcb86f603d827a500a62 ]

The three controllers that use the EP4 input URB allocate it before
checking the endpoint type and before registering the input device. On
failure they jump to exit_free_idev, which clears cdev->input_dev but
leaves cdev->ep4_in_urb set. The card teardown then calls
snd_usb_caiaq_input_free(), which returns early because input_dev is
NULL, so the URB is never freed.

Release the URB before dropping the input device on the error path.

Fixes: 6da7a2aa899f ("ALSA: usb/caiaq: Add support for Traktor Kontrol X1")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20261104025341.1527407-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index c12eeb9710002..6a5adb8d1e6a7 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -830,6 +830,8 @@ int snd_usb_caiaq_input_init(struct snd_usb_caiaqdev *cdev)
 	return 0;
 
 exit_free_idev:
+	usb_free_urb(cdev->ep4_in_urb);
+	cdev->ep4_in_urb = NULL;
 	input_free_device(input);
 	cdev->input_dev = NULL;
 	return ret;
-- 
2.53.0



