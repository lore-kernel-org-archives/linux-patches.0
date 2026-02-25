Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB82256C8B;
	Wed, 25 Feb 2026 01:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983439; cv=none; b=DQNemmH8WEKxOcaL/3TkWtsaJysXafD9PtymiB1n+WUSUj0ogz0jy4mjk1Np+iQ5u9DZTh97ZzjuByQt8fq0PupCiep0y+W6FHRdiIDH2Ui+YyQYXTiTjMO0Boi7HmNc+6/q+ZOwuGlh6+Qa7B19ePw2H3bp7Ss7KDVoRy95omE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983439; c=relaxed/simple;
	bh=RPv0st3Drw3tzHvdBWsH40GRQ1sO+FuoANcLyG9cDwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvBe+Yop+3iBUdVCNIZFz3sPr70mc537LN64KL9RrkizPsPOcDso6aORrG491pnQ3Lhsqjz5pFa7Oal1cf2rUQqqT54q+akKtP22qqzgjBv0//+aS6mDhGmJZm6NMPiSoYLS+C8vTt45kObuGvbkgg9SCRfVi7NTSOx35TnYmow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyWFEe/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyWFEe/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3391C116D0;
	Wed, 25 Feb 2026 01:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983439;
	bh=RPv0st3Drw3tzHvdBWsH40GRQ1sO+FuoANcLyG9cDwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyWFEe/OwwnIf7kbHtPEeK5FXjvCQGLWreMDzaKRg7UpRtBovX7MS3Bj9H4OVvlK8
	 xFkYn+UbdVr1tgdYG0vbnylEwjPCJnh2L6a1iG98uPxZsWHG/NevHE3H+M2j2j3P0+
	 2N+L4tzIUedQilSySI5bgDgpttlx0d9VNg3rxbHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 530/781] clk: rockchip: Fix error pointer check after rockchip_clk_register_gate_link()
Date: Tue, 24 Feb 2026 17:20:39 -0800
Message-ID: <20260225012412.800035328@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit a8d722f03923b1c6166d39482c6df8f017e185d9 ]

Replace NULL check with IS_ERR_OR_NULL() check after calling
rockchip_clk_register_gate_link() since this function
returns error pointers (ERR_PTR).

Fixes: c62fa612cfa6 ("clk: rockchip: implement linked gate clock support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://patch.msgid.link/20250805030358.3665878-1-linmq006@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk.c b/drivers/clk/rockchip/clk.c
index 2601df3b1066b..9ac9d13e87de0 100644
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -693,7 +693,7 @@ void rockchip_clk_register_late_branches(struct device *dev,
 			break;
 		}
 
-		if (!pdev)
+		if (IS_ERR_OR_NULL(pdev))
 			dev_err(dev, "failed to register device for clock %s\n", list->name);
 	}
 }
-- 
2.51.0



