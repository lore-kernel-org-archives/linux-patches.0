Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E902720297C;
	Fri, 15 May 2026 16:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861590; cv=none; b=aK81DL/uSKqYeGd81sq+SDARxV1yTk/ZxG3w+yWYuBybKZMyNFntEB8w8EYqIaAYih7c7s5614DNX2ldTuO24wEXe9c0hnbZbjYPvKeVEICBM9FxNOmksApobZmT/Ljagn5YZwatZAVp7CSWSOZ7li9ujs6ggCr5BxWzYt2KYAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861590; c=relaxed/simple;
	bh=BzyfiOESfSV1cMkPNPin0+2QCTsNr3o9ffW2YgUPDnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldDjX9s7+WL1QxnzXyun6fUcjiq/IWyPHGEMZYG2B/j6TKzYlP0CnIGzE6/zZhEYojr2VFgHx4cvlO0jXPq90U53OWwCCCBrC3Kd5yUVBvA94mljWC20tYQGbzZtuCYlag8VF/jsjp3SkLv/lU7z2OkpTOCOMSXO7agmVImhlqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3bYCplD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3bYCplD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E172C2BCB0;
	Fri, 15 May 2026 16:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861589;
	bh=BzyfiOESfSV1cMkPNPin0+2QCTsNr3o9ffW2YgUPDnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3bYCplDHYZZH3RWBKjpQypBNSTWiSX0RHV3d4xvhKaEKkelH7eRRPS3RsNoBNuBm
	 JHVrjTKUoZr+qOxcml7a94sxP6lV2puOjQsLOEqZhW+VQfh0Q4WeL2xvI0U10mnnDS
	 /d3VcfRV0UODivefQM6O88iyuB+FxjbxcdWLqb2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Zhaoming <yuanzm2@lenovo.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 388/474] net: mctp: fix dont require received header reserved bits to be zero
Date: Fri, 15 May 2026 17:48:17 +0200
Message-ID: <20260515154723.437171203@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -26,6 +26,9 @@ struct mctp_hdr {
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
@@ -335,6 +335,7 @@ static int mctp_route_input(struct mctp_
 	unsigned long f;
 	u8 tag, flags;
 	int rc;
+	u8 ver;
 
 	msk = NULL;
 	rc = -EINVAL;
@@ -357,7 +358,8 @@ static int mctp_route_input(struct mctp_
 	mh = mctp_hdr(skb);
 	skb_pull(skb, sizeof(struct mctp_hdr));
 
-	if (mh->ver != 1)
+	ver = mh->ver & MCTP_HDR_VER_MASK;
+	if (ver < MCTP_VER_MIN || ver > MCTP_VER_MAX)
 		goto out;
 
 	flags = mh->flags_seq_tag & (MCTP_HDR_FLAG_SOM | MCTP_HDR_FLAG_EOM);
@@ -1124,6 +1126,7 @@ static int mctp_pkttype_receive(struct s
 	struct mctp_skb_cb *cb;
 	struct mctp_route *rt;
 	struct mctp_hdr *mh;
+	u8 ver;
 
 	rcu_read_lock();
 	mdev = __mctp_dev_get(dev);
@@ -1141,7 +1144,8 @@ static int mctp_pkttype_receive(struct s
 
 	/* We have enough for a header; decode and route */
 	mh = mctp_hdr(skb);
-	if (mh->ver < MCTP_VER_MIN || mh->ver > MCTP_VER_MAX)
+	ver = mh->ver & MCTP_HDR_VER_MASK;
+	if (ver < MCTP_VER_MIN || ver > MCTP_VER_MAX)
 		goto err_drop;
 
 	/* source must be valid unicast or null; drop reserved ranges and


