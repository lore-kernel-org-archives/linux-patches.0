Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58DA1AC893;
	Thu, 15 Aug 2024 14:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732756; cv=none; b=NCeKmlMpURBUeY0s3x5LPU3pvIV+e0zmquusX14H8uja+yA33afm6mSvMXxu2yrXLp6JUiNq9zx4hPYUMSxrrvApXpkqKWvr62lKPd4lkcy3mR3WxKZv/WNF7zcBGrECqGwjcxZw3z6svsgUUwBGFSGIThiiamh/0L4UPzVsOw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732756; c=relaxed/simple;
	bh=yo9718unBGlHVDwumQmyOc24eGEsAi/82bfzEG4QBaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDnJHtXnyTZOUg0GH/HuhPZWtzF5dT1BPajYfyC8rNbxIzBUbaZv2V6cO49gS8k9Z++JxC0xyvGXmCKYVBNn4GDJnvwgEp2yxtHP3Cn+rvNuAJWJ7b9XqLwGMsdkrmn4xjvPtF8HiouvQvhCVvdpTKweP9QsSGsE7SA10UhnUak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwdV+YrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwdV+YrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5969C32786;
	Thu, 15 Aug 2024 14:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732756;
	bh=yo9718unBGlHVDwumQmyOc24eGEsAi/82bfzEG4QBaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwdV+YrMDZ2A0Qj/h0veWlOJRjQ8zjcc1Pao9mC47OtPmkDngE8zqU9QM50vaHn14
	 WjqpXTTY0LekN2bH4XWjE6nLhsN5POzl2F4E5/BplfrKdtj3xr7NG/Tgnb0gyan6FU
	 jjOu9KTpg/Hewlux4pY6JxvWYf1oKSPae5q3TX/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/352] jbd2: avoid memleak in jbd2_journal_write_metadata_buffer
Date: Thu, 15 Aug 2024 15:25:42 +0200
Message-ID: <20240815131930.120014663@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4ae4b85ea1877..205e6c7c2fd0c 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -412,6 +412,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
 		if (!tmp) {
 			brelse(new_bh);
+			free_buffer_head(new_bh);
 			return -ENOMEM;
 		}
 		spin_lock(&jh_in->b_state_lock);
-- 
2.43.0



