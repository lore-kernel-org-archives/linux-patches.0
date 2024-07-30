Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190821A6161;
	Tue, 30 Jul 2024 16:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356938; cv=none; b=eiX7F92Io4CTWVLqDZKoReZRFGYgLUrB0ime8iJb2zoRvhpVG1The3xgHO204tT3FE/BwtVdX4yQx/p97oO0yfNo0iS5b5JPCyG54U5cx/9DeXvAdQdGW6Dpjwi4UdN9tu9hTG2pwm460hf+QyBnaEPtlZL1VV8iTs8uwV7sKF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356938; c=relaxed/simple;
	bh=bdGvri8pleFNzuPh2vHGjzHxCYMFIadQz9Za1OYjHyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYVh9655bZIJ5Qj5pq0DwWY2SNBCJbJX93hJ85Ooqk+TO3txWPMHF/Wlq68xMM/SlM3NZZ/Vr6Gbr/xqfG3Mnhalve7Js5zDwmxCMKnup/LR6dZxHRBXxLCn0cPao3T5TuqeKS9reSIioCbUooryEnMiQWAd5VVmbhU1fU3Hdak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBN867TA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBN867TA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F39C32782;
	Tue, 30 Jul 2024 16:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356938;
	bh=bdGvri8pleFNzuPh2vHGjzHxCYMFIadQz9Za1OYjHyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBN867TABtKLcRVH4bMJUk0t+kE0nWNrxhWsVfc4KADUgtFb160o6pLYrJNAlc30z
	 RiZkql9mPPYjCFDT/EewKu2HrZw2eBpZq9OienxWDL5o9nDzsoo29LlW3SGW9kRAc0
	 LeObDBfiZy83XMqpJisYSVJ37C/j0afZtqYCY6VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 243/440] fs/ntfs3: Add missing .dirty_folio in address_space_operations
Date: Tue, 30 Jul 2024 17:47:56 +0200
Message-ID: <20240730151625.344576712@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 0f9579d9e0331b6255132ac06bdf2c0a01cceb90 ]

After switching from pages to folio [1], it became evident that
the initialization of .dirty_folio for page cache operations was missed for
compressed files.

[1] https://lore.kernel.org/ntfs3/20240422193203.3534108-1-willy@infradead.org

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 0130b8583bf5a..28cbae3954315 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1967,5 +1967,6 @@ const struct address_space_operations ntfs_aops = {
 const struct address_space_operations ntfs_aops_cmpr = {
 	.read_folio	= ntfs_read_folio,
 	.readahead	= ntfs_readahead,
+	.dirty_folio	= block_dirty_folio,
 };
 // clang-format on
-- 
2.43.0



