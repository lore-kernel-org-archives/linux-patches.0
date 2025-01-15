Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68170248BD9;
	Wed, 15 Jan 2025 10:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937614; cv=none; b=ZhdNG6w3SUlYw6gKj+UGVeZno8A0pu58gDweMDAOc+TSDa05QG3zlhCWOpNh2LPoCHK9imTP0p2C3WJsY9ut5FvGS4F+ieGEJKFU5dTm5dVpOprm0i7rPKK0NVwjEu47aXj7xYl+xIoshJLK4t/t799BWtCVDWwwH6SdZ4aRlcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937614; c=relaxed/simple;
	bh=JZ+f/VsjkQDeQo159DLn/TU8El4Vxymquyz5pEJCK1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h31oMMwCgT4NMnKEt/14ty2C5i4G39Hw/6+oas/ixZJSXhKCZCNteoJdX80FwAK58Dij/9+dJp7fxfgdN5hu+4ERziik2ulcOcKh1eQxXXuHjx+HxV7IV09tScODqLPwbiCH31in1q5hcfPgeOacVRoGePF/N5ZNINe54XOIOTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRNYM3lW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRNYM3lW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5ABC4CEE1;
	Wed, 15 Jan 2025 10:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937614;
	bh=JZ+f/VsjkQDeQo159DLn/TU8El4Vxymquyz5pEJCK1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRNYM3lWcMt9bR//Q9Kt6G6c344huO6lsjk29XRWNttBPPZ30JcUmJE9enamT7rbl
	 DjEkpaD18zXWDRhacQHoSvr6we/nUd5YPpAPFsIHnnd4BoWwUYa22Lq1zM1x3vP9Qj
	 C+VyjEOUPcoy7ioLOySqChaykcwoOCsHI1wyeEd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <liangwentao@iscas.ac.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/92] ksmbd: fix a missing return value check bug
Date: Wed, 15 Jan 2025 11:36:50 +0100
Message-ID: <20250115103548.807940688@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 71478a590e83..9d041fc558e3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -712,6 +712,9 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
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



