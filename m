Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48F13EEAC7;
	Tue, 21 Jul 2026 19:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661217; cv=none; b=sgxMkLT8R5SYYk/VBmZrG62L36Ia5QYQsuQxxMFHUu6V6cSvaMDqryu+JHak1jzGSVZo2+YGqmsbsnlGrSQEyLZUe2C4cGMI12UmBt1pTO1nFePttHlUuBjQBIyu872qotha/cLeCxZ/eUra+UmLHzYSx72e6Kk+QYuuLrdx3BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661217; c=relaxed/simple;
	bh=bjkZB3hw6hxS1Tql74WFRVL7n7jrvUp/iY2bAyy4kKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGgyLY14bAhTcj82fA95y6IJEgIr584haFypg+rvqmzMLWMg0/wXNLqF6bM6vHulHFZUYi5PippOTl1X4/s4YOEXW7MyvCTt9wIhSw5vPugolhPk50vmRllShnCCAJ1MPjNFHMXIXHDj6uVfkttvJbfW2+MbTtCi9mcg7QiNOuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OR19X7Ox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OR19X7Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E1F1F000E9;
	Tue, 21 Jul 2026 19:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661216;
	bh=WRrasqAbU43G3k8ha12fV6C60yGNNPt4LPjMz9C3f/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OR19X7OxJVutCbEZTmMvs1nJNQ7yAQUTNkXl9xGA6PTQ2yiACS0teVcCilsOcctAe
	 010CiHZQjHTMAsbzCHM6O1dpJXnJU6sOgqniHSOSMG77CnhmSzNMal6SJXwFlJrGnf
	 VZMY5fBxnYdguXNGYAbwngylsL1r1r9G8wCqK8Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1274/2077] net: dsa: mxl862xx: avoid unaligned 16-bit access in api_wrap
Date: Tue, 21 Jul 2026 17:15:47 +0200
Message-ID: <20260721152622.868111462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 6b3f7af57881f6d6250c6dcc4d910fe8e855a607 ]

The MXL862XX_API_* macros pass the address of a stack-allocated, __packed
firmware-ABI struct to mxl862xx_api_wrap() as a void *. The struct has an
alignment of 1, so the compiler is free to place it at an odd address.

mxl862xx_api_wrap() reinterprets that buffer as a __le16 * and accesses it
with data[i], for which the compiler assumes the natural 2-byte alignment
of __le16 and emits aligned 16-bit loads/stores (e.g. lhu/sh on MIPS).
When the buffer lands on an odd address these fault on architectures that
do not support unaligned access, such as MIPS32.

-Waddress-of-packed-member does not catch this: the packed origin is
laundered through the void * parameter, so the cast inside api_wrap looks
alignment-safe to the compiler and no warning is emitted.

Use get_unaligned_le16()/put_unaligned_le16() for the three 16-bit word
accesses. The byte accesses (*(u8 *)&data[i], crc16()) are already safe
and are left unchanged.

Link: https://sashiko.dev/#/patchset/cover.1781319534.git.daniel%40makrotopia.org?part=4
Fixes: 23794bec1cb6 ("net: dsa: add basic initial driver for MxL862xx switches")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/599327521db465a534d277de53ab9b6cac01928b.1781702256.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mxl862xx/mxl862xx-host.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mxl862xx/mxl862xx-host.c b/drivers/net/dsa/mxl862xx/mxl862xx-host.c
index d55f9dff6433e4..882c5d9609418c 100644
--- a/drivers/net/dsa/mxl862xx/mxl862xx-host.c
+++ b/drivers/net/dsa/mxl862xx/mxl862xx-host.c
@@ -12,6 +12,7 @@
 #include <linux/crc16.h>
 #include <linux/iopoll.h>
 #include <linux/limits.h>
+#include <linux/unaligned.h>
 #include <net/dsa.h>
 #include "mxl862xx.h"
 #include "mxl862xx-host.h"
@@ -349,7 +350,7 @@ int mxl862xx_api_wrap(struct mxl862xx_priv *priv, u16 cmd, void *_data,
 	 * zero words individually.
 	 */
 	for (i = 0, zeros = 0; i < size / 2 && zeros < RST_DATA_THRESHOLD; i++)
-		if (!data[i])
+		if (!get_unaligned_le16(&data[i]))
 			zeros++;
 
 	if (zeros < RST_DATA_THRESHOLD && (size & 1) && !*(u8 *)&data[i])
@@ -395,7 +396,7 @@ int mxl862xx_api_wrap(struct mxl862xx_priv *priv, u16 cmd, void *_data,
 			 */
 			val = *(u8 *)&data[i] | ((crc & 0xff) << 8);
 		} else {
-			val = le16_to_cpu(data[i]);
+			val = get_unaligned_le16(&data[i]);
 		}
 
 		/* After RST_DATA, skip zero data words as the registers
@@ -453,7 +454,7 @@ int mxl862xx_api_wrap(struct mxl862xx_priv *priv, u16 cmd, void *_data,
 			*(uint8_t *)&data[i] = ret & 0xff;
 			crc = (ret >> 8) & 0xff;
 		} else {
-			data[i] = cpu_to_le16((u16)ret);
+			put_unaligned_le16((u16)ret, &data[i]);
 		}
 	}
 
-- 
2.53.0



