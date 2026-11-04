Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829041;
	b=HpOTVauCce5ec7+/QofYkMeqX/23nlM+voPbOVYZvzl3AiaF0jFQs/SRl+8uuXrTD1lI
	 9AF9X2UCARD8KS2jeV+XjRhDwpzG/WbekhfaCH+CIBTY+J8cEUBaqMytJPrGRyR3ig6eE
	 aeNRklQwVlyB+0RfZvb4JeuajfD+sdDJekgohWKdKDambHDqMUHN4h1l081+5f62hSS9J
	 x3K/G4oxtfL9jqr5n6NPgDmYWv/1ZCuzNqMzyMkbU2OrgIAYg8OEflb5EvQzMu8EJzEv9
	 +x1tNHWX+UfCxqll63zco0NiG1yVL9/50mu/cA8+Zh7++2OmJMM7yQigax2iTlAjIDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t0tveza/UnGHRXKlESNux2j8IrqrEBBEw3P0mIVjk74=;
	b=A2fwfaw/P62P7929Fcr43PVSaeOncmYjy985y8KO+CzOrh048R23SNTOtVqg/Z8d4MHi
	 mMxzN/Q/NxnwvjbTCUBghkeHq1RKpl/QyoCOK85Ri2pCAsEsQLmm1Vz7vJWQ4NXlKAUhw
	 uA3518U6m2RetNQDkbDIIUCCbou5210Rg0L9PHZnXxCiyzrAQE3X3ozU0R2gEUm7HOVq0
	 4B9ONRN7h0EM/Shmcv1KpsPTmrXxR/MfP7TCUts/X8kz8pnkC3r/VxiHDCeeMmqVS2nWH
	 sWNFXvidGhFFsadlNQcDxUfaSsj//4sT1DPRrpH3UE6gZ1lbexPr2mhp0QSvl+0YksQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C03OdB8T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E71F608079C;
	Wed,  4 Nov 2026 21:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C03OdB8T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114B71F00A16;
	Wed,  4 Nov 2026 21:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829041;
	bh=t0tveza/UnGHRXKlESNux2j8IrqrEBBEw3P0mIVjk74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C03OdB8TVxsXoapnptvD2ojYnK9qfdB6VLP44EgK57yCBAsxKlv1+G5WBSWitJR0J
	 jAAoJa67Ppdh+M21yFOdZTijuTCSvP2Np66QPKrgPKI+x7tmKKo5RSmXc+GoDPLFuf
	 4QIZyRZBHk0zaZYf/lw0kHzf240neJHk2UNt0DlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 389/547] smb: client: validate NT transaction response layout and offsets
Date: Wed,  4 Nov 2026 16:09:33 -0500
Message-ID: <20261104211049.351794534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>

commit 83d0d5e0ca22233c75daf139ec0063b9d2ff1ac7 upstream.

validate_ntransact() assumes that the response uses the fixed 18-word NT
transaction layout. A different WordCount makes get_bcc() locate the byte
count at a different offset from pSMBr->ByteCount, allowing the subsequent
bounds checks to use inconsistent response boundaries.

The function also turns the 32-bit ParameterOffset and DataOffset fields
into pointers before checking their bounds. On a 32-bit client, a large
offset can wrap the pointer below end_of_smb and pass the one-sided pointer
comparison. The caller then dereferences the parameter pointer or copies
from the data pointer.

Require the expected WordCount before reading the byte count. Check each
offset and count against the received SMB length as integers before forming
either pointer. Use subtraction after validating the offset so that the
range checks cannot overflow.

Reported-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Fixes: 0a4b92c05ed0 ("[CIFS] Add worker function for Get ACL cifs style")
Cc: stable@vger.kernel.org
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3799,9 +3799,10 @@ static int
 validate_ntransact(char *buf, char **ppparm, char **ppdata,
 		   __u32 *pparmlen, __u32 *pdatalen)
 {
-	char *end_of_smb;
 	__u32 data_count, data_offset, parm_count, parm_offset;
 	struct smb_com_ntransact_rsp *pSMBr;
+	size_t buflen;
+	char *end_buf;
 	u16 bcc;
 
 	*pdatalen = 0;
@@ -3812,37 +3813,42 @@ validate_ntransact(char *buf, char **ppp
 
 	pSMBr = (struct smb_com_ntransact_rsp *)buf;
 
+	if (pSMBr->hdr.WordCount != 18) {
+		cifs_dbg(FYI, "invalid NT transaction WordCount %u\n",
+			 pSMBr->hdr.WordCount);
+		return -EINVAL;
+	}
+
 	bcc = get_bcc(&pSMBr->hdr);
-	end_of_smb = 2 /* sizeof byte count */ + bcc +
-			(char *)&pSMBr->ByteCount;
+	end_buf = 2 /* sizeof byte count */ + bcc + (char *)&pSMBr->ByteCount;
+	buflen = end_buf - buf;
 
 	data_offset = le32_to_cpu(pSMBr->DataOffset);
 	data_count = le32_to_cpu(pSMBr->DataCount);
 	parm_offset = le32_to_cpu(pSMBr->ParameterOffset);
 	parm_count = le32_to_cpu(pSMBr->ParameterCount);
 
-	*ppparm = (char *)&pSMBr->hdr.Protocol + parm_offset;
-	*ppdata = (char *)&pSMBr->hdr.Protocol + data_offset;
-
 	/* should we also check that parm and data areas do not overlap? */
-	if (*ppparm > end_of_smb) {
+	if (parm_offset > buflen) {
 		cifs_dbg(FYI, "parms start after end of smb\n");
 		return -EINVAL;
-	} else if (parm_count + *ppparm > end_of_smb) {
+	} else if (parm_count > buflen - parm_offset) {
 		cifs_dbg(FYI, "parm end after end of smb\n");
 		return -EINVAL;
-	} else if (*ppdata > end_of_smb) {
+	} else if (data_offset > buflen) {
 		cifs_dbg(FYI, "data starts after end of smb\n");
 		return -EINVAL;
-	} else if (data_count + *ppdata > end_of_smb) {
-		cifs_dbg(FYI, "data %p + count %d (%p) past smb end %p start %p\n",
-			 *ppdata, data_count, (data_count + *ppdata),
-			 end_of_smb, pSMBr);
+	} else if (data_count > buflen - data_offset) {
+		cifs_dbg(FYI, "data offset %u + count %u past smb length %zu\n",
+			 data_offset, data_count, buflen);
 		return -EINVAL;
 	} else if (parm_count + data_count > bcc) {
 		cifs_dbg(FYI, "parm count and data count larger than SMB\n");
 		return -EINVAL;
 	}
+
+	*ppparm = buf + parm_offset;
+	*ppdata = buf + data_offset;
 	*pdatalen = data_count;
 	*pparmlen = parm_count;
 	return 0;


