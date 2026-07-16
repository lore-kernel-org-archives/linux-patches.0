Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047F923395D;
	Thu, 16 Jul 2026 14:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210507; cv=none; b=s8DNymbYznn4ZvlIP168HqHsZkzLLd30ie4GsT5ZP/9QQ4wXGzcxvajtFill2AUaJcPuzPV6LqZ0rxu8ok3Ds853sMc9bDfSHYKs/qFSczyCVZZ56FL+AZZ5nwQ2gmXPWRjhnTUePR4Beuq8cc9y81SLyijc64D7Ld+okXKUAB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210507; c=relaxed/simple;
	bh=Vmvh2eTa30XzUDCYq7GNwAq9AHrX73GtFePf9YGm2h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCGp5NxYdHZ2C79T/LfzySDJSGh91boq1I96lAuu9lr/5VIzp7nsGnP/UKKwORz31+vAJwEzY9P9uSCrpwdQqGYV/zV7wMDoX/UVWvSt56nBHWhs5IDpaTJCTlPRVyJ0o2Kw9PkJ0giJ2OdY/iig0h1CzTNKmID6DeRwz9RthQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XR73gJBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XR73gJBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FFC1F000E9;
	Thu, 16 Jul 2026 14:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210505;
	bh=oFy961t5+d1z8F6wPAS/fuCZosw7PZnkz0Byt9fV8gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XR73gJBK26Z4hMP+yE1N6xWe1jouttLR4yrRp4vBKsSV3bT60NXZid2yknxBMrEo2
	 gZnW3LbQXhUYmbhDZ/xG2RXmM4tmD00RbuWvck7m9hInwNleNQFe/QnoSEt55s9VP+
	 kj37gOsh40QGdeWknvqRatgtklokit82m77pIThM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.18 046/480] usb: gadget: function: rndis: add length check to response query
Date: Thu, 16 Jul 2026 15:26:33 +0200
Message-ID: <20260716133045.702444998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 95f90eea070837f7c72207d5520f805bdefc3bc5 upstream.

Add variable representations for BufLength and BufOffset in
rndis_query_response(), and perform a length check on them.

This is identical to how rndis_set_response() handles these parameters.

Assisted-by: gkh_clanker_2000
Cc: stable <stable@kernel.org>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260708-usb-gadget-rndis-v1-1-e77e026dcc6a@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/rndis.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -591,6 +591,7 @@ static int rndis_init_response(struct rn
 static int rndis_query_response(struct rndis_params *params,
 				rndis_query_msg_type *buf)
 {
+	u32 BufLength, BufOffset;
 	rndis_query_cmplt_type *resp;
 	rndis_resp_t *r;
 
@@ -598,6 +599,13 @@ static int rndis_query_response(struct r
 	if (!params->dev)
 		return -ENOTSUPP;
 
+	BufLength = le32_to_cpu(buf->InformationBufferLength);
+	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
+	if ((BufLength > RNDIS_MAX_TOTAL_SIZE) ||
+	    (BufOffset > RNDIS_MAX_TOTAL_SIZE) ||
+	    (BufOffset + 8 >= RNDIS_MAX_TOTAL_SIZE))
+		return -EINVAL;
+
 	/*
 	 * we need more memory:
 	 * gen_ndis_query_resp expects enough space for
@@ -614,10 +622,8 @@ static int rndis_query_response(struct r
 	resp->RequestID = buf->RequestID; /* Still LE in msg buffer */
 
 	if (gen_ndis_query_resp(params, le32_to_cpu(buf->OID),
-			le32_to_cpu(buf->InformationBufferOffset)
-					+ 8 + (u8 *)buf,
-			le32_to_cpu(buf->InformationBufferLength),
-			r)) {
+				BufOffset + 8 + (u8 *)buf,
+				BufLength, r)) {
 		/* OID not supported */
 		resp->Status = cpu_to_le32(RNDIS_STATUS_NOT_SUPPORTED);
 		resp->MessageLength = cpu_to_le32(sizeof *resp);


