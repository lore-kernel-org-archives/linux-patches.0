Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806D6495D6;
	Wed, 20 Dec 2023 16:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R78Db2nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE10C433C8;
	Wed, 20 Dec 2023 16:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089010;
	bh=jsyL+kG6e9aZheIVRzIcvPW7MqVJ/75i+fej3jR1wAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R78Db2nnuR+RHwS1oMUePq9TMLAczyaX2Y34rhMn2pky/JrUwN5PbdmoAe9sLbzfq
	 gOAF7+1n/GbuTHtB9Ei8kxY+T0jSmIJGbhJVB758FAsRSPzfplY5rNg1DXt34fxq7k
	 zkwjD9PG2JGTZHjFcLrzU6MqhEyCTJvthnsb9f0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 138/159] ksmbd: fix potential double free on smb2_read_pipe() error path
Date: Wed, 20 Dec 2023 17:10:03 +0100
Message-ID: <20231220160937.771552424@linuxfoundation.org>
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

[ Upstream commit 1903e6d0578118e9aab1ee23f4a9de55737d1d05 ]

Fix new smatch warnings:
fs/smb/server/smb2pdu.c:6131 smb2_read_pipe() error: double free of 'rpc_resp'

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6154,12 +6154,12 @@ static noinline int smb2_read_pipe(struc
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


