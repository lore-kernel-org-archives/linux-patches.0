Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063029;
	b=ryNvgu8PI2yE0/Lx34lraWTPCEkyqmm0WAmHznO7BWlgG0Un/gAKjPIiGhmWWqJzMkrL
	 M8zXcEwUMNj3EUSqzkUQum8zj4cUtKV33c2rgI8Akr+cF7xwyQ3oWbI4Djcqwkj52fnaj
	 /MNyS1ISjb/ERjRXq0AyMJ8kNam74rKkq4sYw48JaTg/FQEvZA5e1WVqjqcIgRDwj0y1s
	 x1yE38QVgsoeiIAt67qlH/2bWx2Wg2n66NGJ+OnEr0yPNCS1c1gTc94wEgacKGE4ps/+k
	 XmJROLWILfmf2pk25rT6znMYuOUpiBe3bYb28/gcOMwWn1PQuFHfTlpu3+HO4JOEWAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RZ/49J9cVwaZ5pfpwi6+HDtzjnFPj338gjCGXJwyJ1Y=;
	b=kcENz7lz369VDgholQxlayaPOnnKLAVEwuarD/wduOawMHsjwQSHScBXF2wnqaE9FElz
	 smEPNklw+qYyj+x6+ptP9iwKgwWA2Fqu8xZ4Y2jR8m4zveGlFJkJd3EmpoY3I6b7dsksk
	 urgSl6dx8g+iuCegO127Na0G71iBpbi/gyGeCiGobXGZV0h0ch1X4viLymvceb4zyG3jn
	 wMuQltSLR6w4OZ1iZX5clA2irSRbNpm433P/9kqf5Zr8TwRW0/gZ3Hf97fg+E/DqlpKz3
	 4X9IpEkmVtoeWMy8d0fIDvrzpge+JKKaPp5RSx7Sls7sCZXVdZpvMYeJ4oao2oE/H9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vonCrxDU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C717606D802;
	Sat,  7 Nov 2026 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vonCrxDU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1611F0089F;
	Sat,  7 Nov 2026 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063029;
	bh=RZ/49J9cVwaZ5pfpwi6+HDtzjnFPj338gjCGXJwyJ1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vonCrxDUR+f7Ob/j4ZDK1vITKB6yxMIelGQnZ7itFXBE+tT7PdWu2+v5Y5HIMeT1V
	 rEeJaDcBfHlmj5toFAYdIgeQODox6svOjwoy3Ta9f7S6gnN4u729hjUcsLbVBtv1FI
	 999H4yanmWqKgXGs+u9IoGFaCYfC/xr2i8yJTYAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Costa <2000.costalucas@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 279/869] spi: bcm2835: fix device_node reference leak in bcm2835_spi_setup()
Date: Sat,  7 Nov 2026 08:49:21 -0500
Message-ID: <20261107134901.155447361@linuxfoundation.org>
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

From: Lucas Costa <2000.costalucas@gmail.com>

[ Upstream commit 8db44cca03df066186d6220bfad9fa482d7cdc13 ]

of_find_compatible_node() returns a device_node with its reference count
incremented, but bcm2835_spi_setup() only uses the return value to test
for a matching node in the loop and never releases it.

Declare the node with a scope-based __free(device_node) cleanup so the
reference is dropped automatically when leaving the loop body, matching
the existing __free(kfree) usage in the same function.

Fixes: e19c1272c80a ("spi: bcm2835: Restore native CS probing when pinctrl-bcm2835 is absent")
Cc: stable@vger.kernel.org
Signed-off-by: Lucas Costa <2000.costalucas@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260925193008.127314-1-2000.costalucas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 192cc5ef65fb7..61f70da3959e5 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1297,7 +1297,9 @@ static int bcm2835_spi_setup(struct spi_device *spi)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(pinctrl_compats); i++) {
-		if (of_find_compatible_node(NULL, NULL, pinctrl_compats[i]))
+		struct device_node *np __free(device_node) =
+			of_find_compatible_node(NULL, NULL, pinctrl_compats[i]);
+		if (np)
 			break;
 	}
 
-- 
2.53.0



