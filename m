Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1A42E6D0D;
	Tue,  8 Jul 2025 17:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994048; cv=none; b=NXrIi3mM7HbeOgrBJofRPhy/wp62qe7GqwkaYlsOjwiM2U7g8Sh3JiYaALIcuJ73Jn42e1KtU/QKuG75dvtAyxTtkpXzDtLDLa/59b0PyYIYsBDE0176IGfI+QUn/p5kEK6vzG0ZpCVggVELQQukyqWmQpMtJOOyCe7T9+d27fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994048; c=relaxed/simple;
	bh=nEYXjucQQ/AD7FFq/vQibu0/aAKnrkM2Nte+yEIV10Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2opkbhFs7jo20smOOGflU58zMSsIGSXxX1rwrcwCU7SSg9XiHE0WtOlvQQ9Sm5zxcZc24NISknPIe3/V8nl8TYM59xjSJ0fqlSOptR75DgXzghO9bIoKUCor8tSKZnxGBsod6z8kJyxQ8PfWQOtC4XPoZ6zmZBZVAmptDyXgwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8n2KPfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8n2KPfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF0DC4CEED;
	Tue,  8 Jul 2025 17:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994048;
	bh=nEYXjucQQ/AD7FFq/vQibu0/aAKnrkM2Nte+yEIV10Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8n2KPfnXygUqiviOnIObmxi07+VnJ72AUhqzqO7VrUy7rWn6UjYZl2ubTMirAqyI
	 KW2K+VwyknZy7fZUJm+ow6zUJHsyKkFRBg2Nh3K52+oSeghG5/LOWju3UjmY4tRPB8
	 WWX9CQujcJ7aKEQRhMUMmG90IKKsNCjzFB7A1wfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/160] um: ubd: Add missing error check in start_io_thread()
Date: Tue,  8 Jul 2025 18:21:45 +0200
Message-ID: <20250708162233.434125281@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



