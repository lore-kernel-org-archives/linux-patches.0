Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C7E84DFD;
	Tue, 14 May 2024 11:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687520; cv=none; b=csZJydkOy2pfcpsGz9/Xn9x63ojRCb2xNCzZ1LcemI2mHks8en30CaEVpC8utuJkANI1pBNJf9epp9/0S+CYBSVSQo9k3fB7GvTsCUXxqvcNvkatL815B/+d+/xhaNOmUbea8AHKSQAkhMmqqQUC1fKr7ixXsj85tDWsG41Ghj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687520; c=relaxed/simple;
	bh=We8pZBDTPugK5JLanYkYIunRp2j/vmg7z2hCeU7I8mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3+r/55F1wxaYgHhABwrqlcjIbbzIOpF396Y7xVOQQoOZaJe0wiHOetu3jtaImEHCjTxeAx2Gn+d1M+QmnnyHi+utQzgMULy9gBKo0y8x4xAXKlmf6L2ckozyqb7A2KFcZO9IHO36+2jNBNpVJb+RZlyXksPt7ybtb4m5dBS68U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzxbWTGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzxbWTGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD26C2BD10;
	Tue, 14 May 2024 11:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687520;
	bh=We8pZBDTPugK5JLanYkYIunRp2j/vmg7z2hCeU7I8mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzxbWTGC3fVm6wHQ/s3K/PflxzzgxuTin5uzZsOhC5CBvLatGn7TH4sWVj2HsA+q1
	 uH50HYCmKg/x/z0QZjVGdp4Lexnq9dZo+PXneUgb/7SMgnRm4LbNtwKWU+sA0U8t+2
	 YDoIl3r40iiQiEQNggAa+GosREg4UraBjL37Z2xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/168] ksmbd: validate request buffer size in smb2_allocate_rsp_buf()
Date: Tue, 14 May 2024 12:18:23 +0200
Message-ID: <20240514101006.887460208@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

[ Upstream commit 17cf0c2794bdb6f39671265aa18aea5c22ee8c4a ]

The response buffer should be allocated in smb2_allocate_rsp_buf
before validating request. But the fields in payload as well as smb2 header
is used in smb2_allocate_rsp_buf(). This patch add simple buffer size
validation to avoid potencial out-of-bounds in request buffer.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 86b1fb43104e9..57f59172d8212 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -536,6 +536,10 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 	if (cmd == SMB2_QUERY_INFO_HE) {
 		struct smb2_query_info_req *req;
 
+		if (get_rfc1002_len(work->request_buf) <
+		    offsetof(struct smb2_query_info_req, OutputBufferLength))
+			return -EINVAL;
+
 		req = smb2_get_msg(work->request_buf);
 		if ((req->InfoType == SMB2_O_INFO_FILE &&
 		     (req->FileInfoClass == FILE_FULL_EA_INFORMATION ||
-- 
2.43.0



