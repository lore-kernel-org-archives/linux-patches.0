Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E86547CA85;
	Sat, 12 Sep 2026 13:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219751; cv=none; b=px3td3QUdYTcOHdMtC/ZVel973PaaWHPzRweuXjqWWvGgXKjl8moTQg/OdH3d91qmZmrra3/KM/1uqOqSdgWpQ8APQsXwGpHvl0vdB/LpeZOHI4KHSm/vbcb1EqPuCVfId+1JrUsPkjhfRPqk7MTOKh6N4WDH92Zsa2YR5Liz18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219751; c=relaxed/simple;
	bh=Qio1M1/r+s+s0ig9lA0X2LxAm9e9rsCBBzlqnpKzVbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvFAU0oTOZFgF3rGLxjwvvAICT7q4QAyNY7FMpWVZyWzu8HmstfxwWEGEhbRbzYk4HBdDMjGS2R1hp9ZHWhPcaAqmaUvGrI5kFeX2qi/Y1EpBn+acry4OpOq+vTcP8mAnAOPe0rzdmy28Wy1pIfo7m5mUmAf8hQF3v3aAmGvqMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6+OvudZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6+OvudZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C60E1F000FF;
	Sat, 12 Sep 2026 13:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219750;
	bh=eFUtemKWTpQXtdlHFBdibV4c7OEjhOXcVl9TGQjSyR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6+OvudZ5o6dXTkFfgR4GoP42GM6VW4LA8u93Jn2RE5T+3L7ntFELZxaDppBbK6UY
	 SLZsowx9teNq0uUBKsfHc7Dqx3nPg30v85CQiQ/8ScICNfQ6Ee8/pAhzFqBdMeAN7n
	 J0LXmjZzZMqD9cRutOHnSBAk+5ksmIlxsaRYp+b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daisuke Matsuda <matsuda@preferred.jp>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.6 0038/1424] fpga: altera-cvp: Avoid out-of-bounds read in trailing byte write
Date: Sat, 12 Sep 2026 08:41:10 +0200
Message-ID: <20260912065608.157555907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daisuke Matsuda <matsuda@preferred.jp>

commit 9da70a43b5fea60d758137f7f0ccfe19356cb5bb upstream.

The trailing byte path in altera_cvp_send_block() dereferences a u32
pointer even when only 1-3 bytes remain in the input buffer. If the buffer
ends at a page or scatterlist boundary, this can read past the valid image
data and fault.

Copy the remaining bytes into a zero-initialized u32 before writing the
final word so only valid bytes are read from the input buffer.

Fixes: 34d1dc17ce97 ("fpga manager: Add Altera CvP driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daisuke Matsuda <matsuda@preferred.jp>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260723081912.74082-1-dskmtsd@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/altera-cvp.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/fpga/altera-cvp.c
+++ b/drivers/fpga/altera-cvp.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/sizes.h>
+#include <linux/string.h>
 
 #define CVP_BAR		0	/* BAR used for data transfer in memory mode */
 #define CVP_DUMMY_WR	244	/* dummy writes to clear CvP state machine */
@@ -265,7 +266,7 @@ static int altera_cvp_v2_wait_for_credit
 static int altera_cvp_send_block(struct altera_cvp_conf *conf,
 				 const u32 *data, size_t len)
 {
-	u32 mask, words = len / sizeof(u32);
+	u32 words = len / sizeof(u32);
 	int i, remainder;
 
 	for (i = 0; i < words; i++)
@@ -274,9 +275,10 @@ static int altera_cvp_send_block(struct
 	/* write up to 3 trailing bytes, if any */
 	remainder = len % sizeof(u32);
 	if (remainder) {
-		mask = BIT(remainder * 8) - 1;
-		if (mask)
-			conf->write_data(conf, *data & mask);
+		u32 word = 0;
+
+		memcpy(&word, data, remainder);
+		conf->write_data(conf, word);
 	}
 
 	return 0;


