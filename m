Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31364415B66;
	Wed, 30 Sep 2026 17:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791112; cv=none; b=jX5dzfRhfrGBY4B8fZPB9gkcOo+rrK2eLBaIAghOjKOeeUaTibFOUMNYZa3OeQt9eaBaTwOZ92OSHQ0H/ZHLFnsE/xxJBrxcNZxtf4fWu6YiakkbP9H3oQ0Lrg36afTxw0G+EWBI62uIPosnUYHUK+P5XhSXIBo3XI421K0IM7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791112; c=relaxed/simple;
	bh=ZB1QK8Ilp6VeCH2CFAEgJejHPEloXlLl8mGVz0yS/04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiU4WFXbKUWA4uvIz5FU9iEKiFAgsvugLfYPKtVaIHoTbkYha19jew5JQrLmxG2txYme8U2ihDw3IgA52vlmuyTUux5O+FUTZ3sRC5zfpcujYNDw5YYfpT9XE8egr/BOu3EEHbHVJh/GargOI9OnowSU6DcywavKsTLEnP1EDko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWH2g+R/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWH2g+R/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540C21F000FF;
	Wed, 30 Sep 2026 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791110;
	bh=hGJEpoK0hjdP9j8mirSyQROiOvp/mb+slBjTbuM+tbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWH2g+R/HbsxTI9wFkLKdCBCqYqk0q1qTxioHS7+DV1dPcVK9ep8N4fv3SGxJp2Qr
	 M040fXZ6qq5l9CbQAgztecOo+uS/czmsUEzjiof+B34kZG8bG3dXd1YCFR7fQZaA32
	 08OqYWL/eS/iiBQJpGGL/eLlf0SyE2Qgg4JO6seA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/752] ksmbd: fix credit charge calculation for SMB2 QUERY_INFO
Date: Wed, 30 Sep 2026 17:20:59 +0200
Message-ID: <20260930152402.302688938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
 fs/ksmbd/smb2misc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 8d7368ccda85d..49a9237f7a5c0 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -261,8 +261,12 @@ static int smb2_calc_size(void *buf, unsigned int *len)
 
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
@@ -308,6 +312,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 	switch (hdr->Command) {
 	case SMB2_QUERY_INFO:
 		req_len = smb2_query_info_req_len(__hdr);
+		expect_resp_len = smb2_query_info_resp_len(__hdr);
 		break;
 	case SMB2_SET_INFO:
 		req_len = smb2_set_info_req_len(__hdr);
-- 
2.53.0



