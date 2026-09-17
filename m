Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569934DEC2E;
	Thu, 17 Sep 2026 18:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668322; cv=none; b=DwdxyEyV6uBRor97tJoLxTfphdEY6lVZk+JVYQiDnDbbxLme8J85I9oHtgKuUSBsHCUsu0/h1CVlwZhS76QL/WEpOq1NUfoA5zKxE6+gg+f9P9LppVZ0nMr16enVBlR6cUYvZ19ODqmUVkePkSkdizZNMaGqZKyJ7UKg8G2QZBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668322; c=relaxed/simple;
	bh=wO02FsL+P3Z9QFM44EaUDg9crHy9ZlOptNaX8FNgj6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeQSpt3O+owUco1WQN3YQHoNWcJh8jfR8GpdkbcLyTt3YmtrPu1KP4Lj0XZPxnr0eDaEHPN1TURHJNb/5yLV4gHPAE0kmoWo9JzTG4HIuQyOxEt58VHarIFOQ8pc8AUkUOcy9Fx70te0XI2vsC3zpc/x0hjk+cPnGtETphPsmdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmjsDSiR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmjsDSiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548C21F000FF;
	Thu, 17 Sep 2026 18:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668320;
	bh=zSh6qbLm3frElKECHq4G9+1quX7tEGML0YD8oDprVN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmjsDSiRTRhlvyDH7i/8n5x0Y/d6/ozirJIW8k8MCUmv1iJqGYtv7L4UPeZ0HQYbG
	 P6582zn/3YMqqbOMZV2K4v/tj7ffttMz5bl/kHZHwbR+VEfVMgItWurdrbhZUA1Qt2
	 i+qRh2Nqt5Phz4FzsrsfttTu4hzNOLNFGHmHXvbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0386/1102] ksmbd: fix credit charge calculation for SMB2 QUERY_INFO
Date: Thu, 17 Sep 2026 16:05:29 +0100
Message-ID: <20260917151549.347695561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index b11d854d3fcfb..05da29c72c4f0 100644
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



