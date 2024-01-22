Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3BE60DE3;
	Tue, 23 Jan 2024 00:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970969; cv=none; b=TuOxZ0mCVlkEcGceLKfZtT1eDndtA/kt8AmvMHP/8DahthxmF/9h2g31QdinFjsFuxST+Ow5im1jR4yCiTaD7DCL8GzHQ9fV8rDZAx9+fOGB1bMWlAh/9VS7dyU1ikunnhHkSH1WoaHXwjXFKuFh8htO8fSRu+FVwt+yrXNzaNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970969; c=relaxed/simple;
	bh=gXE26gBYhVIS+YRZMRkKVcnnvWZ2nEZu/cv3wtQ9XeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSh1fB1zM12XMslBnATmFvAsp0Rk+IpzK75IA1iTu/zcFhujOmrkzAKgjbG8qxteEcYvL3oTKPAVFLpf/BfMlDezuFP3uRLCidNw0E0geUVLUxs3m80SEJHbXdx1xARRgwoi3+DJ4LwEYNCrz1j5uUO+KM6HVjrby9XZr+Wo3js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvGtX3A5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvGtX3A5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E786C433C7;
	Tue, 23 Jan 2024 00:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970969;
	bh=gXE26gBYhVIS+YRZMRkKVcnnvWZ2nEZu/cv3wtQ9XeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvGtX3A5tHMwa4kwVJncn1nYg5tQsoiDYG/mTs+em4ed6mKq2aFb5Xdyg+taAqHCH
	 g/PWgfFBxHSU1H4g9SqEXxarRnLwqs4sk+Hs0qJ3GxiXf1TJg/lEzTG3ExNL43Imu3
	 dMIxDAEtdAuNe29BT9PagTiL+DxJat4W7V7o2mXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/286] powerpc/powernv: Add a null pointer check in opal_powercap_init()
Date: Mon, 22 Jan 2024 15:56:05 -0800
Message-ID: <20240122235734.303716581@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c16d44f6f1d1..ce9ec3962cef 100644
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



