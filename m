Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C422E77A03;
	Wed, 21 Feb 2024 13:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521885; cv=none; b=jqj20V/jYwmc6BWB+J2cXqJuq918kRf0ZRXBE69pFj9yOGt0TWvd3/RvBNtbc5DCyMvJxuJ6QGTxAWvyupsOMzKMhcTUYiHqYXIPNe2qQTOadkbPdWc3IVGklwGGRPEjXIiZ4bPWjIJy2IyoIUvieZWYS/nsvn7UB5d4QqHXQWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521885; c=relaxed/simple;
	bh=PV2yVks8201t4gg9XWhKSan4phGvPTzeehXueYGz6qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ol7QQJ+HVjnsXPBWgTkZslcSrjBrmXI/6ecbeOE2RwvctNIDPCfQPW+FBIyZ/WgoW5atw7pw1jVKL4w2W3PUQ8QLb3Dp5bHqRWs/K7pnxcerHDmOEcZsuTejB+PBVZi9Ix4Ao1iUiw1eSne+hno5DzDCjrxsqaOpWgtYFvHInWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Voa/m0cG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Voa/m0cG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32845C433C7;
	Wed, 21 Feb 2024 13:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521885;
	bh=PV2yVks8201t4gg9XWhKSan4phGvPTzeehXueYGz6qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Voa/m0cGjd/PdhUt69J2YPX15Tdw1itBoX1/yW0aGDYIGtU9BpSToT7rrEmubJVbJ
	 NcX5uzr5B0pLRiFNRM+VqBTZgbkMg3OwCcuklhffL2catRCpMKllHxXhdk6kYnMCXY
	 3gfYLxBv4i7EYAPnKPp4sobUJb/KV/tW8gc4O7BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/476] ksmbd: only v2 leases handle the directory
Date: Wed, 21 Feb 2024 14:00:56 +0100
Message-ID: <20240221130008.050124205@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

[ Upstream commit 77bebd186442a7d703b796784db7495129cc3e70 ]

When smb2 leases is disable, ksmbd can send oplock break notification
and cause wait oplock break ack timeout. It may appear like hang when
accessing a directory. This patch make only v2 leases handle the
directory.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/oplock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 2da256259722..678627659803 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1191,6 +1191,12 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
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
-- 
2.43.0



