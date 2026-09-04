Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9254C3A6B82;
	Fri,  4 Sep 2026 05:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498602; cv=none; b=BfBHzLyCkzr+nsU6zfHTJ4ioNlHrz/WWxmOoZDWRBBVYLdDFdFc49eBTwrUkbHHAQ6YGsJ7uBm/um7E4f8C0uhrdyPkAcmSKTqt9LzWDmcKBtXkHyNWAqxtSjWP6f2XZszzOKSeeLySUvU4e+BjA9e9NUbuUng1BJvFxMbNbFOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498602; c=relaxed/simple;
	bh=bhQnuZM2NIOvFB5fG7GRBlZxQu9voYISxq0nj6ELB+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQEJ7iK5dg0a+9Ql9YU8wEHJsHOUwBIivqH51Sa+WtqcYK3yTvx8G0kVqV3RRkUY/+7VzGsGvqa5QWKcgvolXNZQdHqlDP4EO7lM/qltbVZ+gVgN1q0B7w1beNr6pabFs1+WPEf05x/H5WzAO8xskwVY7r3SqRkKeL7111tNwBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsuvvzeG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsuvvzeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFC51F00A3D;
	Fri,  4 Sep 2026 05:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498601;
	bh=pNGu1n8KgSr0MCDnSvIK87r/4/0CgUpkpPtVwem5NXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsuvvzeGfFtcgB+Jl9XaLN6T1BobO+FKv8uAHB75Az/vaDOpOCGo5NnUBQ7KZtltK
	 sVqwM63WT4oHBDYd/w9ikEJ96JdCKlc3QVVYT/tmtUjICMaxyJY3fbcC2bfwbNLsxq
	 yR89a4geFqMIqXYMVOW5ECUDOT0Vbm+UfMUAbHIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daisuke Matsuda <matsuda@preferred.jp>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 7.2 119/713] fpga: altera-cvp: Avoid out-of-bounds read in trailing byte write
Date: Fri,  4 Sep 2026 06:51:27 +0200
Message-ID: <20260904045806.504714879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -261,7 +262,7 @@ static int altera_cvp_v2_wait_for_credit
 static int altera_cvp_send_block(struct altera_cvp_conf *conf,
 				 const u32 *data, size_t len)
 {
-	u32 mask, words = len / sizeof(u32);
+	u32 words = len / sizeof(u32);
 	int i, remainder;
 
 	for (i = 0; i < words; i++)
@@ -270,9 +271,10 @@ static int altera_cvp_send_block(struct
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


