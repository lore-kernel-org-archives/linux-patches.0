Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037872;
	b=AqTSeEpQw14VgdcRbt/ZFFvJMM4nfBsoZa65kG5j+r4stmV8CpZB/pJSKq9Ea1tkYVP3
	 /GFY46rad5YATguA5uy1JXdUuKQ2D7wFRPwngoygepPdZinF+R9m1v9cN6gzOEPSArmJA
	 n9acE5xzXmyitT0iN0IhGdBmtkCi0LBjcBiCY7T1p5hPK+L/TRNv97i6LXfp2iIpgv7k8
	 XQWS2aC+twPG8D5VUvsk8Y7z6lKTZpAmZDdCAnb4RCqAvG2CkGEm+ohL9wpyQEr4JPhSE
	 io8Vde8SyiaDTsEYRpOXmGGjaJgtIjQlfsrz4+UNUlzaU9b9bUPlhH5luVLp9zwQofQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3pYcoI55c949zk37HJC/v/hzs7r1nTgrrUXX0BTLYBI=;
	b=gr44rmssu2IlxS8pZUsxRkGVMQ2TOB93gkkCUvME/IxerTz9OBZ4ShV8rU5B/QPDfIWN
	 sYnXwxHpMmMoVXCCaOd11M3DbWaWh7WtXm0fThNZaTu8TIl+HVamBFDS7oB8EDJHA8GXP
	 icMrKPBzvI8WopboZeY/zEog3ihY6FA6u9GjxCLfEIeYZlb+PAzxIKek3qRzoOV4ZeaJi
	 UGyFxztX5Lxnv/J2OLR2zXmIz8OjeNYxHmS+sHruJI8enV/ElGkGYhRGKfl2gO2Rl7aOz
	 GZTNzzGpeeJwuONurXKDCgAxeH7sgWdRpuBZuXInU9y4Bep2W2v3z/z1C068WE1RlDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tRi2ZV3M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F4D606A325;
	Wed, 18 Nov 2026 21:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tRi2ZV3M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1230A1F000C4;
	Wed, 18 Nov 2026 21:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037871;
	bh=3pYcoI55c949zk37HJC/v/hzs7r1nTgrrUXX0BTLYBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRi2ZV3MGzsIOHZ5XXoPWUBQc5nzrtNS0sZGse77BfvZ4WvdoaLjiEMIAUIkyWK8u
	 Q1KH68nnpQmzhxZRam6psfMWnjaPij1N7lFRauWUPPqRmJ4pc6JC1IfnN23uS8dUtE
	 n1fzCBgGh8MyW/RWKpXu2OSskLUymX/529/V2g/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1546/3318] ALSA: caiaq: free the EP4 URB when input setup fails
Date: Wed, 18 Nov 2026 15:36:08 +0100
Message-ID: <20261118150407.371559835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



