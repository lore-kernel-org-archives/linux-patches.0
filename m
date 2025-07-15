Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F7F2E92AB;
	Tue, 15 Jul 2025 13:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587548; cv=none; b=AoZTvhPL/Ix2an+45uSIRL3mvEZT7S3AXM3B+Ir5aESge3O3T0yDJxvA//usQX9yIHe0/seVXkfVShNb+6T5pSh+G8gySlpnMKtT8jNmnZFUsOSqIRdeGzOnho/PZ4Z9J1cncuAYVu9MiERwHfMmnUMxmqNypRbgMxRfodyuwVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587548; c=relaxed/simple;
	bh=ZddlqOmmI0jVU/2+HKLlfk2jus/qZAL9fkRt8iXmR/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgC3vH1RafPDy/bEkmGX1cIKNFC5xGo0XXKgIIkYd+dNg4jTkrUVW4Q2XYy/5gOZHPO7wysnN6WcKl4Qvv/U/qvqfSOnxkIl1uiI/0+vWiAdulxB+pEustcx7xPxij1rf4oCb7s5QUOhmsJHh37uMqp59nqhlXq4Hre+GJJ6Yqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6tQYT/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6tQYT/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DD3C4CEE3;
	Tue, 15 Jul 2025 13:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587548;
	bh=ZddlqOmmI0jVU/2+HKLlfk2jus/qZAL9fkRt8iXmR/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6tQYT/ryvVgSuzKroM5Bpx8oTw9RpcyySxVLMrnldxWKKZnI7A2UXin1UuEeQ/6q
	 Mn/RecKtQCJEIU1ox1UfmzNNxPeVtZMcU15XqdnrDVZj3u0nJn6ZAZBzeX6M92octp
	 2OeHgmKOmplSvg3jP8NvZJjdG0zzDU8ifINtyVjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/208] um: ubd: Add missing error check in start_io_thread()
Date: Tue, 15 Jul 2025 15:12:42 +0200
Message-ID: <20250715130813.075711520@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit c55c7a85e02a7bfee20a3ffebdff7cbeb41613ef ]

The subsequent call to os_set_fd_block() overwrites the previous
return value. OR the two return values together to fix it.

Fixes: f88f0bdfc32f ("um: UBD Improvements")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20250606124428.148164-2-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ubd_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/ubd_user.c b/arch/um/drivers/ubd_user.c
index a1afe414ce481..fb5b1e7c133d8 100644
--- a/arch/um/drivers/ubd_user.c
+++ b/arch/um/drivers/ubd_user.c
@@ -41,7 +41,7 @@ int start_io_thread(unsigned long sp, int *fd_out)
 	*fd_out = fds[1];
 
 	err = os_set_fd_block(*fd_out, 0);
-	err = os_set_fd_block(kernel_fd, 0);
+	err |= os_set_fd_block(kernel_fd, 0);
 	if (err) {
 		printk("start_io_thread - failed to set nonblocking I/O.\n");
 		goto out_close;
-- 
2.39.5



