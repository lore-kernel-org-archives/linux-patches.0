Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DBE2C17BB;
	Wed, 23 Apr 2025 15:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422013; cv=none; b=L4AZ2nbGAn718N6RlrMcERfZQv61CxG20+F6IpEnVX9zsvv2NASvM6w1yafxls985s7AiDl6Snc2PucLbqZiZe7rHWY363fvLzBHiVvc0DrgzFsZ+kqn1jjz8kOirrli228z1AaKWFdPTodRuzRio5r8qVs8lrhdr2dL3/RerUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422013; c=relaxed/simple;
	bh=vhruyPu7hxYCcMlyIeEUu487t08hcKKrJdN3xmYyKII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SinTx4XejpDJ+P2KQsxdEYfUhRQj7WHqsDoggHqlaEgJPXHbspO80e7N/ZohdkB7HwnIlxGoevKfxPxj1hv4jOIOtZ6BLlT+og6juwF8kqAnkZFKMW8tLOaSj5O6saAGg38XkRGBy4rwVGvfZmMApE+H/uNMYOq1l5Gi1M5ZeNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=119tlLu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="119tlLu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC3FC4CEE2;
	Wed, 23 Apr 2025 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422013;
	bh=vhruyPu7hxYCcMlyIeEUu487t08hcKKrJdN3xmYyKII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=119tlLu33ygWId2WSQZLxHyK2/tBBrgWrQX9/0RJQXTR0T7mmrHyO8BXRifE3YbUD
	 HEU8PZC3RNtpMgGGiNgaf5hgx6iVKsuP67gLVixsGDfoPXlD+aYOqyEpfPAZBQfocG
	 PMohW7a4kXFyWe+6xZWu23n+Nz0YmckcMLGUPt0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 218/291] ksmbd: fix the warning from __kernel_write_iter
Date: Wed, 23 Apr 2025 16:43:27 +0200
Message-ID: <20250423142633.314290088@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit b37f2f332b40ad1c27f18682a495850f2f04db0a upstream.

[ 2110.972290] ------------[ cut here ]------------
[ 2110.972301] WARNING: CPU: 3 PID: 735 at fs/read_write.c:599 __kernel_write_iter+0x21b/0x280

This patch doesn't allow writing to directory.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -493,7 +493,8 @@ int ksmbd_vfs_write(struct ksmbd_work *w
 	int err = 0;
 
 	if (work->conn->connection_type) {
-		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE))) {
+		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE)) ||
+		    S_ISDIR(file_inode(fp->filp)->i_mode)) {
 			pr_err("no right to write(%pD)\n", fp->filp);
 			err = -EACCES;
 			goto out;


