Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C19147127E;
	Tue, 21 Jul 2026 21:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668134; cv=none; b=jlFyheEXyPFHGVgm5cZYU8Pp1DRdyYiBzr3+dzOQye98nISK0KCIE9y13EGwkxvDJDvcUQHZWexoeRlgKmYxeGQdv91x9Gh9db5X+AMmjjhvRPdYYDX5YYNnRrtapxJqSQol7Cg3j8MOtzBvO4nX4G1ZFlpqYAPFYxqKz87ttXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668134; c=relaxed/simple;
	bh=NnYp6nNvyveGYkkloj+dGTwhLlsXKdQF2BHQG0vFlS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdYrWzm+FUwUX8xF8HvgQzB3jNHfxHO+BqD7yxTMo7CvqPw72lkTneu2vqD+rQkau3blzajn/GL3PNtWUVwXMZe4hZyn4i8ampakv/D1ZJyjmFxsZN3ZokK4E+3dNTA8zqrkXqhatFMiRpYiSlYI+6RjvC5gkbDUuOB6qDVSE4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIA5VXne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIA5VXne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAE01F000E9;
	Tue, 21 Jul 2026 21:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668129;
	bh=+1VkxW1eixH3ZsZp+1KzxxuKNcsmrVL/7Rzr1dvR35Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIA5VXne8thm1dDSaH3UWL6Dcz2hy1vJIVPl/bOg3Q9ufmFi3Kd2k1Me/L5plmkFe
	 ws3s0nfC8lIagbvh9+hTFtimT+vZPySMnCBck7foV6YO6jXSBh8CzKQmrINzgVbRQq
	 ZGbqBKkfqnIfSUZZFTBxVsU66wcHl/e/YnWW9kS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.1 0052/1067] usb: gadget: function: rndis: add length check to response query
Date: Tue, 21 Jul 2026 17:10:53 +0200
Message-ID: <20260721152425.728875527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


