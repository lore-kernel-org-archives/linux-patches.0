Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8EA32C8B;
	Fri,  6 Dec 2024 14:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496654; cv=none; b=bQdcCLnV2diBZqKhQv66nckXmqrbwFA0IdBA4NM+bICwVnWDnY4IaFigjwnaw3AZyPLzPrpZ9kwUpI+0UmrXSbvfDi10i+iF4mloBD0w496D3s8qrIBQJzGVczPKrsopJb0PMXnRG8KYjC3NVRZeiKwE3pwPoaKkzoU81MJGyuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496654; c=relaxed/simple;
	bh=KfNskhhUiXcfaQU//Tbuz6cfELPVXzv8xmwqjuM3qGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFvaoVTfkRUxif/FxCJt/dstfp7kW2NXy8dX8jNKWQC6931g2j+z6uRCPDl0lLTtP94Sk4hi07Q31+bW5pbgeoHUkLLdQejP2sfkFi/NhlJ9s/EraOa4CxuNgciuXUDSOya5fPYy0B7KBFsGFGEb9d4Gb429WxIR6LFj0SnUWVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELOhjJop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELOhjJop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF40C4CED1;
	Fri,  6 Dec 2024 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496654;
	bh=KfNskhhUiXcfaQU//Tbuz6cfELPVXzv8xmwqjuM3qGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELOhjJoprEXKq00Uoz9GMDBTJb75sZtSCKgPIGX6asXP7CcLMl65KpZnqosxLGeiW
	 PoG76c2bkxbA+4bIjqkFpAMDqysWRepAiSq3rHLzn8Ow1jtoTAX+OVdEQaF22N+tmC
	 4o+yoUq95IQduf33rOOBy5LgSZSjKXTeAsYQMpVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/676] cachefiles: Fix missing pos updates in cachefiles_ondemand_fd_write_iter()
Date: Fri,  6 Dec 2024 15:28:05 +0100
Message-ID: <20241206143655.937143281@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2185e2908dba8..d1a0264b08a6c 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -78,8 +78,10 @@ static ssize_t cachefiles_ondemand_fd_write_iter(struct kiocb *kiocb,
 
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



