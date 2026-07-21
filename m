Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E694A43C7AE;
	Tue, 21 Jul 2026 22:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673239; cv=none; b=gnxBUhamdp2F+AUC6jjlmdd8qm7DZkd/cvw78JCjd5Ab9dnxUiHfLG3R6E44+AKEOQ41UTLrFwpWvdHaNez4bYMZQ7/5JeHQ0v2lfLxIFyYynGLcOD0Pv45ResbtO9huOIpehNaftKhbmFsRtyYJVBPAZBDMcA5ZfNP3P7EwH28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673239; c=relaxed/simple;
	bh=arDOXQ2/ylXryLnqiIui1lQDnWepF0VzSi5f1BMdStg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoSIR9f6f6+1gmXd9+qSD1y14zpZtxOU+VzLLWtlQEm/1OIRuPhToC/2JdKFcnL4w+2V306l9Q8heOTcAuVBaf08QJzQ57aTsk7d1vSSyyEneqDELYWGJwi55BITlAzDelY6xLEYoVCke5osfX3AbDA1v5yrbUi4XNFFoOyhJFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rucb4j6T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rucb4j6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A811F00A3A;
	Tue, 21 Jul 2026 22:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673237;
	bh=7CKGX4XGuSc2tGmibhkBZXwIcNaoUHIvlMEvJn320Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rucb4j6TVDmaEgUoVacFd+y1YGtJ/6dgb1FFY/Q3kYicHH6LjkEFTXodq9zMJBxXx
	 Sx1qWR8qDbk1+355O+LZdobOEjiTp6JtGZyjw7C4hDnIppymW8wq3LhEctsWRnFAOt
	 76AYfHiPgyVfLjoA1k0KharAURy5qKqYhLDNLLbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 5.10 033/699] usb: gadget: function: rndis: add length check to response query
Date: Tue, 21 Jul 2026 17:16:32 +0200
Message-ID: <20260721152356.453774613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


