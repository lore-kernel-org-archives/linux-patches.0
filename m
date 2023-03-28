Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7DA8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C99DC433D2;
	Tue, 28 Mar 2023 15:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016079;
	bh=vQPU2D0/mw1IEuXFX4/vtyzUk79iFDjxAvjdQ6Znkk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtd79ciGEcHQOXwZXfKDYM6kPdz9N5SrzaMTEpDg4cANKwIokS8rUmrCp4nv80y5N
	 XI5WSbtmzI1jFAXyPYMZgTztPp6WZuFPRmzuNVFiNc/qBE639yScZXcd9+qjyGhn/g
	 ZPex2rNSlIq6k+oFXZ4feNiv84SIKocfDYYD3ok4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/146] ksmbd: add low bound validation to FSCTL_QUERY_ALLOCATED_RANGES
Date: Tue, 28 Mar 2023 16:42:26 +0200
Message-Id: <20230328142605.090773119@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 342edb60dcda7a409430359b0cac2864bb9dfe44 ]

Smatch static checker warning:
 fs/ksmbd/vfs.c:1040 ksmbd_vfs_fqar_lseek() warn: no lower bound on 'length'
 fs/ksmbd/vfs.c:1041 ksmbd_vfs_fqar_lseek() warn: no lower bound on 'start'

Fix unexpected result that could caused from negative start and length.

Fixes: f44158485826 ("cifsd: add file operations")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 305313abbc24b..45e7c854e1d4b 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7415,13 +7415,16 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	if (in_count == 0)
 		return -EINVAL;
 
+	start = le64_to_cpu(qar_req->file_offset);
+	length = le64_to_cpu(qar_req->length);
+
+	if (start < 0 || length < 0)
+		return -EINVAL;
+
 	fp = ksmbd_lookup_fd_fast(work, id);
 	if (!fp)
 		return -ENOENT;
 
-	start = le64_to_cpu(qar_req->file_offset);
-	length = le64_to_cpu(qar_req->length);
-
 	ret = ksmbd_vfs_fqar_lseek(fp, start, length,
 				   qar_rsp, in_count, out_count);
 	if (ret && ret != -E2BIG)
-- 
2.39.2



