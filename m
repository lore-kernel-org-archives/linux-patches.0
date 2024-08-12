Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32BF184559;
	Mon, 12 Aug 2024 16:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478822; cv=none; b=bXIsnruAgBtv2oQavpcIDKlNMWR0eVCRRimcSI3qvIOSpKzzv0dhv+2h5G4kQZggpuASpcpOFwEHhQDPGpSYk85VhcVPCGvYhfPbKF+BklSbWnxvpExr6CeNteOMlG495w23UJy/U6J5vdCBGp0znfZpYhshys/6gmbkHQhboSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478822; c=relaxed/simple;
	bh=zOhFNhDSROrLusOBZgi2ii7XiqFFkoaqRogBOBg37As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TD3bmSmzQnmO63hU7fdWhfrh7dPzt71RPly29OabvDqFahj/vLvnHqwVBw39Z3CgK7NCLFRLTl+JY8gMD14Ms7uOvyggr4RfTMN8Nz63fHK0rkG4QnPQSUMNsdWozlaGLlkrGsNU2pO7JRyWp8drsXrhn50AVOa8u/XJj0qcSNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2OoI0Bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2OoI0Bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE54C32782;
	Mon, 12 Aug 2024 16:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478822;
	bh=zOhFNhDSROrLusOBZgi2ii7XiqFFkoaqRogBOBg37As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2OoI0Bd8Wd+PvITFqcOPpOhCF64ZRDw/5jNXGh8XxSPLUmDIeSKcwfHFU07PS0us
	 fmz71lcQ92V2YRWS68tAucx4lJxPdBBcRvgn9jHVoEUeRvdBLSGn/ulvwLZXtOOl/r
	 gjNYuSUMHxzsrg82rzDSnqOzzOKKeQDAgYmXUS2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/150] jbd2: avoid memleak in jbd2_journal_write_metadata_buffer
Date: Mon, 12 Aug 2024 18:02:08 +0200
Message-ID: <20240812160126.980934557@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit cc102aa24638b90e04364d64e4f58a1fa91a1976 ]

The new_bh is from alloc_buffer_head, we should call free_buffer_head to
free it in error case.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240514112438.1269037-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b136b46b63bc9..c8d59f7c47453 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -409,6 +409,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
 		if (!tmp) {
 			brelse(new_bh);
+			free_buffer_head(new_bh);
 			return -ENOMEM;
 		}
 		spin_lock(&jh_in->b_state_lock);
-- 
2.43.0



