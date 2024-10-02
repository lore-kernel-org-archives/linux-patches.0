Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34EF1D0BB4;
	Wed,  2 Oct 2024 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880592; cv=none; b=ucE5MAHd4PLgWxx3V011dQmHscQwIeK9FgxkNKTHNE1s3aZwQA10XQK0Doe7UDoXX5TIrIUhw5231qdWoUTbPZx5U2EFY3Lu9VLi5cAjHGBs2bZmEXR+ClL/2DSZR8azK03/topi199yItjQQRxduCSxaCExM90a7UOAXHdrwzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880592; c=relaxed/simple;
	bh=xA9Vy+dpDJYpHe17Po/sykCJ02GEUJMtckwZSl30xA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FV0TNLurmqZyZNuGR2t7MebuJoEs/3T5Trxg27Ty4fenKisCmqHHPaJFSHbxL0eF07qYBGY3s6OfCDFRIMwly4NYXBm6zCvIw12pfFxXo4GaTfBMkgH3hByF0bWNIvKRCpDnfHIJZrNYg1VN7yItF6KVOINUwWI9Hq6mmJv/sdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F83pBY07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F83pBY07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6935DC4CEC2;
	Wed,  2 Oct 2024 14:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880591;
	bh=xA9Vy+dpDJYpHe17Po/sykCJ02GEUJMtckwZSl30xA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F83pBY07/8FZmnkFT+tTegG7u0NGoxhobwVYo4kdjT2xzW6GVauRK51+PzWQ2klr2
	 uvaKbuIcFy9OwQUzxauqnX0zxw74cR/9pQhFvJyIn4T3xFSMUeIAshyIQWD/45Np2B
	 ivyP3d7M/axjiescanJcLT/X0mLxBZUdNi88zA00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"qin.wan@hp.com, andreas.noever@gmail.com, michael.jamet@intel.com, mika.westerberg@linux.intel.com, YehezkelShB@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, Alexandru Gagniuc" <alexandru.gagniuc@hp.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Qin Wan <qin.wan@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 512/538] thunderbolt: Introduce tb_switch_depth()
Date: Wed,  2 Oct 2024 15:02:31 +0200
Message-ID: <20241002125812.652879213@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit c4ff14436952c3d0dd05769d76cf48e73a253b48 ]

This is useful helper to find out the depth of a connected router.
Convert the existing users to call this helper instead of open-coding.

No functional changes.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Qin Wan <qin.wan@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |    4 ++--
 drivers/thunderbolt/tb.h |    9 +++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -255,13 +255,13 @@ static int tb_enable_clx(struct tb_switc
 	 * this in the future to cover the whole topology if it turns
 	 * out to be beneficial.
 	 */
-	while (sw && sw->config.depth > 1)
+	while (sw && tb_switch_depth(sw) > 1)
 		sw = tb_switch_parent(sw);
 
 	if (!sw)
 		return 0;
 
-	if (sw->config.depth != 1)
+	if (tb_switch_depth(sw) != 1)
 		return 0;
 
 	/*
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -868,6 +868,15 @@ static inline struct tb_port *tb_switch_
 	return tb_port_at(tb_route(sw), tb_switch_parent(sw));
 }
 
+/**
+ * tb_switch_depth() - Returns depth of the connected router
+ * @sw: Router
+ */
+static inline int tb_switch_depth(const struct tb_switch *sw)
+{
+	return sw->config.depth;
+}
+
 static inline bool tb_switch_is_light_ridge(const struct tb_switch *sw)
 {
 	return sw->config.vendor_id == PCI_VENDOR_ID_INTEL &&


