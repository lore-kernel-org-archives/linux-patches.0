Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623773DE42E;
	Mon,  4 May 2026 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904036; cv=none; b=BkA9KMwNJa2q7WXCka+LqC+pzL/iWVeSm0ZJOPoGZ85FAFLfeDt16gAa/cTUw9eVaOQ/lET3+8IAgw7h+p8A4c59o1l1+Wa+1YNL7Q67tafWra+EoGipigpZbaWnB11vST5HKzFLJhfz2WboRDyrW1Y0DQhsSMmVCBrBvA7/wOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904036; c=relaxed/simple;
	bh=4oGyA2vjtda888tAMsUVnCLR9koVbLFA6lEj0tAwmEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQSvKLttmlTjEgI1yBcySRKbF8JAKpYfM0KX6cAOUqcpI6hQMaoGaIkZCdCD55IWJ1ylkxpwHvsJC34259qHA6OH3yOh4DcZCRHRR+rea5UpBy4y5KGNYCGkJyLVvop9iRloy6u7jms3YdSjNrRuDOQAjRrop073ogDEtks47dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bN4Dggq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bN4Dggq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43FFC2BCB8;
	Mon,  4 May 2026 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904036;
	bh=4oGyA2vjtda888tAMsUVnCLR9koVbLFA6lEj0tAwmEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bN4Dggq3HtoNJz8nQr8Bb0XBANemq4FtmbFNN/wgkM/ub+OZG7z/L3dePQqTk8Q9b
	 46ysRvZOMU/l0Eyn66pi9d7JEoaMVa51QGVnNozAjfm+CuonnTJS0jqYTSa2tSHtVo
	 4ctbQx2K09bg/fj8I8XSE7rCIU67SlQO9jOtEUpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Zhaoming <yuanzm2@lenovo.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 126/275] net: mctp: fix dont require received header reserved bits to be zero
Date: Mon,  4 May 2026 15:51:06 +0200
Message-ID: <20260504135147.584010964@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Zhaoming <yuanzm2@lenovo.com>

commit a663bac71a2f0b3ac6c373168ca57b2a6e6381aa upstream.

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
@@ -441,6 +441,7 @@ static int mctp_dst_input(struct mctp_ds
 	unsigned long f;
 	u8 tag, flags;
 	int rc;
+	u8 ver;
 
 	msk = NULL;
 	rc = -EINVAL;
@@ -467,7 +468,8 @@ static int mctp_dst_input(struct mctp_ds
 	netid = mctp_cb(skb)->net;
 	skb_pull(skb, sizeof(struct mctp_hdr));
 
-	if (mh->ver != 1)
+	ver = mh->ver & MCTP_HDR_VER_MASK;
+	if (ver < MCTP_VER_MIN || ver > MCTP_VER_MAX)
 		goto out;
 
 	flags = mh->flags_seq_tag & (MCTP_HDR_FLAG_SOM | MCTP_HDR_FLAG_EOM);
@@ -1325,6 +1327,7 @@ static int mctp_pkttype_receive(struct s
 	struct mctp_dst dst;
 	struct mctp_hdr *mh;
 	int rc;
+	u8 ver;
 
 	rcu_read_lock();
 	mdev = __mctp_dev_get(dev);
@@ -1342,7 +1345,8 @@ static int mctp_pkttype_receive(struct s
 
 	/* We have enough for a header; decode and route */
 	mh = mctp_hdr(skb);
-	if (mh->ver < MCTP_VER_MIN || mh->ver > MCTP_VER_MAX)
+	ver = mh->ver & MCTP_HDR_VER_MASK;
+	if (ver < MCTP_VER_MIN || ver > MCTP_VER_MAX)
 		goto err_drop;
 
 	/* source must be valid unicast or null; drop reserved ranges and


