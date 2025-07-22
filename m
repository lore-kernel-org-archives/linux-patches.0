Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4341922CBE9;
	Tue, 22 Jul 2025 13:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192642; cv=none; b=GYcI6QJeBDJWN2S/00RA06MaaZzHfG0PlZE75TIGv443Pkk9jhYWKVU0u07tWy+oj6Sj2ibICEQlqIp8nwwqw4x7EvWaldppkDqtu8B6318QWL6m75rCJHx/jAso2DAX5doVWmNjyapg69Um1Yo4SGhsbZbyyW/DcCWjN6n6Yd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192642; c=relaxed/simple;
	bh=l9a8kPfeBFX6Bf/PQ1HZiOdgF6WTX+e0ULvzJa0zSKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YT5ExjN/0HZgg5+oySsEk0nxLur3i5ScdCuWkoWlK5A281pZVAWRVHwOEEhUWCvsLwmOpT53VZatURE5jKHOI3WFt3LC+SlOt7f3N5u7cvqUZWl8RvbaFrW/KcinpDlbgD4IGtJkCfqt/l+wPk+rknKKZyILVSP2ON6rARW1qWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clAvO0zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clAvO0zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D7BC4CEF7;
	Tue, 22 Jul 2025 13:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192641;
	bh=l9a8kPfeBFX6Bf/PQ1HZiOdgF6WTX+e0ULvzJa0zSKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clAvO0zfmCuixyhOoIVGYVdez5l9bJ2qHpGS1DX/CEhk5XDOkkGcnSQHoYmlLi98A
	 wiu6EmEQPCqAP+8948tgnCUDtNo+5I7m+d5/cGYFq0NDXq7bcC+90xlp5ID4gsIIsC
	 ud5dKu4G6BdoMW6nLvOQ0KQP5bPsRfybMWTOZNLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 015/158] nvmem: imx-ocotp: fix MAC address byte length
Date: Tue, 22 Jul 2025 15:43:19 +0200
Message-ID: <20250722134341.302305135@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Bätz <steffen@innosonix.de>

commit 2aa4ad626ee7f817a8f4715a47b318cfdc1714c9 upstream.

The commit "13bcd440f2ff nvmem: core: verify cell's raw_len" caused an
extension of the "mac-address" cell from 6 to 8 bytes due to word_size
of 4 bytes. This led to a required byte swap of the full buffer length,
which caused truncation of the mac-address when read.

Previously, the mac-address was incorrectly truncated from
70:B3:D5:14:E9:0E to 00:00:70:B3:D5:14.

Fix the issue by swapping only the first 6 bytes to correctly pass the
mac-address to the upper layers.

Fixes: 13bcd440f2ff ("nvmem: core: verify cell's raw_len")
Cc: stable@vger.kernel.org
Signed-off-by: Steffen Bätz <steffen@innosonix.de>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://lore.kernel.org/r/20250712181729.6495-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/imx-ocotp-ele.c |    5 ++++-
 drivers/nvmem/imx-ocotp.c     |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/nvmem/imx-ocotp-ele.c
+++ b/drivers/nvmem/imx-ocotp-ele.c
@@ -12,6 +12,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/if_ether.h>	/* ETH_ALEN */
 
 enum fuse_type {
 	FUSE_FSB = BIT(0),
@@ -118,9 +119,11 @@ static int imx_ocotp_cell_pp(void *conte
 	int i;
 
 	/* Deal with some post processing of nvmem cell data */
-	if (id && !strcmp(id, "mac-address"))
+	if (id && !strcmp(id, "mac-address")) {
+		bytes = min(bytes, ETH_ALEN);
 		for (i = 0; i < bytes / 2; i++)
 			swap(buf[i], buf[bytes - i - 1]);
+	}
 
 	return 0;
 }
--- a/drivers/nvmem/imx-ocotp.c
+++ b/drivers/nvmem/imx-ocotp.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/if_ether.h>	/* ETH_ALEN */
 
 #define IMX_OCOTP_OFFSET_B0W0		0x400 /* Offset from base address of the
 					       * OTP Bank0 Word0
@@ -227,9 +228,11 @@ static int imx_ocotp_cell_pp(void *conte
 	int i;
 
 	/* Deal with some post processing of nvmem cell data */
-	if (id && !strcmp(id, "mac-address"))
+	if (id && !strcmp(id, "mac-address")) {
+		bytes = min(bytes, ETH_ALEN);
 		for (i = 0; i < bytes / 2; i++)
 			swap(buf[i], buf[bytes - i - 1]);
+	}
 
 	return 0;
 }


