Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D109248BD0;
	Wed, 15 Jan 2025 10:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938639; cv=none; b=shzJ8ADpCk9XyHrBEPURKb0fExBTVlzZSFFbRLwOTlTFYyt0QJYf+jog6JSEOeBKEuD3lnqzOc9UdqhIccibBkdZvmnfd91UJmQXP0JPMTSTnDN1Dq3hbSuTBd/97WEQG/1iwQx41XkR1Pw6E97VDK9lGEznzdaKR75N/4L+R+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938639; c=relaxed/simple;
	bh=CJSZrWYUf9aQ0Sc9lbVA0o+dLCdAqNU6hCmBTHp0j00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONSx4Yqtt14h0XPVMNED9jFB9y4rWHNs1YxFYIaV2O7vIqBSaDtjp7OIEKXljbiLCFLNoDb3geBf4E66Uzt8zjtzy2evtG6EG8l4RiU0r9IHG4ZIqtSIRfsW5LWlZE2CbYitzaTZRURcXLf9wNm63pQjUExZ7oRVngfS/fnlRe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duIYXOeT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duIYXOeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC8AC4CEDF;
	Wed, 15 Jan 2025 10:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938639;
	bh=CJSZrWYUf9aQ0Sc9lbVA0o+dLCdAqNU6hCmBTHp0j00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duIYXOeTRCXknWWXtFAFhxH00Hn7xXm+guM3mm3OmyNHiCJIyF9d0+628KQ/5ANrt
	 W4OkGx9oCcSk2DewGL0TCRqxVnP/jezUL9qzmu6U7QYNiPmnxVJ/Rx8m/cJK4XkG+i
	 VYdb4lqRpjnVdJ/gyeZVT1zpl49ktfd3QjITSTyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <liangwentao@iscas.ac.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/129] ksmbd: fix a missing return value check bug
Date: Wed, 15 Jan 2025 11:37:07 +0100
Message-ID: <20250115103556.447579908@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2884ebdc0eda..94b4a2565b2a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -695,6 +695,9 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
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



