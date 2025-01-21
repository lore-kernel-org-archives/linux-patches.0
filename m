Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D013E1F0E36;
	Tue, 21 Jan 2025 18:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482820; cv=none; b=JfIv1wpRjFE6DTFeHQX78vrfLUOmWmPLiWCSXeGfMj7W1F9Arf4zSOw0ti0B81+A/qF8uFX6B6TxECRy3+1/6yImzOjtrC3owWNZvs3kP6IIkvaDAzxxNypwYDSpQ3L1hTigjsPKqzf4QPaFEO+J5KUKxoq2IMxPgZejx0teRSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482820; c=relaxed/simple;
	bh=MFC2MdanUD1PfAlC0cSkdsSFJJxabNjOl+L9Tp+hGmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jg+W5GR7nFquhDowyS3wa2aPCKh0ST2op7opPAQYMnFgUJUddn9KdV8htlSBPl+9PA2RmJ6RgjYSfx6rnzG93GxQa5kN0c0uU6mBonfLM55A5hffZj45qy2K3cSHdr8BQkGnDTiQ7eJQ958sf1JgiOYl8osely8hojqNsTB+vDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1uoit/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1uoit/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DC4C4CEDF;
	Tue, 21 Jan 2025 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482820;
	bh=MFC2MdanUD1PfAlC0cSkdsSFJJxabNjOl+L9Tp+hGmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1uoit/N2WTdD8hAskSJ/SBmbx+oXGqbYBhsjKe7DScRpXvzL8cR29nqmHMDJaIMA
	 qAGBzEwCbn7SSqhwJVJu7kTjMEtDwD+YwJDJaNjdT8Se+BiNNxF1lUPaSX0VQdWKpp
	 pQhiLt0IZJDjEXi/Bt0alBNYrFcMRtz72gYG26n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <liangwentao@iscas.ac.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/127] ksmbd: fix a missing return value check bug
Date: Tue, 21 Jan 2025 18:51:32 +0100
Message-ID: <20250121174530.454506304@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wentao Liang <liangwentao@iscas.ac.cn>

[ Upstream commit 4c16e1cadcbcaf3c82d5fc310fbd34d0f5d0db7c ]

In the smb2_send_interim_resp(), if ksmbd_alloc_work_struct()
fails to allocate a node, it returns a NULL pointer to the
in_work pointer. This can lead to an illegal memory write of
in_work->response_buf when allocate_interim_rsp_buf() attempts
to perform a kzalloc() on it.

To address this issue, incorporating a check for the return
value of ksmbd_alloc_work_struct() ensures that the function
returns immediately upon allocation failure, thereby preventing
the aforementioned illegal memory access.

Fixes: 041bba4414cd ("ksmbd: fix wrong interim response on compound")
Signed-off-by: Wentao Liang <liangwentao@iscas.ac.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7f9297a5f3ef..82b6be188ad4 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -714,6 +714,9 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 	struct smb2_hdr *rsp_hdr;
 	struct ksmbd_work *in_work = ksmbd_alloc_work_struct();
 
+	if (!in_work)
+		return;
+
 	if (allocate_interim_rsp_buf(in_work)) {
 		pr_err("smb_allocate_rsp_buf failed!\n");
 		ksmbd_free_work_struct(in_work);
-- 
2.39.5



