Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6432926A0A2;
	Tue,  8 Apr 2025 11:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111895; cv=none; b=RNDPVocrV0B2YZN5PNqW6kzjy71RDjTppfR++YdIs2qiepnBCVd7IGSEzl+6IGbudFhyIZRpcZqds7MSY1nrxCxLWUBx9zltHlXr2HmZIcSBuLU580lXWv8KXbWsCqoMQToV53aJ5hBa4cxZtFicrr0LTs+b09UYUcbYJqUorCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111895; c=relaxed/simple;
	bh=l0Sqmx/EzAAQfAxp7nvoP/TARlHI79+jvYUoRqVla2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hW2PyyVfCQIqcPUzDZW09Kp2xEX2uqLuQ2jmOX0whjuVSvsLGs8eC8DQ4LZSmK79jWFi6JPT5C86Y3U65H6NUpLU2uDgsT/5AZ4w/DTPDQ+XZp03L6xjV7Ue2uxY54Swr923pFqgzcjvI59ActP4uU+DMKI/Ri1eBTADdBGpb8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtPF3Re3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtPF3Re3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86900C4CEE5;
	Tue,  8 Apr 2025 11:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111894;
	bh=l0Sqmx/EzAAQfAxp7nvoP/TARlHI79+jvYUoRqVla2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtPF3Re3R9rbmTLHJCtU4s5CJphYNf0pe7RFim2mlCjHK/NIRUIhVKGG+nv02j2v8
	 T/xPEIKbDyH+9Fslv/fB4TjEotoqE0wxJ1zGLHrH2OnlSTmKR3D3zsJXDel/UHEnvs
	 iso2bs8lUA8XoaiuRZUjjVlZzI1/reNzBZzjgF68=
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
Subject: [PATCH 6.14 549/731] objtool, nvmet: Fix out-of-bounds stack access in nvmet_ctrl_state_show()
Date: Tue,  8 Apr 2025 12:47:26 +0200
Message-ID: <20250408104927.046718391@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



