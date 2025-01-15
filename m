Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693E5248BA6;
	Wed, 15 Jan 2025 10:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938055; cv=none; b=KxxhAU09yWKEZb2fSoM4NoY3BD7U2EwKfJ9CYiaBYN6WdgDe3bT1lJDvpgcNmilKW7Z3w536DMrXYZ9yOoYBQJx9DBKwmf0qEdNvKWKKuU7RpNO6S9b5YzHwbDJIMWW7qtauV57vxJW8uXr1KffKH8IaMooMsAE4KFpLsTrPugg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938055; c=relaxed/simple;
	bh=Q6pEP6Qk0iX8cu+7V5atJg6t0nZSZt0yo7mZssg4moM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwUEZctkckVFBldONGlrJJV6NXi1NL9fhTQ4ikRAxgKzaVlqGqA76gxRci4ApIJg23UT0H7eHFJ7uI6DUko885jEhL/PIzQ+qopHgSGrVXPShE+sGnNa3cLxfWe8k6jDj3bdHRWrd/1ODoJVYj42K36ZD0Bzrij6FHykEW+iBc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBXnG6dO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBXnG6dO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8E9C4CEE2;
	Wed, 15 Jan 2025 10:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938055;
	bh=Q6pEP6Qk0iX8cu+7V5atJg6t0nZSZt0yo7mZssg4moM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBXnG6dOZRmeOjmF6chcL7jUEvWPpjugFNiRdqNgiwRmPxfLnMtzDclOCtbOMTVjj
	 F7pvn+yckLyNiadH698P/R8o6pW+BTxpQIuSuVU97TDKg6nG2hEzFeeuGoXQc60OA7
	 MoCy/DjAzfGoX8YZwDs3Rc0atgoqbiPZbyxFVZLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <liangwentao@iscas.ac.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/189] ksmbd: fix a missing return value check bug
Date: Wed, 15 Jan 2025 11:36:06 +0100
Message-ID: <20250115103609.151407050@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 04ffc5b158c3..f19cf67538b4 100644
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



