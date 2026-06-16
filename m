Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22006472798;
	Tue, 16 Jun 2026 18:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634503; cv=none; b=VSKZxnK9MVbsYFa8H3v7+jChUAs+aAE/3fcDZVfF18d43EIkrVsGCwx5ouPt0JYl2ZCkO6VBJ35D+5ZBuJzJS1ZcXDFFvis3wrhkYz/D9CQAuGt9QINSyGCo/F1iZpStdGE0T58j59RtRLD8GkRdVlKGCN1e+z/0gVEDFcJkZBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634503; c=relaxed/simple;
	bh=/M8MXoEuUPJdWGdgRslEcUqXDgWdBU+hhzqYNMQtG6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AarbyyaUPJkNmllK7ZyNswsS6EtNxr2rRVO2CanElutL36aVTSfi6m7YT26mHI8S4qH1z4Kd1TEqkheMXzPAbRAM7x+bT212MFIc8fwQR7bnAKptf7ZzsesF+xWABeWSA85th9cQzh+IVX4aJrKmQHasTR/UWjnPs3fl8r/24tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oesbweHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oesbweHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DBC1F000E9;
	Tue, 16 Jun 2026 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634501;
	bh=SDoKSEFpvQUMihcvryN9BjcVABiDHfYNfQxjr22z2gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oesbweHf2ml/Nr55xnQzj2/ZKaGjtzY/4y7z7A1PJ/8+5Jfqy22dW15+qojD2dJE5
	 Ex68Lk0Zc5Jms6GBkJASpvc/tvkXA4PN2w39JAESbrIQneGskHK0Zh/JdhDmPMelc7
	 tOj6Lz3RMowC/hfJ4zHvqvb20QHBG+hncdpK0hhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Zhaoming <yuanzm2@lenovo.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/411] net: mctp: fix dont require received header reserved bits to be zero
Date: Tue, 16 Jun 2026 20:28:35 +0530
Message-ID: <20260616145115.854115173@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Zhaoming <yuanzm2@lenovo.com>

[ Upstream commit a663bac71a2f0b3ac6c373168ca57b2a6e6381aa ]

>From the MCTP Base specification (DSP0236 v1.2.1), the first byte of
the MCTP header contains a 4 bit reserved field, and 4 bit version.

On our current receive path, we require those 4 reserved bits to be
zero, but the 9500-8i card is non-conformant, and may set these
reserved bits.

DSP0236 states that the reserved bits must be written as zero, and
ignored when read. While the device might not conform to the former,
we should accept these message to conform to the latter.

Relax our check on the MCTP version byte to allow non-zero bits in the
reserved field.

Fixes: 889b7da23abf ("mctp: Add initial routing framework")
Signed-off-by: Yuan Zhaoming <yuanzm2@lenovo.com>
Cc: stable@vger.kernel.org
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20260417141340.5306-1-yuanzhaoming901030@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/mctp.h |    3 +++
 net/mctp/route.c   |    8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -25,6 +25,9 @@ struct mctp_hdr {
 #define MCTP_VER_MIN	1
 #define MCTP_VER_MAX	1
 
+/* Definitions for ver field */
+#define MCTP_HDR_VER_MASK	GENMASK(3, 0)
+
 /* Definitions for flags_seq_tag field */
 #define MCTP_HDR_FLAG_SOM	BIT(7)
 #define MCTP_HDR_FLAG_EOM	BIT(6)
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -229,6 +229,7 @@ static int mctp_route_input(struct mctp_
 	unsigned long f;
 	u8 tag, flags;
 	int rc;
+	u8 ver;
 
 	msk = NULL;
 	rc = -EINVAL;
@@ -246,7 +247,8 @@ static int mctp_route_input(struct mctp_
 	mh = mctp_hdr(skb);
 	skb_pull(skb, sizeof(struct mctp_hdr));
 
-	if (mh->ver != 1)
+	ver = mh->ver & MCTP_HDR_VER_MASK;
+	if (ver < MCTP_VER_MIN || ver > MCTP_VER_MAX)
 		goto out;
 
 	flags = mh->flags_seq_tag & (MCTP_HDR_FLAG_SOM | MCTP_HDR_FLAG_EOM);
@@ -859,6 +861,7 @@ static int mctp_pkttype_receive(struct s
 	struct mctp_skb_cb *cb;
 	struct mctp_route *rt;
 	struct mctp_hdr *mh;
+	u8 ver;
 
 	/* basic non-data sanity checks */
 	if (dev->type != ARPHRD_MCTP)
@@ -872,7 +875,8 @@ static int mctp_pkttype_receive(struct s
 
 	/* We have enough for a header; decode and route */
 	mh = mctp_hdr(skb);
-	if (mh->ver < MCTP_VER_MIN || mh->ver > MCTP_VER_MAX)
+	ver = mh->ver & MCTP_HDR_VER_MASK;
+	if (ver < MCTP_VER_MIN || ver > MCTP_VER_MAX)
 		goto err_drop;
 
 	cb = __mctp_cb(skb);


