Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D34923E356;
	Fri, 24 Apr 2026 13:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037675; cv=none; b=OBLZV90zdQkOMctdNcTP41WUNYXw+ggBGeDCbM+JnTR0hcl6nmg8rHjPyHXbibW0WHHI4Aow5EeF8bMFIuOfI4zSHbkhceBHVuu2OOqFqVUG/A6XlWUbh7pf5NwD+z8ZR+SsrX4wylQpBuLtDNHz1ctz2wtcG3FDx5PbzH5vCNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037675; c=relaxed/simple;
	bh=EhnXJy5lR+0hqODY43b1ATl3Rds+E1Dj9HiiM/4+Ku0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bolhl3K+QcAyG1Z9Wa0pEiJ++IZvXZo1WQm5FD7LvvEFpOOtGK95lVIo3QGNUMt9sUm29sJIn9SZNHDzCWktvIb4e5xBreSun3CH8Gpdzp7s0Om1yuYS9xIA4d9HwLkMSmKRkfZKKYx8JPtbASm2HQGf4DkbkdA/08ykqzoMTgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3lKFnsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3lKFnsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBC9C19425;
	Fri, 24 Apr 2026 13:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037675;
	bh=EhnXJy5lR+0hqODY43b1ATl3Rds+E1Dj9HiiM/4+Ku0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3lKFnsKZLrMP0j2xLnDaGOXQkksBBv/bc/U4War1l0LpUu6wU24QkWsB8q3XKm2x
	 b0mdkfrm6Tx1zS6FiuvgVXOG7/O4qXGk5BuFBl1zYxqczNRfgmJE36iOB6c1XcdSuh
	 Ara/X8FTSDO+uGqgePXG1CjSJ76bL0RKLhkZzf/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Potin Lai <potin.lai.pt@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/166] soc: aspeed: socinfo: Mask table entries for accurate SoC ID matching
Date: Fri, 24 Apr 2026 15:29:01 +0200
Message-ID: <20260424132538.529768550@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Potin Lai <potin.lai.pt@gmail.com>

[ Upstream commit 7ec1bd3d9be671d04325b9e06149b8813f6a4836 ]

The siliconid_to_name() function currently masks the input silicon ID
with 0xff00ffff, but compares it against unmasked table entries. This
causes matching to fail if the table entries contain non-zero values in
the bits covered by the mask (bits 16-23).

Update the logic to apply the 0xff00ffff mask to the table entries
during comparison. This ensures that only the relevant model and
revision bits are considered, providing a consistent match across
different manufacturing batches.

[arj: Add Fixes: tag, fix 'soninfo' typo, clarify function reference]

Fixes: e0218dca5787 ("soc: aspeed: Add soc info driver")
Signed-off-by: Potin Lai <potin.lai.pt@gmail.com>
Link: https://patch.msgid.link/20260122-soc_aspeed_name_fix-v1-1-33a847f2581c@gmail.com
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-socinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/aspeed/aspeed-socinfo.c b/drivers/soc/aspeed/aspeed-socinfo.c
index 67e9ac3d08ecc..a90b100f4d101 100644
--- a/drivers/soc/aspeed/aspeed-socinfo.c
+++ b/drivers/soc/aspeed/aspeed-socinfo.c
@@ -39,7 +39,7 @@ static const char *siliconid_to_name(u32 siliconid)
 	unsigned int i;
 
 	for (i = 0 ; i < ARRAY_SIZE(rev_table) ; ++i) {
-		if (rev_table[i].id == id)
+		if ((rev_table[i].id & 0xff00ffff) == id)
 			return rev_table[i].name;
 	}
 
-- 
2.53.0



