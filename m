Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E098F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4707EC433C8;
	Sun, 16 Jul 2023 20:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538783;
	bh=Z7FqE+dNtUks2C40lAWap4JAMGa2mWZpEKcEUP9fDJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G462JHF/lzdQuXAzM88fjSY9obCfZIFWyDdd7HJFamr9pmtaTwyXpPh3TakARMKqL
	 c2cljiHC+qsxPJFDNhOMqtSYji0Cxlmb1Vi6Ulx1AcM1VmsNIkDLNpZdjtYDbCWU96
	 /w0pdn8JIIhJceNYWo5vH9swgrDPX1TD4XAZvp3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 575/800] media: renesas: fdp1: Identify R-Car Gen2 versions
Date: Sun, 16 Jul 2023 21:47:08 +0200
Message-ID: <20230716195002.440750920@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 59a95979638664a905cd46845e7cac1b3ff942f7 ]

On R-Car M2-W:

    rcar_fdp1 fe940000.fdp1: FDP1 Unidentifiable (0x02010101)
    rcar_fdp1 fe944000.fdp1: FDP1 Unidentifiable (0x02010101)

Although the IP Internal Data Register on R-Car Gen2 is documented to
contain all zeros, the actual register contents seem to match the FDP1
version ID of R-Car H3 ES1.*, which has just been removed.
Fortunately this version is not used for any other purposes yet.

Fix this by re-adding the ID, now using an R-Car Gen2-specific name.

Fixes: af4273b43f2b ("media: renesas: fdp1: remove R-Car H3 ES1.* handling")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/rcar_fdp1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/renesas/rcar_fdp1.c b/drivers/media/platform/renesas/rcar_fdp1.c
index f43e458590b8c..ab39cd2201c85 100644
--- a/drivers/media/platform/renesas/rcar_fdp1.c
+++ b/drivers/media/platform/renesas/rcar_fdp1.c
@@ -254,6 +254,8 @@ MODULE_PARM_DESC(debug, "activate debug info");
 
 /* Internal Data (HW Version) */
 #define FD1_IP_INTDATA			0x0800
+/* R-Car Gen2 HW manual says zero, but actual value matches R-Car H3 ES1.x */
+#define FD1_IP_GEN2			0x02010101
 #define FD1_IP_M3W			0x02010202
 #define FD1_IP_H3			0x02010203
 #define FD1_IP_M3N			0x02010204
@@ -2360,6 +2362,9 @@ static int fdp1_probe(struct platform_device *pdev)
 
 	hw_version = fdp1_read(fdp1, FD1_IP_INTDATA);
 	switch (hw_version) {
+	case FD1_IP_GEN2:
+		dprintk(fdp1, "FDP1 Version R-Car Gen2\n");
+		break;
 	case FD1_IP_M3W:
 		dprintk(fdp1, "FDP1 Version R-Car M3-W\n");
 		break;
-- 
2.39.2



