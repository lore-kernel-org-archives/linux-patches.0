Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB18D1D1512;
	Tue, 15 Oct 2024 12:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993639; cv=none; b=g3TQCxSjgiMTx7P+ZwMmY1KOZDUJSeFhHPx+MKrvi3Zej2yy+t5pKIF9NrfmL3dMEsPAB17LOEbAIZJtKQ6czf8FMf/f0ZTXI56oA4C/Zp7rIBSY9tLx0M1EDmXMHLSAPcSD7+cj+dnVtmDKN7FGbVHor0YBZK2R+XNmN4NicQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993639; c=relaxed/simple;
	bh=fKpWOQANyYnHRxwCLDwIK7epRJ7trwX7dTitKjPWSOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOeu0EqtQNC0TecTD8snvWl5ELbHSZN+MerL4p7y1LibEvg8CMbWXLC1ZWKduR7CjRlhMyrYG5ZGXN7NSreWKE7UAU9k9Htb0mbHMDw21FU6TbxAqrXmHkSuFITPo5Kc01D/zDGpuQF2z1HhvHjxiyRGDewUXyT4hl+IR7O2RxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMeQPb3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMeQPb3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2B9C4CEC6;
	Tue, 15 Oct 2024 12:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993639;
	bh=fKpWOQANyYnHRxwCLDwIK7epRJ7trwX7dTitKjPWSOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMeQPb3Ek/hnen7p3b+N3irRDwZo1wYJo6+8vQCuUuLkiCLXv/9ItRd9QOdU/N/Xa
	 mw+CvTJKogW7qlGgAS79rwAA5703ZvgXjCSWuvpVB1YZ7cmYCK53Gdd6mFEY3sWa9H
	 3qbbswxeHdWpp3pANuL5jM4/jGBMTEumg+uxWk3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 471/691] of/irq: Refer to actual buffer size in of_irq_parse_one()
Date: Tue, 15 Oct 2024 13:26:59 +0200
Message-ID: <20241015112459.038321589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 39ab331ab5d377a18fbf5a0e0b228205edfcc7f4 ]

Replace two open-coded calculations of the buffer size by invocations of
sizeof() on the buffer itself, to make sure the code will always use the
actual buffer size.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/817c0b9626fd30790fc488c472a3398324cfcc0c.1724156125.git.geert+renesas@glider.be
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index ad0cb49e233ac..70ac9cb3b2c67 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -301,8 +301,8 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
 	addr = of_get_property(device, "reg", &addr_len);
 
 	/* Prevent out-of-bounds read in case of longer interrupt parent address size */
-	if (addr_len > (3 * sizeof(__be32)))
-		addr_len = 3 * sizeof(__be32);
+	if (addr_len > sizeof(addr_buf))
+		addr_len = sizeof(addr_buf);
 	if (addr)
 		memcpy(addr_buf, addr, addr_len);
 
-- 
2.43.0



