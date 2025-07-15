Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CCF2E54B7;
	Tue, 15 Jul 2025 13:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586458; cv=none; b=P2SPZbNMB4V+BE5znMynQgIGeKn7HFabxkhbjZIE4KSxep5v004bWSHYxFESs/8lU5Jcbq/CetmtuYx5O0eBmCHlP6arEVC156lXV3h9/BeqGVSrnm7cU6wyEaAgWAKkPG46TIcMFOA6Iioo5J/WTHeDV+w5FvvUd9r44tBNVrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586458; c=relaxed/simple;
	bh=sOssEsSYaPaABb9n8QBz93FMBhp9epvJjntfhRBPb58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxdnlcN8rNOxK4zYS5V/yFDsl7KV3P7z/bY2swPStFDjq4A/r2T8yh+Y1dH5W3QElHB5QRHCyjqIJA2JvKmr7mbWEKLlRfnQ/ptYoXnH1v1hXgPzQLbga+Ibe2X+x6BgjhK79wY3ksi66yrZc/DqySw6fKv9xoP2vsqEn8o1f+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T724QmIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T724QmIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B0AC4CEE3;
	Tue, 15 Jul 2025 13:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586457;
	bh=sOssEsSYaPaABb9n8QBz93FMBhp9epvJjntfhRBPb58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T724QmIZgF16phLwVOB6sLY8UY/a6/ztJmz/rnGzFniFxJvsN7o8jTqJyt//Uce19
	 2o3XpSHdOu7fbN17Y7HN1Kq2m8c3fJSsN5gfp7gabyatEg3VFumv3V1U3Az0/mH88M
	 mWIbOyUG2GQ5vyzfKMSv0QtWUWYBjp/Sil2Zs9+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/148] um: ubd: Add missing error check in start_io_thread()
Date: Tue, 15 Jul 2025 15:12:43 +0200
Message-ID: <20250715130801.961162399@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



