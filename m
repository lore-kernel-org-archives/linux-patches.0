Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677C12F0032;
	Thu,  3 Jul 2025 15:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555673; cv=none; b=TzaSKA9ZofjyegeFQS3zmOEJdOAGfrYVn16IpOnjpBOJEDqwU7a2z+4AVo9/YOSnafsHJrv715NKNCzogjWRmWQkWZu1kPnCxG78PVFlZ+xPh8Fgd7bGdHr/G2Sa+iW326xpU7YhdwqPa91JODilItKjiA+fT6HLu0pwyoCuv/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555673; c=relaxed/simple;
	bh=XNnWEvwCqtCEiRFRWfVzciJSE1WI8v9s8y4/DJjBpDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVnS3qv74xUV3SPebt55RqCgNxM0yArWYf5WyYHpU+9N+7GMfXOc10lvRZp+yDCvUHHmuPxFs7Rhne7Tp7hFPuaabUmm8JeRGE2GszPGuT5O7asPR+t6gu4K7boH09Bj6qaqTX5F0zkEywFJOh6kzTUBbYRRztDjpAt5RbUCP8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMUbdFDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMUbdFDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FCDC4CEED;
	Thu,  3 Jul 2025 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555673;
	bh=XNnWEvwCqtCEiRFRWfVzciJSE1WI8v9s8y4/DJjBpDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMUbdFDWLyv8CiC0anQv4a8SUGAuA7RnHButlguPsv+/8ePW+AzAcxPuKlb+5PJOi
	 6mXrUe7e2wxiHteBFaQAID9k542gABWx4NH6SMQ8/txo7KP9x//+2pQZjGqVN8PhB/
	 WyPh/4PldR5npMQ5Y0mnFHtXVfY+gW5Gnouqcm00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/139] um: ubd: Add missing error check in start_io_thread()
Date: Thu,  3 Jul 2025 16:42:28 +0200
Message-ID: <20250703143944.480661563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



