Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E031FCD14;
	Tue,  3 Dec 2024 15:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240125; cv=none; b=i57lRjik+lkvufOn5nOj70bjAv+Nh2wcYzlNyK/0cvGYWvZ3suMnT0/ccuUhWjaN8vubJKhbUpO976f/9/qdKBH/asOJ0ia6k/ml8BAxzMSgROVezbtf+IYkY986KEdlPp02q0IG2Xslzhi2/nFXU7pgMklmLU9yjJEeJjfxGmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240125; c=relaxed/simple;
	bh=ZSN1C93SMNWsxlq7XC2g7Po5C29xFDZzjW8562YBfeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBg3TcMoUt2DZppu8pv8kr1dwWt9s0VmTojW51uthLZMdgjoAYrdw67kud3F7joC1xmG5e1ez4/8wjQ2gl/tQv/Xun9IibIhR2fgEmQR7MugzNDtLy6mtJjDR4yz/pz8m/lozabFAkdeGrCEqCepdXdG4FSkhUp9gjmOhN8OOpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCndIPRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCndIPRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025FAC4AF09;
	Tue,  3 Dec 2024 15:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240125;
	bh=ZSN1C93SMNWsxlq7XC2g7Po5C29xFDZzjW8562YBfeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCndIPRBjlN7DX5fQmChraKD6w9F8lWVPiOXnV5EPTO6PRDGdCME2f1QS5ca/oGyz
	 DmMV2sc4Vk2Sq7HzlA4mQoeaVfdGMWuvVB/G82FhJOwqjWlo9NsvX5MnNxNXJnh+aT
	 wS+lOxHep4qTB9SYutbJp2CDsySSmorVm/XafCA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/826] cachefiles: Fix missing pos updates in cachefiles_ondemand_fd_write_iter()
Date: Tue,  3 Dec 2024 15:35:57 +0100
Message-ID: <20241203144744.635825994@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 56f4856b425a30e1d8b3e41e6cde8bfba90ba5f8 ]

In the erofs on-demand loading scenario, read and write operations are
usually delivered through "off" and "len" contained in read req in user
mode. Naturally, pwrite is used to specify a specific offset to complete
write operations.

However, if the write(not pwrite) syscall is called multiple times in the
read-ahead scenario, we need to manually update ki_pos after each write
operation to update file->f_pos.

This step is currently missing from the cachefiles_ondemand_fd_write_iter
function, added to address this issue.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://lore.kernel.org/r/20241107110649.3980193-3-wozizhi@huawei.com
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index bdd321017f1c4..38ca6dce8ef29 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -77,8 +77,10 @@ static ssize_t cachefiles_ondemand_fd_write_iter(struct kiocb *kiocb,
 
 	trace_cachefiles_ondemand_fd_write(object, file_inode(file), pos, len);
 	ret = __cachefiles_write(object, file, pos, iter, NULL, NULL);
-	if (!ret)
+	if (!ret) {
 		ret = len;
+		kiocb->ki_pos += ret;
+	}
 
 	return ret;
 }
-- 
2.43.0



