Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDB120B02
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pT8yLGLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC0AC433C7;
	Wed,  4 Oct 2023 18:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444320;
	bh=kaPTba2NDkc1pzgOVXQpVUKm2nw7JkFZfQ/ZcEV6R80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pT8yLGLdSZjcgXDmqjVvvZYktCRhvt30m5D1txV85W0EDpR3nhopzrBKR+r1zQE2m
	 wTTU1Nz+bihkh7M1pxWFUBXYZ6QB9VauOOZl5J42Tz7MuCNJsGtWDHcns5duIx1I1U
	 U+Y+vw2GwOLtcB7j/hSXp/vSml9rOoOMMksw6Hvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 181/321] ata: sata_mv: Fix incorrect string length computation in mv_dump_mem()
Date: Wed,  4 Oct 2023 19:55:26 +0200
Message-ID: <20231004175237.614471991@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e97eb65dd464e7f118a16a26337322d07eb653e2 ]

snprintf() returns the "number of characters which *would* be generated for
the given input", not the size *really* generated.

In order to avoid too large values for 'o' (and potential negative values
for "sizeof(linebuf) o") use scnprintf() instead of snprintf().

Note that given the "w < 4" in the for loop, the buffer can NOT
overflow, but using the *right* function is always better.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_mv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index d404e631d1527..68e660e4cc410 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1255,8 +1255,8 @@ static void mv_dump_mem(struct device *dev, void __iomem *start, unsigned bytes)
 
 	for (b = 0; b < bytes; ) {
 		for (w = 0, o = 0; b < bytes && w < 4; w++) {
-			o += snprintf(linebuf + o, sizeof(linebuf) - o,
-				      "%08x ", readl(start + b));
+			o += scnprintf(linebuf + o, sizeof(linebuf) - o,
+				       "%08x ", readl(start + b));
 			b += sizeof(u32);
 		}
 		dev_dbg(dev, "%s: %p: %s\n",
-- 
2.40.1



