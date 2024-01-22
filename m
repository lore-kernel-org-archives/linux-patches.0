Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E19131E32;
	Tue, 23 Jan 2024 00:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969095; cv=none; b=jb5i03eNVWge9EBiUOnFxoPrqBqsbqNv1GmxeC2HFxZYSc5AYUWIfbxmfxbAxtLGKN79a3/sKowAqHJeGftQW98Ez/coVEAibboDuv8lOMJSqy9GFlaTV2jrztnDveK0WRa7cs8KzGVnIvcAWURlc10+g2tamKWgbAZRV4wRuyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969095; c=relaxed/simple;
	bh=YpoxdTOPlskoqb1bipc71e0NEIuJnA7U5bgTfR8RaFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeVeZ8ACi9DR9xaXjJH2ZsPK7eM3RaSfuzPKkc0vJ7cMDrsl9p0UCrP2Eq1PqN47odiEseIk/CSwKSP/CGbZ4Fby2TDcyS3Jg7R0cNSI9LH0q0GbXeSOJqtPNV6+5IMqwGd+09AQ8hh9Oeu1BX6vPnDC7c1RVhppCjwqNoEZiWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSzo1j0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSzo1j0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BFAC43390;
	Tue, 23 Jan 2024 00:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969095;
	bh=YpoxdTOPlskoqb1bipc71e0NEIuJnA7U5bgTfR8RaFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSzo1j0jXVDERsuRSGIb71TVR2hstW1xM3BTW4VOkT+1LnB8YJZerVmCSuoXPTAfu
	 kSyrkORfxTKuwY8E/YNwNvxyzdn+VWF+7KUaZYGuZirg+TJ4XsBYnl0HXmMJfsZKms
	 fYVX3kWyDIi/dq097ehF84awccnKD/N5bJtNxetw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 018/641] powerpc/powernv: Add a null pointer check in opal_powercap_init()
Date: Mon, 22 Jan 2024 15:48:42 -0800
Message-ID: <20240122235818.675997783@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 7bfe4cbeb35a..ea917266aa17 100644
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



