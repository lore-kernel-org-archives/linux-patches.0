Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112C213AC5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E09C433C0;
	Mon, 26 Jun 2023 18:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804009;
	bh=14opGvk+C9k5vMdT9tKTHa0Z85aOQZiJkcVm5DoU6jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6kUCaXPf7g1YRoMKO6JdCUWUIQ6jHOfQ1BJyB4bF2Nb642waXkWrekyAoPoiu9uQ
	 qrwAH6HsrJ5qL5tDHLY6WNiMe/8US9QwWlKF8GU2TwZeM3hwjf0LItQrRW14dyY4Zc
	 vhH/qPyfI/SW4iJsbsPwmMYlc6Z0y5gtgJFOkfEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 011/170] ksmbd: fix out-of-bound read in smb2_write
Date: Mon, 26 Jun 2023 20:09:40 +0200
Message-ID: <20230626180801.040922988@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 5fe7f7b78290638806211046a99f031ff26164e1 upstream.

ksmbd_smb2_check_message doesn't validate hdr->NextCommand. If
->NextCommand is bigger than Offset + Length of smb2 write, It will
allow oversized smb2 write length. It will cause OOB read in smb2_write.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21164
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2misc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -351,10 +351,16 @@ int ksmbd_smb2_check_message(struct ksmb
 	int command;
 	__u32 clc_len;  /* calculated length */
 	__u32 len = get_rfc1002_len(work->request_buf);
-	__u32 req_struct_size;
+	__u32 req_struct_size, next_cmd = le32_to_cpu(hdr->NextCommand);
 
-	if (le32_to_cpu(hdr->NextCommand) > 0)
-		len = le32_to_cpu(hdr->NextCommand);
+	if ((u64)work->next_smb2_rcv_hdr_off + next_cmd > len) {
+		pr_err("next command(%u) offset exceeds smb msg size\n",
+				next_cmd);
+		return 1;
+	}
+
+	if (next_cmd > 0)
+		len = next_cmd;
 	else if (work->next_smb2_rcv_hdr_off)
 		len -= work->next_smb2_rcv_hdr_off;
 


