Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B32D33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BB7C433EF;
	Mon, 16 Jan 2023 15:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884474;
	bh=PmeZbxQ+6S4uH9vuvSdYM118QIROdsv0FbagLLAYx5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVVyQ4Ac+lVIJw3j6u304a/ckp0Qq3CpYJz2DCrVGDssWEqpB6SLCXTn2QgEj+Awn
	 Z99hMMmwjDsxQORbGhfo1C16TKoFjvB6KIWdJIRzszeyO/s5VkgAzJZtqphYfO7z/q
	 MyGlbbxEN3zr6+d2mMDfPmv2qUDNGLy+O6VMLOYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Hector Martin <marcan@marcan.st>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 020/183] brcmfmac: Prefer DT board type over DMI board type
Date: Mon, 16 Jan 2023 16:49:03 +0100
Message-Id: <20230116154804.257378726@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ivan T. Ivanov <iivanov@suse.de>

commit a5a36720c3f650f859f5e9535dd62d06f13f4f3b upstream.

The introduction of support for Apple board types inadvertently changed
the precedence order, causing hybrid SMBIOS+DT platforms to look up the
firmware using the DMI information instead of the device tree compatible
to generate the board type. Revert back to the old behavior,
as affected platforms use firmwares named after the DT compatible.

Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")

[1] https://bugzilla.opensuse.org/show_bug.cgi?id=1206697#c13

Cc: stable@vger.kernel.org
Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
Reviewed-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Tested-by: Peter Robinson <pbrobinson@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index a83699de01ec..fdd0c9abc1a1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -79,7 +79,8 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	/* Apple ARM64 platforms have their own idea of board type, passed in
 	 * via the device tree. They also have an antenna SKU parameter
 	 */
-	if (!of_property_read_string(np, "brcm,board-type", &prop))
+	err = of_property_read_string(np, "brcm,board-type", &prop);
+	if (!err)
 		settings->board_type = prop;
 
 	if (!of_property_read_string(np, "apple,antenna-sku", &prop))
@@ -87,7 +88,7 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 
 	/* Set board-type to the first string of the machine compatible prop */
 	root = of_find_node_by_path("/");
-	if (root && !settings->board_type) {
+	if (root && err) {
 		char *board_type;
 		const char *tmp;
 
-- 
2.39.0



