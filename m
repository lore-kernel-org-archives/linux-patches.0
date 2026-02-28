Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE74A359A95
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302465; cv=none; b=jh/Vulzx0SqWe7YhqzU92+uvSns4zkSQaK8jaS+kIpSi8zVAUWy8WGPdYvx7fB4Cs/Ab0OikkSEAyzP1ybx7hJZ6yNvReTxGrZ4C9xxPakfDdZEzQE+UpjVBGUNeIGED7QFU5M7d8uV/M9XuV1J88Tcu7K5ESKtcVgO+nANLZUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302465; c=relaxed/simple;
	bh=kOnjKHYmfNtxEBsZxHwW0nawN5K7lOQkpBZNDQ7PsZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYT7zj5Q5jH0V+eenxpQBkZSc6+SMUOrDiSkQ9e5hvBRS+qemtcC5KukIAdCmXmHLX3yDdoVqp1w/L606m3+8uxYe+2ryWnlWdbdc9zOYDkmtMlR/3kvqDuoceQT6sznXAdv7QWasOCWTOsimPbM5kowUfR8VkTSStCrc8yoBcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aklwx4vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aklwx4vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F915C19424;
	Sat, 28 Feb 2026 18:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302465;
	bh=kOnjKHYmfNtxEBsZxHwW0nawN5K7lOQkpBZNDQ7PsZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aklwx4vm5b5pd16xCl8EEFzgrPfMHdDO7x+Uq8PRA9yoIcAeF0OsQZPIqBthDJW0+
	 11q4dSwCZd9dUbeihoEt/yYsoX6J+APdBpMUKjxrix2dalFSg96jZNw5JY0hU44Mys
	 +J/u8Miv5IlBMiHpNsDkDHfv/eDOdOZ+UrEbwR3uaa7YRfq9nZ5Jn1CVoGvo4cvwh0
	 A3G4Ylq9ehZG2URyVlmq6Y3kZKtSBCJ1wwvVHaElEj+U0WiHD/u3OoUwPHw/6bZLj7
	 CpkrREfCmmMcrvCvyTbXmcQFGiAphZfHg183nIffc1X7xZl6hHn4KRV4FeR6uJHZTO
	 2mkg7JVInZR6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/232] fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot
Date: Sat, 28 Feb 2026 13:11:02 -0500
Message-ID: <20260228181127.1592657-209-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit b2bc7c44ed1779fc9eaab9a186db0f0d01439622 ]

In the 'DeleteIndexEntryRoot' case of the 'do_action' function, the
entry size ('esize') is retrieved from the log record without adequate
bounds checking.

Specifically, the code calculates the end of the entry ('e2') using:
    e2 = Add2Ptr(e1, esize);

It then calculates the size for memmove using 'PtrOffset(e2, ...)',
which subtracts the end pointer from the buffer limit. If 'esize' is
maliciously large, 'e2' exceeds the used buffer size. This results in
a negative offset which, when cast to size_t for memmove, interprets
as a massive unsigned integer, leading to a heap buffer overflow.

This commit adds a check to ensure that the entry size ('esize') strictly
fits within the remaining used space of the index header before performing
memory operations.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 339ce5aa3c75b..7e6937e7d471f 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3434,6 +3434,9 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		e1 = Add2Ptr(attr, le16_to_cpu(lrh->attr_off));
 		esize = le16_to_cpu(e1->size);
+		if (PtrOffset(e1, Add2Ptr(hdr, used)) < esize)
+			goto dirty_vol;
+
 		e2 = Add2Ptr(e1, esize);
 
 		memmove(e1, e2, PtrOffset(e2, Add2Ptr(hdr, used)));
-- 
2.51.0

