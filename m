Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2BAC142
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3135C433C8;
	Mon, 19 Jun 2023 10:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172314;
	bh=PcMLzG59PngyVHlKGq9hFI9F9v8wtx5t90I4RlnfWv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AwoOEBRWLibBz8D86Lc0iJjiWimGQzBvuos4CYpDbYRHJ54PsOsJ9Eynh4t4ZxzS
	 j+MBqK//aKmtqIRQVWOZOfnqLgYxCu2tK8RikfTXPb6mi10XpfqiSQIiwk7XZTmbI2
	 UdlEU89BnhQDS3vQ4GQrKZ+n4I2Y+S5BRA3qr73Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ting Chen <h3xrabbit@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/107] ksmbd: fix slab-out-of-bounds read in smb2_handle_negotiate
Date: Mon, 19 Jun 2023 12:29:48 +0200
Message-ID: <20230619102141.745140984@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuan-Ting Chen <h3xrabbit@gmail.com>

[ Upstream commit d738950f112c8f40f0515fe967db998e8235a175 ]

Check request_buf length first to avoid out-of-bounds read by
req->DialectCount.

[ 3350.990282] BUG: KASAN: slab-out-of-bounds in smb2_handle_negotiate+0x35d7/0x3e60
[ 3350.990282] Read of size 2 at addr ffff88810ad61346 by task kworker/5:0/276
[ 3351.000406] Workqueue: ksmbd-io handle_ksmbd_work
[ 3351.003499] Call Trace:
[ 3351.006473]  <TASK>
[ 3351.006473]  dump_stack_lvl+0x8d/0xe0
[ 3351.006473]  print_report+0xcc/0x620
[ 3351.006473]  kasan_report+0x92/0xc0
[ 3351.006473]  smb2_handle_negotiate+0x35d7/0x3e60
[ 3351.014760]  ksmbd_smb_negotiate_common+0x7a7/0xf00
[ 3351.014760]  handle_ksmbd_work+0x3f7/0x12d0
[ 3351.014760]  process_one_work+0xa85/0x1780

Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Ting Chen <h3xrabbit@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e24fd10d85d3b..266430a2a0e07 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1083,16 +1083,16 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 		return rc;
 	}
 
-	if (req->DialectCount == 0) {
-		pr_err("malformed packet\n");
+	smb2_buf_len = get_rfc1002_len(work->request_buf);
+	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects) - 4;
+	if (smb2_neg_size > smb2_buf_len) {
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 		rc = -EINVAL;
 		goto err_out;
 	}
 
-	smb2_buf_len = get_rfc1002_len(work->request_buf);
-	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects) - 4;
-	if (smb2_neg_size > smb2_buf_len) {
+	if (req->DialectCount == 0) {
+		pr_err("malformed packet\n");
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 		rc = -EINVAL;
 		goto err_out;
-- 
2.39.2



