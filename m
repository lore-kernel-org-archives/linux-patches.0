Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AE012A17F;
	Tue, 23 Jan 2024 00:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968783; cv=none; b=hkew9BhSzp+sl0hbI0B7wglFXoQMGuaOK8jyZLFLJPWErAuUjEaNH5FGCTvgLfKqRnGuSqvPRXxq9eh6SA6a0DsSznKRO7DcFWleJvPUw1o2V0++yrjqSO9MlgH/bkQnvO6vgU7G0zhAOtlRp/KeWJwsnfc4Zw8m5FM89MddZpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968783; c=relaxed/simple;
	bh=es8+dCoBIJRSpq6NOc9mJ0xOOnNfMRc4ZCPvv7Hc4Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aekAKUvgr1P2BshLsAU8TwPyD0BLtGLfnp3u8PEJfWMVfa1eNH+gB7YKEFNmS+Dvg14e7JTfTuz96dpQ+/u2Ew1Ug3PIJWfWN+15w7TndGMuS2TF+pJy1kA0fwE0z5KcjUqwuwiyBLwyuWYVojPHTanSr6Og/NJlLOUK42kzHyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awIUjtcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awIUjtcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409F6C433F1;
	Tue, 23 Jan 2024 00:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968783;
	bh=es8+dCoBIJRSpq6NOc9mJ0xOOnNfMRc4ZCPvv7Hc4Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awIUjtcc81hy+HJySixEv3amqwD/0ec6KFV7Sb3VbiaP2MPyE496+A74tQpUZjWXl
	 v+81/7I9+Yh6HX1bcJqFpmOa6+XdbTzaPWxTw2x0oDw8Okk2xu+7qi1qdr1STUkm7v
	 n/ToBT3n2IcxG20CDieTD0kLcyhUzlhz0eVonLrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/194] powerpc/powernv: Add a null pointer check in opal_powercap_init()
Date: Mon, 22 Jan 2024 15:56:19 -0800
Message-ID: <20240122235721.306906945@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit e123015c0ba859cf48aa7f89c5016cc6e98e018d ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: b9ef7b4b867f ("powerpc: Convert to using %pOFn instead of device_node.name")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231126095739.1501990-1-chentao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-powercap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/opal-powercap.c b/arch/powerpc/platforms/powernv/opal-powercap.c
index dc599e787f78..0de530b5fead 100644
--- a/arch/powerpc/platforms/powernv/opal-powercap.c
+++ b/arch/powerpc/platforms/powernv/opal-powercap.c
@@ -196,6 +196,12 @@ void __init opal_powercap_init(void)
 
 		j = 0;
 		pcaps[i].pg.name = kasprintf(GFP_KERNEL, "%pOFn", node);
+		if (!pcaps[i].pg.name) {
+			kfree(pcaps[i].pattrs);
+			kfree(pcaps[i].pg.attrs);
+			goto out_pcaps_pattrs;
+		}
+
 		if (has_min) {
 			powercap_add_attr(min, "powercap-min",
 					  &pcaps[i].pattrs[j]);
-- 
2.43.0



