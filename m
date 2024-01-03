Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70571BDDE;
	Wed,  3 Jan 2024 17:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ImY/ECQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA5DC433C8;
	Wed,  3 Jan 2024 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301223;
	bh=fIl3pCmCYF7tynIb23kW97E8X0vm18+G8FT/HgJ4NVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ImY/ECQ3b7lF8nnNtfhOdSk9pnspZZvW7uCip74W9LwbRcfYSDOXAIFx0Z+HWTqL
	 hdtK5NkjfAqhZI1m0t59VugdyCBmCO4dRPYpk38y57u9cwlBuvL2+xX2U0pKjr1JSo
	 lUYtSh7mMYhUkx4mSVChTnI3EBUMqotpuDiYNteM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/100] ksmbd: check iov vector index in ksmbd_conn_write()
Date: Wed,  3 Jan 2024 17:54:33 +0100
Message-ID: <20240103164902.660340778@linuxfoundation.org>
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

[ Upstream commit 73f949ea87c7d697210653501ca21efe57295327 ]

If ->iov_idx is zero, This means that the iov vector for the response
was not added during the request process. In other words, it means that
there is a problem in generating a response, So this patch return as
an error to avoid NULL pointer dereferencing problem.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index d1f4ed18a227f..4b38c3a285f60 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -199,6 +199,9 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 	if (work->send_no_response)
 		return 0;
 
+	if (!work->iov_idx)
+		return -EINVAL;
+
 	ksmbd_conn_lock(conn);
 	sent = conn->transport->ops->writev(conn->transport, work->iov,
 			work->iov_cnt,
-- 
2.43.0



