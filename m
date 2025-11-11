Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F27345CD8;
	Tue, 11 Nov 2025 01:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824747; cv=none; b=JAwhFI0FMU+OP4cMdvqxA9VlnoZrplXa2o8e0XpyLMZDaPXUWxJQczjwgt+hsIs996zMbKXPix5kR1xUKUdP/5xpMZNmfaB4mNoQhaKG1NKl0+C0FTp6S36FZebfzOBqrAVTVgvc8nlqLeuGBB2yzr1KjgdJBq2tbStatG7xQP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824747; c=relaxed/simple;
	bh=jt5T2BRQl0TPSX5oeqohz1WnWveXXIjZtE+FnjGNzuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1xYKqW8QxNYz5Ow43YOPzHk12fSUaVBi+htpRSZDVIFwMcObEBRiKSCKVi1RwvbNYyGb+WH+maMxQ9qmd27dsPM/ZmeAK0d8AePUK/nYsD446glCSouyb6UAyztpl8AnpkOb6TUkAD8jjW1kjmx+Jd4B2HfXyHslkmCqA3RlnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ck/9DW9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ck/9DW9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6459EC4CEF5;
	Tue, 11 Nov 2025 01:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824747;
	bh=jt5T2BRQl0TPSX5oeqohz1WnWveXXIjZtE+FnjGNzuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ck/9DW9szEmlAd1B4kZdgam4/9Rt8MBrWpaMs0RByJTyMEYz0HCp8DYc6c4jjLsEg
	 /70ZjWrqwmSVxmeLQ2Gr4utNVWUBjIctX6tRH4zwCV2EJNQHhJd2D8WG/WudZabNF1
	 rGEOMZkeZhmVdkscA3nLsw7UGGBgbzeXcK/4STU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 562/849] ethernet: Extend device_get_mac_address() to use NVMEM
Date: Tue, 11 Nov 2025 09:42:12 +0900
Message-ID: <20251111004550.000233754@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit d2d3f529e7b6ff2aa432b16a2317126621c28058 ]

A lot of modern SoC have the ability to store MAC addresses in their
NVMEM. So extend the generic function device_get_mac_address() to
obtain the MAC address from an nvmem cell named 'mac-address' in
case there is no firmware node which contains the MAC address directly.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250912140332.35395-3-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethernet/eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 4e3651101b866..43e211e611b16 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -613,7 +613,10 @@ EXPORT_SYMBOL(fwnode_get_mac_address);
  */
 int device_get_mac_address(struct device *dev, char *addr)
 {
-	return fwnode_get_mac_address(dev_fwnode(dev), addr);
+	if (!fwnode_get_mac_address(dev_fwnode(dev), addr))
+		return 0;
+
+	return nvmem_get_mac_address(dev, addr);
 }
 EXPORT_SYMBOL(device_get_mac_address);
 
-- 
2.51.0



