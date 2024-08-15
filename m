Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB317DA7D;
	Thu, 15 Aug 2024 13:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730365; cv=none; b=Cd9Gg63v69GFzd/0gbSdJDaZK4pQCW+OS66hW/zLzwKCZv2fdwAUBMROnJtDZnQJ5sG2WJwkG3a39uhSfKduL3aUAexSXK3t5LwkhK1kpCuu5m3U64rXJLLcdu/6G+VIMuPwddVthhX/VJREe5sMSkpMiYH5i56tIdQdIN1keJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730365; c=relaxed/simple;
	bh=MMcsLKUAnNl9kyBt5CaW93z1h4DI5VMV2YSwP9hzyOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqqiyCLHCoE1X9Y60jO5TXFONJ2qggwaWCVGbG/kk8dv9HGc7iW5zmnwhMJ1+ESdIt8VNMi5iMC+yO1kYdlba2j9EoZurkRA8IifcrlfNcRMDLbc/6Hm30AN1KQoYLMP5X80wMA6mM6HdLsmsRRx++ggfqJtptyY/TYTD41mZEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9pIlmja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9pIlmja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FCDC32786;
	Thu, 15 Aug 2024 13:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730365;
	bh=MMcsLKUAnNl9kyBt5CaW93z1h4DI5VMV2YSwP9hzyOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9pIlmjacw5b1QYCYh+5fDGjVMI+GcmtSJZfxjYlAHdUU5gX2hMl7msFvcZMts67L
	 vAHcIpoc5XFf9M6HVsOYrhgBEIDCU6IYEzSWf2fzeX2uVPtQVPFmL6qZQnqpFTmknG
	 Omtgsjb5Oix2QvarEM3sGcUPnOHrb/+W3shBJdiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 385/484] jbd2: avoid memleak in jbd2_journal_write_metadata_buffer
Date: Thu, 15 Aug 2024 15:24:03 +0200
Message-ID: <20240815131956.317886442@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 78163ef09cd2d..b10c144c60846 100644
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



