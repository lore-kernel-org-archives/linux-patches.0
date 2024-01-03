Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBB31BDF0;
	Wed,  3 Jan 2024 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tACcWVo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA36DC433C8;
	Wed,  3 Jan 2024 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301247;
	bh=PbF4ni26Qycu70EMkUEoeHiUfOCbFR1nDYhg3hLuNNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tACcWVo/d21sz7PGMIpwapoca+RKzssCQnB+h2rVYSbUeRM64kXAI5nzBrMs3X0ah
	 TOatpigqeDkyuph163dK3XuR0Dzdxlt9HmwC2ZOAMdtTt6AZVstLNgg4jwcWiR8MJa
	 D5ycOd0owvSatRR2XhY2ss7Aq0GSizWBJFrIr0Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/100] ksmbd: fix wrong error response status by using set_smb2_rsp_status()
Date: Wed,  3 Jan 2024 17:54:38 +0100
Message-ID: <20240103164903.423525522@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit be0f89d4419dc5413a1cf06db3671c9949be0d52 ]

set_smb2_rsp_status() after __process_request() sets the wrong error
status. This patch resets all iov vectors and sets the error status
on clean one.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index aad08866746c8..c773272cd3ac2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -230,11 +230,12 @@ void set_smb2_rsp_status(struct ksmbd_work *work, __le32 err)
 {
 	struct smb2_hdr *rsp_hdr;
 
-	if (work->next_smb2_rcv_hdr_off)
-		rsp_hdr = ksmbd_resp_buf_next(work);
-	else
-		rsp_hdr = smb2_get_msg(work->response_buf);
+	rsp_hdr = smb2_get_msg(work->response_buf);
 	rsp_hdr->Status = err;
+
+	work->iov_idx = 0;
+	work->iov_cnt = 0;
+	work->next_smb2_rcv_hdr_off = 0;
 	smb2_set_err_rsp(work);
 }
 
-- 
2.43.0



