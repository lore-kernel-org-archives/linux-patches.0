Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E677C4A9BB;
	Wed, 20 Dec 2023 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ys8QVnu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45157C433C7;
	Wed, 20 Dec 2023 16:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089069;
	bh=HIobVDFJ08jq2Ay5jnoQm1o21FLMBjqPr1ym/XjdFPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ys8QVnu/pOEVY7OAgLh2xJIvhPa2Ku5dxnqTLqkCDJ9RzRj4PB6F5qXRPn9AyZkm7
	 vCqVZNMhrUGtkkyzTUhKaclmaKjfAqDxTA+UkZMZc3gu4+tLVIIADivxSgX+7TiEQI
	 gscgrBJ0Vb+bFJFBmiNjoSXrimN5NIyw+1wn0d0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 130/159] ksmbd: check iov vector index in ksmbd_conn_write()
Date: Wed, 20 Dec 2023 17:09:55 +0100
Message-ID: <20231220160937.395848712@linuxfoundation.org>
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

[ Upstream commit 73f949ea87c7d697210653501ca21efe57295327 ]

If ->iov_idx is zero, This means that the iov vector for the response
was not added during the request process. In other words, it means that
there is a problem in generating a response, So this patch return as
an error to avoid NULL pointer dereferencing problem.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -197,6 +197,9 @@ int ksmbd_conn_write(struct ksmbd_work *
 	if (work->send_no_response)
 		return 0;
 
+	if (!work->iov_idx)
+		return -EINVAL;
+
 	ksmbd_conn_lock(conn);
 	sent = conn->transport->ops->writev(conn->transport, work->iov,
 			work->iov_cnt,


