Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D6751815C;
	Wed, 30 Sep 2026 16:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784702; cv=none; b=JhLQ6WS8Ad7UjmAuizqSNign2XgJqbbaXGslkloIyQyM41erbeDsqIgeAYn/MvOFAcK9zQGqxNRd06yJDPIaBE6TtEgunqdzT7ILyNZ1udOPEE5NTQWFbx1pq1tBrJlIVTIcFiyu4dWQL71En+7GfiXDbbLBF6In3h27FUmZhzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784702; c=relaxed/simple;
	bh=ga6gCAWbr1n0fu+a4HlOJHW0czNHSdRz44LqtGIMZKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTnjhDAA+XRwwuW7tHQvTBF/V3gLHBvhwq/lITgNzPr2VYSVXOe2gYiKv0b++1hngCaB1KsKwuBDZU7gkCFJbh7qPqrsZdciWFDIcy1ki5NnBbQODETSZKcPPDPgImXxlt62uvLBpVMzOL7eS4Vs+If2ljVkaWWyKfqr0b58wEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zk/kkx6q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zk/kkx6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39B31F0089A;
	Wed, 30 Sep 2026 16:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784697;
	bh=z3EP9uhYT6MeEn5icI2i/ZzDcZrfNr+ftQ+aD8BlrCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zk/kkx6qoVk7+xJHLQRBpY40Drla63mXskHhZwZi/ysWGw7XtMr0IqvCKwJEJQmuY
	 bjL0RDjzEq5MaqzQarehF0jL22mbgubp5WyqpeihDDlMn24A7S6dbwufh52sXd0lzz
	 /MyMjSc+CKOQrwaxTihlaTjvP7Ubqd9GedswSVr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 245/982] ksmbd: fix credit charge calculation for SMB2 QUERY_INFO
Date: Wed, 30 Sep 2026 17:16:21 +0200
Message-ID: <20260930152422.057165478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 8b56770f36ed8..5b6fb0ba83a54 100644
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
@@ -310,6 +314,7 @@ static int smb2_validate_credit_charge(struct ksmbd_work *work,
 	switch (hdr->Command) {
 	case SMB2_QUERY_INFO:
 		req_len = smb2_query_info_req_len(__hdr);
+		expect_resp_len = smb2_query_info_resp_len(__hdr);
 		break;
 	case SMB2_SET_INFO:
 		req_len = smb2_set_info_req_len(__hdr);
-- 
2.53.0



