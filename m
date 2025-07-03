Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEB472610;
	Thu,  3 Jul 2025 14:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554173; cv=none; b=R/17XLCqXkxZqWe/WPE5YTn2Ub50ej1v5OnnOphd2tu95bO1EQmxaQAgG4vYOKqb2J2rYgIyKHmsAjourL3Ikkn3Bl5I+AalhNjxd/6MenTzDQh1I2EzRJfIhIgQ6ZNOngUnqPqyOQTTS26NQg/IBb9U6dsANG5/MbnAHR8je40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554173; c=relaxed/simple;
	bh=NsGhP3o+bau5ff622TAOLpyHSVe2SHrM/P1hVUipAHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FE1KdmlO0kkUAeJSWDogp86KFaIoiZZ5FIF0aciZKx6W5vuZiizx+6Ar6yJeTlG2UmRRjnTpI0ZkoT7X+Os3NcWGO4agG8F9dbA+UnI7S4BHCshUtBUZQj1icWp0IdUPp9qWligqD6rkfA6SbyTBODxx9vCKgliLCTM0C7ucRs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ynArB0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ynArB0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8E7C4CEE3;
	Thu,  3 Jul 2025 14:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554173;
	bh=NsGhP3o+bau5ff622TAOLpyHSVe2SHrM/P1hVUipAHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ynArB0wM9TjGjRn4JoM7UR3rpfySW7HSlhfhqPPLq5yD1arSCjluzY0ajSjfwWNs
	 k1szj1FmQe5QaK8Yx0GfJ1NexunuiKMD0UUn9uXormOKLpFWTLhh80mhMAHybKqxhA
	 Uyc5e1V/GwLJZ1Ft1TYyJ8PtNp9GZ3YUeBUG/RaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/218] um: ubd: Add missing error check in start_io_thread()
Date: Thu,  3 Jul 2025 16:40:52 +0200
Message-ID: <20250703144000.096943260@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b4f8b8e605644..592b899820d64 100644
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



