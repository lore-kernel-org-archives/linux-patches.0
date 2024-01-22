Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F774EB4A;
	Tue, 23 Jan 2024 00:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969787; cv=none; b=KtKvDrXlkfNANdP6IUAlFu/mPf6AnKvMIEt1fWZpunj1vZT4WQzatuExNxeogyLQSHMybtQ+I24NEzopsPWfXw7pvLjjU5BrdY1Vph3OeKfZLNDDgWSLTY/C4sRdNfKxB2Nn3LGhZk7f3Nh/GdJDeF7KdF1wk1gWZWbEletcSIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969787; c=relaxed/simple;
	bh=rLphiWNvQjj09MCVAdl1jB2phwM/zDCGMfHzh5jRHKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dc8iXGHCoGkNq4nvQIFm6CfDYIQs7YKftlXGHSr9BdnaSEINy13HuO0LHNeAYc/i+d3eiuskWFjYPEI4dgLYhXzUCqCB4DBC7Yk943HX2Ogav0y61+yFyWnys25GO2HqPO6rJEMzIPlWpBjbp0Z5lrQu0i/2zfZiCaC4iBg+d+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfC+cIPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfC+cIPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED76BC43390;
	Tue, 23 Jan 2024 00:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969787;
	bh=rLphiWNvQjj09MCVAdl1jB2phwM/zDCGMfHzh5jRHKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfC+cIPc9E1V01JHPH3d0A6rfHk4S6aWVC6rdd7H7CaWlMGbAbice4zFL53rXjna8
	 cy1Br34mQoQeAEczR7KadZvrOlVyW7f49t7+waS4zD2sp/x/qQebcDZxwxcCmagnzS
	 +Qa2qzuMnMTvExSXxwY2Z89COp6YPBqMKs+mmoVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.7 424/641] ksmbd: only v2 leases handle the directory
Date: Mon, 22 Jan 2024 15:55:28 -0800
Message-ID: <20240122235831.258723046@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


