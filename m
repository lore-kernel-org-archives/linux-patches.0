Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B866847F7D;
	Wed, 20 Dec 2023 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzY67/xI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D03FC433C8;
	Wed, 20 Dec 2023 16:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088683;
	bh=danh6PGY61sic5jqsqjnsMdgcy5JAW0wq/KedbjuVoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzY67/xId2qGw5BkR4AFEM0A6KzyEP5B+qlCnN//Uy5iOBbVa1ihoNkvPno5qNnb3
	 YxG98XZHZxx4QDxh23DfvpDUZN+KJovjG5chLdAc0NCzhncJoM5uNTvk9YShK16he7
	 qi11WQ8GQB0NTBt2WA8gKXTmfoQ8a5ZsSmxjFYL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 020/159] ksmbd: smbd: change the default maximum read/write, receive size
Date: Wed, 20 Dec 2023 17:08:05 +0100
Message-ID: <20231220160932.216682837@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 4d02c4fdc0e256b493f9a3b604c7ff18f0019f17 ]

Due to restriction that cannot handle multiple
buffer descriptor structures, decrease the maximum
read/write size for Windows clients.

And set the maximum fragmented receive size
in consideration of the receive queue size.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1914,7 +1914,9 @@ static int smb_direct_prepare(struct ksm
 	st->max_send_size = min_t(int, st->max_send_size,
 				  le32_to_cpu(req->max_receive_size));
 	st->max_fragmented_send_size =
-			le32_to_cpu(req->max_fragmented_size);
+		le32_to_cpu(req->max_fragmented_size);
+	st->max_fragmented_recv_size =
+		(st->recv_credit_max * st->max_recv_size) / 2;
 
 	ret = smb_direct_send_negotiate_response(st, ret);
 out:


