Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA751B87CF;
	Tue,  8 Apr 2025 12:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114891; cv=none; b=Zvj1/STizrVH+dJp8T0GJPw5PB3ddKHFnLoxMj/E7mk8J/F1fKr6Hin2FkqyP8q2uf8yDktIeWvVv3gYXUZ18GmUX/Yqai56+mW++wxUrDtGW4RbsPTyt3OqqCQGgLTfXpnQC7qh3FXcSsHXVhCq3C2QCLn+rr6ZcE6ErMR5cEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114891; c=relaxed/simple;
	bh=vKdGpLIOlmy3ZSOAEh85BwkXxdpNd7PdiH+PkdXEhUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gs3XA5CxOcwaoswheaxrx6XroNdiiaJSCBza7LQzl+jGsy7QqC3b7RmVnEFhGtmxFz+/peluLno0d2mRDm3w23kHKwboSsP49N+Rj4DttErtNqCOO+lBQjC1shBtXeMk8YCLBU15NLC34Eu9DfCIJV+0LtlREJ36ee4zTV54IJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OopVCLJb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OopVCLJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFEBC4CEE5;
	Tue,  8 Apr 2025 12:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114891;
	bh=vKdGpLIOlmy3ZSOAEh85BwkXxdpNd7PdiH+PkdXEhUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OopVCLJb858spaTaywr6Y7i3csrcTbnGe9DFwO/7p3tVbvi6JLTFV2i0kbbsjGU36
	 bGNbL4hQfWHPzrEdUfT6NUYtEa/NSyMnQHm45K0D5b2WS2l2xdUNHZTMXOqLLwQ/xu
	 WbV16ZKPaynR/ZeK177PQoDV2Jtl+7xqDDVyAuEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 273/499] objtool, nvmet: Fix out-of-bounds stack access in nvmet_ctrl_state_show()
Date: Tue,  8 Apr 2025 12:48:05 +0200
Message-ID: <20250408104858.026713197@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 107a23185d990e3df6638d9a84c835f963fe30a6 ]

The csts_state_names[] array only has six sparse entries, but the
iteration code in nvmet_ctrl_state_show() iterates seven, resulting in a
potential out-of-bounds stack read.  Fix that.

Fixes the following warning with an UBSAN kernel:

  vmlinux.o: warning: objtool: .text.nvmet_ctrl_state_show: unexpected end of section

Fixes: 649fd41420a8 ("nvmet: add debugfs support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/f1f60858ee7a941863dc7f5506c540cb9f97b5f6.1742852847.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/oe-kbuild-all/202503171547.LlCTJLQL-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/debugfs.c b/drivers/nvme/target/debugfs.c
index 220c7391fc19a..c6571fbd35e30 100644
--- a/drivers/nvme/target/debugfs.c
+++ b/drivers/nvme/target/debugfs.c
@@ -78,7 +78,7 @@ static int nvmet_ctrl_state_show(struct seq_file *m, void *p)
 	bool sep = false;
 	int i;
 
-	for (i = 0; i < 7; i++) {
+	for (i = 0; i < ARRAY_SIZE(csts_state_names); i++) {
 		int state = BIT(i);
 
 		if (!(ctrl->csts & state))
-- 
2.39.5



