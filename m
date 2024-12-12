Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DABE221D9F;
	Thu, 12 Dec 2024 16:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020953; cv=none; b=t8d+QUbmzpFa+KrbK/n2/yfXxe+XZm3u6uWD95+mMcCIzGGVHN2Zu70xGv310M6UgrYHyiitJEQ2TBo6n9/KkT77CQuhjhMzqY5yaIA1Bw/4QBp3RvgALvmbXKJ22F9WHBF9fvPHAyen4u2ggQi9AdjOvxQUVyGb+6Da/anKDYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020953; c=relaxed/simple;
	bh=qVSz92ax17o9SlyeESPfkAVPrLLBLN0/5N6/9OMg7p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2QPl2WP+YqYvmxyRMne5BnF1grRjBtJoSLoW61aYFRG3WhkyZ5u0/R9GfMaeO92R1cjpOWgez5eDYR9Zbx7ZO66b8ixzVaiULp76Gnl2lg2SqpSq61JqIa/cQ2T6NISSBo473FvDMXPzSVJoqLzWDeajfXEf0soeOMGOp1mLhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgBoMy4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgBoMy4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8DBC4CED0;
	Thu, 12 Dec 2024 16:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020953;
	bh=qVSz92ax17o9SlyeESPfkAVPrLLBLN0/5N6/9OMg7p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgBoMy4+irH9mJGTn8t6sv3lRLePvKJoPT5gkJr6xCMPXITW51SEY8RuSAjjdHk8g
	 4EVM0BNKIoSkRrfHqQoX7J7og+O7IcQGPM4dyncdMDwUNOYmeRJRBJCbB0e0STCzLi
	 1NqdmrnRKdrKC7PEf762hiaq2og1BNMrq27JyiF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordy Zomer <jordyzomer@google.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 606/772] ksmbd: fix Out-of-Bounds Write in ksmbd_vfs_stream_write
Date: Thu, 12 Dec 2024 15:59:11 +0100
Message-ID: <20241212144414.963155186@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Jordy Zomer <jordyzomer@google.com>

commit 313dab082289e460391c82d855430ec8a28ddf81 upstream.

An offset from client could be a negative value, It could allows
to write data outside the bounds of the allocated buffer.
Note that this issue is coming when setting
'vfs objects = streams_xattr parameter' in ksmbd.conf.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6587,6 +6587,8 @@ int smb2_write(struct ksmbd_work *work)
 	}
 
 	offset = le64_to_cpu(req->Offset);
+	if (offset < 0)
+		return -EINVAL;
 	length = le32_to_cpu(req->Length);
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||


