Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E0A3B8948;
	Wed, 30 Sep 2026 18:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794775; cv=none; b=cwvxlXPV7S/NrvPxd1d1wZaroEs+JT41mP36+Y6zQjDm9sBsqnAhSqJxkl9RIuERrXAX17w4skRMEMkFvMsIVoAevLWdX2Seij5PUcEPE6B70Eh4F/KpSQIc+OoVnRoxUMIBcMgPU8tcEtP4NvVRyYAASXBiRwFsuD7yqJph48c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794775; c=relaxed/simple;
	bh=DrkG70NVE4tzETOmc/ew9TtjPtIMlXPourg9KRK67FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYuBGiJS12nDTWf6uqiE8s9Ng+BW8PFuHf9Go2IvXLNGpef/pYvvW14MkyXO0E5Cz2/D6sgDeeL8nyHVypbiaOoHltZCL0B7mioAyBfd85m+BjQ/iWoVHW0/yY2iuXB5nlR/QCNDLbRN5FM19UrfFGk+RhdnLYJfJg/npgAyhWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z62u7BWC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z62u7BWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256271F000FF;
	Wed, 30 Sep 2026 18:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794773;
	bh=wQxqspvGC30fGGvKrelL3BejklfQRWekz5Fww2PHhDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z62u7BWCyI6pC+RdETrBLZlI0uGtyEulwNOUJCyczAHNacFF1utMja7a59f6yY8Iy
	 C01qrDISn1SxViOpH2YrjoaU5S4UXyid7S7V6ZA5odbBr9QNvZSDOYCJElkfHOzrLl
	 4piYdq/3nCDTtgxLFDPYnPwt4naBYD/XVailoJD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0284/1193] ksmbd: fix credit charge calculation for SMB2 QUERY_INFO
Date: Wed, 30 Sep 2026 17:16:08 +0200
Message-ID: <20260930152440.476011145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 284dc80ff529a0b454f11b6c2fea0d5daf6f315f ]

smb2_validate_credit_charge() computes the credit charge a request is
allowed to consume from the payload size:

  CreditCharge = (max(SendPayloadSize, ResponsePayloadSize) - 1)/65536 + 1

For SMB2 QUERY_INFO, the server must validate CreditCharge based on the
*maximum* of InputBufferLength and OutputBufferLength. ksmbd instead
summed the two lengths, which overestimates the required charge.

As a result a single-credit QUERY_INFO whose InputBufferLength and
OutputBufferLength each fit in 64KB but whose sum exceeds 64KB is
rejected with STATUS_INVALID_PARAMETER, even though it is a valid
request. IOCTL already uses max() of the request and response sizes;
make QUERY_INFO consistent by feeding InputBufferLength as the request
length and OutputBufferLength as the expected response length so that
smb2_validate_credit_charge() takes their maximum.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2misc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index 6a4f1b8a0b13c..b8cce64675834 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -262,8 +262,12 @@ static int smb2_calc_size(void *buf, unsigned int *len)
 
 static inline int smb2_query_info_req_len(struct smb2_query_info_req *h)
 {
-	return le32_to_cpu(h->InputBufferLength) +
-		le32_to_cpu(h->OutputBufferLength);
+	return le32_to_cpu(h->InputBufferLength);
+}
+
+static inline int smb2_query_info_resp_len(struct smb2_query_info_req *h)
+{
+	return le32_to_cpu(h->OutputBufferLength);
 }
 
 static inline int smb2_set_info_req_len(struct smb2_set_info_req *h)
@@ -309,6 +313,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 	switch (hdr->Command) {
 	case SMB2_QUERY_INFO:
 		req_len = smb2_query_info_req_len(__hdr);
+		expect_resp_len = smb2_query_info_resp_len(__hdr);
 		break;
 	case SMB2_SET_INFO:
 		req_len = smb2_set_info_req_len(__hdr);
-- 
2.53.0



