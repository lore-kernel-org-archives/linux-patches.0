Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDD565194;
	Tue, 23 Jan 2024 01:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971645; cv=none; b=qi0dS2i10Y7gqX8p1HJ916AoUrzaHMTt/B52TW4g0nKkIvz7VwTDjLjZFGI+wtbvItcZJPQXZBjGQ8DxjJSmHE2zaUqmrYuEI/sS5KqtBcHcwNwK5AGOjcj8VlrIBTbSbGA5O9iZE8RqRRXySb2C2oyhFeIwr6Hjjy7LgBW9ois=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971645; c=relaxed/simple;
	bh=byPOh+jAhoHEVSkiiVtuq9j4DYSfgq31BpAyTp+StHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiCwuXFeshlnwgJi5wTp+MW/P4A+uvuFyPMlrgzqp1E6pqTWOySBb3WN58JhSS2oEbaHRLdwRr7cLKxWiZjufCd5g9He8Dj6rm7sy+i81ZaHpukMUg3/eQNS0TCSbDQ8Ssk8AN+3sVLEI+8m72bi1ILPfA3i4y/ukx8vOx+1yyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBA34ooR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBA34ooR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2A1C433F1;
	Tue, 23 Jan 2024 01:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971645;
	bh=byPOh+jAhoHEVSkiiVtuq9j4DYSfgq31BpAyTp+StHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBA34ooRQ8GkpP/9FJin6axUb3pDFG3Xq5W6C52PTyezZUbk6nE3yLFlKuwebxRC4
	 TGOxKdYMZjwDEVTwMzrIuEv6ZRDK58lxhUnFjVow2IMm7ZhXaswJB3yxJts+kqdBqt
	 TNszAz/KquZHy0cAui7aweML0olhwUMbcvBv3884=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 285/417] ksmbd: only v2 leases handle the directory
Date: Mon, 22 Jan 2024 15:57:33 -0800
Message-ID: <20240122235801.705609242@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

commit 77bebd186442a7d703b796784db7495129cc3e70 upstream.

When smb2 leases is disable, ksmbd can send oplock break notification
and cause wait oplock break ack timeout. It may appear like hang when
accessing a directory. This patch make only v2 leases handle the
directory.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1191,6 +1191,12 @@ int smb_grant_oplock(struct ksmbd_work *
 	bool prev_op_has_lease;
 	__le32 prev_op_state = 0;
 
+	/* Only v2 leases handle the directory */
+	if (S_ISDIR(file_inode(fp->filp)->i_mode)) {
+		if (!lctx || lctx->version != 2)
+			return 0;
+	}
+
 	opinfo = alloc_opinfo(work, pid, tid);
 	if (!opinfo)
 		return -ENOMEM;


