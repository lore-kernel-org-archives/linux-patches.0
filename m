Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAC92CCC0;
	Tue, 27 May 2025 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364842; cv=none; b=e/94sCU4j0wXwIeHS6EOXHp+Q0xsBoD7S89bkcupTerbhoy8TOTV7hi6NMlzzcst24wI9Lh9tmETB+Zzq9jus7LIoW9ugH0xw4DC4IdmSEjqWeuAlWgU9S5BUxYFSmPdX34PdyWJCsYnWUX88BnLYmZjKHSDdn48vF/mYtH7KL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364842; c=relaxed/simple;
	bh=dCP24PPn9CDN/IGkYrL9HSgjHFmm2Z+R9vbEEKGzsD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeU3Zhd2VpBEjFlrxwJIXg5648vkzGR3WqnX/v7GwRs+CKHfiqCt5fme7i/ohjWVj8broTyU5bv1LmE2x7x40DnqV5+8ywoD74ZODcD3NXn+HAIaY0aX/sqs8Ahsy9eI8V2SDHiY+ZJQ49d5W3dhEnO0Oh+sdgOXXUhqpHIigFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npTN8TrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npTN8TrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF43C4CEE9;
	Tue, 27 May 2025 16:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364842;
	bh=dCP24PPn9CDN/IGkYrL9HSgjHFmm2Z+R9vbEEKGzsD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npTN8TrBjWWEaw6qy1WNTdTznRr/Qasl7v1dJ/MkHfOAIeB9igLLOw2sbONccS+fh
	 Pkqekm8rhQLxWJ5Buhq8ZcQnTI6whB+XMupKp4lcTmiw6PBt5pnu+w135P6cujovHF
	 C3fZCpErrAuvaV+EnjaoW8dMB7DuO15C47R/EXYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/626] dm: restrict dm device size to 2^63-512 bytes
Date: Tue, 27 May 2025 18:20:46 +0200
Message-ID: <20250527162451.241256247@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 45fc728515c14f53f6205789de5bfd72a95af3b8 ]

The devices with size >= 2^63 bytes can't be used reliably by userspace
because the type off_t is a signed 64-bit integer.

Therefore, we limit the maximum size of a device mapper device to
2^63-512 bytes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3dc5bc3d29d64..883f01e78324f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -698,6 +698,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		DMERR("%s: zero-length target", dm_device_name(t->md));
 		return -EINVAL;
 	}
+	if (start + len < start || start + len > LLONG_MAX >> SECTOR_SHIFT) {
+		DMERR("%s: too large device", dm_device_name(t->md));
+		return -EINVAL;
+	}
 
 	ti->type = dm_get_target_type(type);
 	if (!ti->type) {
-- 
2.39.5



