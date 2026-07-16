Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBEC3D25D0;
	Thu, 16 Jul 2026 14:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211691; cv=none; b=TfxFYsVni/nQMohTkAh5EbGaJVU0Y0AP+NQnC5s96ash9MOBKU/W4Egdia5jkUFOAato11NS8PgEg8wzgT4/uX61WNtcpIPGzRna847d6I+LF8qzBEjRclfLa3Wom8eykIXpXu75qbnL7Nz2t2sjidApXNBPVC4EzqdPZm+hqSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211691; c=relaxed/simple;
	bh=//wUOeYccHmI75t0PTEQ469nBIilFaH8ILliucjsgjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPTfwheoF71CiwK3wsdwJFvZMKZT3usUmjqOB0AzCEc4OtyJDAckcVBIA8oThRzstg9WgEN8N1E95DeJvLXhrLohsu7BZ8PNuRxYqigVUh8vL3Eu3VX0bCvLH5r1nqiiPe92wqBFByodDfaxPhmh3lH9xJuSjNbL4Q5f9enErrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPpiD+bH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPpiD+bH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1961F000E9;
	Thu, 16 Jul 2026 14:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211690;
	bh=+gUjimTSMOLnWJD4rq6JOLvijEOcD4Fcnxzch68+guc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPpiD+bH8rBJlPl19s4drjYWmT7HULv9z+qayDVD1v/17oNRR73G+Fu8FdfXokk/m
	 0wTsPDwgzowLzQnEvU8dNwXZt5UWNaOVtKIjmLi7BVq8HcEeEfZMPnXRzNMPE4o3cr
	 TbYBE2hdJ44flmHBNOdgqnqQ9dG/Ft1B//5yEs8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.12 042/349] usb: gadget: function: rndis: add length check to response query
Date: Thu, 16 Jul 2026 15:29:36 +0200
Message-ID: <20260716133034.266585791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


