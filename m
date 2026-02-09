Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89134276028;
	Mon,  9 Feb 2026 14:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647815; cv=none; b=lOsv+3uC4DVKjQ1A0AN8J7buaU0FvshT1QHlnjVFp3IEO5JvSmGwBKO0Qq65cVQCPvC8njBg1EkNuIozGt7UzpInNTdyFVOatM3L8XswtYy8bJQg20uxUHyjJWtVQ1wMiSQGIMdXpu7LgVKtLa/u4z3yeLe1fpJA6eqKqTupgbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647815; c=relaxed/simple;
	bh=6Q9nVhahmSBtFbaYbIlgx5T/S57D4PvP5KVg2xhQAe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3RZBbaRQEEWx3zn1WqyN4kxSdRSrgiyAPuggAODGhxJ9gIWItS5G28YGQBUm6thnfAiAAhwg4Z3WZC9mdPrCW8staj9J7Rp2fRXyH4280aPf8ZA2VfSLoPhrjg0QWi/5iTBU+g9qhElcgirR8qqcoa5Z4O6tAXUL5KADzKnW1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvjJ7BVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvjJ7BVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDF2C19422;
	Mon,  9 Feb 2026 14:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647815;
	bh=6Q9nVhahmSBtFbaYbIlgx5T/S57D4PvP5KVg2xhQAe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvjJ7BVFgwR1+Xr9kRzOZYpbVPSuGkMeqPmlAU8Fixxweua68Stwi9bFUEa512t8j
	 1XmmmnA+8ZN6Ol1OAyomkj+kBEW2AAZ8vo3cNDxe8shnHqimLE7IYMU3Z5KZPrRd19
	 eYCiqLsZRFUUYoK6Gc8d+Jx8KE9dY4i3NIIf68O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/113] smb/server: fix refcount leak in smb2_open()
Date: Mon,  9 Feb 2026 15:23:06 +0100
Message-ID: <20260209142311.542272608@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit f416c556997aa56ec4384c6b6efd6a0e6ac70aa7 ]

When ksmbd_vfs_getattr() fails, the reference count of ksmbd_file
must be released.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a3c0754e3822b..5641faa1f8952 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3006,10 +3006,10 @@ int smb2_open(struct ksmbd_work *work)
 			file_info = FILE_OPENED;
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
+			ksmbd_put_durable_fd(fp);
 			if (rc)
 				goto err_out2;
 
-			ksmbd_put_durable_fd(fp);
 			goto reconnected_fp;
 		}
 	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
-- 
2.51.0



