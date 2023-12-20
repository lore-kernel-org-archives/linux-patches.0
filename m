Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25544482CB;
	Wed, 20 Dec 2023 16:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JK84qdpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E832C433C9;
	Wed, 20 Dec 2023 16:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089004;
	bh=VOkPobONuLKq/H7yLSwkczmtMG/4sF70H24xhoSg4hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JK84qdprNyH7qrbqyK7AuGPpHjGIiqijO3xGSSgIpKUv8eg+l6mU2wAHRe6yz1rjt
	 1PxMIbM1oEQN5q2jiXHTXrQ1vnft58eiE9+SQycT4jkvkuP7pqV05NsdjcxZJSfrYF
	 fhMeMcYAxIzqH0Kk/YK02GPsKzTRn4Tthxj6/XF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 136/159] ksmbd: fix wrong error response status by using set_smb2_rsp_status()
Date: Wed, 20 Dec 2023 17:10:01 +0100
Message-ID: <20231220160937.669771394@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit be0f89d4419dc5413a1cf06db3671c9949be0d52 ]

set_smb2_rsp_status() after __process_request() sets the wrong error
status. This patch resets all iov vectors and sets the error status
on clean one.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -231,11 +231,12 @@ void set_smb2_rsp_status(struct ksmbd_wo
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
 


