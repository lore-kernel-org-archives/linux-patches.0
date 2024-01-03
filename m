Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B079D1B29F;
	Wed,  3 Jan 2024 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmvgvTRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEE2C433C8;
	Wed,  3 Jan 2024 16:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301148;
	bh=AuI9IZvJtmKvA/TNRo2i0W8y5XgboPL1kQZLuKEh8e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmvgvTRwrb+qWrchFpLI4hDI9bl8bVWdwd22oU8h2Mhq+2R/rLhN/w8CsykPA2OAW
	 nGJsjsJceY6b6pTedmzQBCUrudROo0rOsb8LtFv3PE7fEGQbQubrLeE9eMkBeNNXRS
	 KPCiU0YXtlcVNzZdFn0nLsI5i8Ui1aYHsVdA10og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/100] ksmbd: fix potential double free on smb2_read_pipe() error path
Date: Wed,  3 Jan 2024 17:54:40 +0100
Message-ID: <20240103164903.723282621@linuxfoundation.org>
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

[ Upstream commit 1903e6d0578118e9aab1ee23f4a9de55737d1d05 ]

Fix new smatch warnings:
fs/smb/server/smb2pdu.c:6131 smb2_read_pipe() error: double free of 'rpc_resp'

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c773272cd3ac2..a89a69d752a3b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6152,12 +6152,12 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 		memcpy(aux_payload_buf, rpc_resp->payload, rpc_resp->payload_sz);
 
 		nbytes = rpc_resp->payload_sz;
-		kvfree(rpc_resp);
 		err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
 					     offsetof(struct smb2_read_rsp, Buffer),
 					     aux_payload_buf, nbytes);
 		if (err)
 			goto out;
+		kvfree(rpc_resp);
 	} else {
 		err = ksmbd_iov_pin_rsp(work, (void *)rsp,
 					offsetof(struct smb2_read_rsp, Buffer));
-- 
2.43.0



