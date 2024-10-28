Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8893F2C697;
	Mon, 28 Oct 2024 06:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097660; cv=none; b=IoZ4DMP0TXniHK17WhOY8NSSH+8ydSr7dgJECmzYC6/+wHrM+qWzDJdUelmcsCT4MiAxY29/EQZKekNwseh4p97altVJTgKI253+lFU/Lxz9+RrdG0ElVnJ8uOkYQ05kpiHESCKjojXccT5AyVDms81FnLt8vNkIq66r1apESo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097660; c=relaxed/simple;
	bh=fhax/LK1yMF6yVs+V4kMj4mYRNP0xXXH/HQfmq9w05Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJmfhF8pJBRx1aZaLgoICfeHQwu17GH0xSjDpbh/eE3Tu6fRqpDCBuBfnh1zrzRni0/JZkcAXHhO4GfwULHKsvVjxsoJNSr/nRVQMOy4estns15VCHhqWyaHiBwWaqgQ2dLcicsn7HfeVfQEAaOHj3GaQEHedwtLlzPz54QVuhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPcAFzPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPcAFzPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29741C4CEC3;
	Mon, 28 Oct 2024 06:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097660;
	bh=fhax/LK1yMF6yVs+V4kMj4mYRNP0xXXH/HQfmq9w05Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPcAFzPymY71qv460NV6H0MjPc948PgzwhOjkYrLEhqb1KanCo5gzGkajSDvVXING
	 HlYDxExik8XGP3wFOSV1HqOy2hbaquYFI4/2DUbmvyyJAeyGiEuiFNRrWOwgNDaQzu
	 vyvBnxZmhwjmaAx7Juao9Jz/FyDl8HFF5Pu7EPp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/208] cdrom: Avoid barrier_nospec() in cdrom_ioctl_media_changed()
Date: Mon, 28 Oct 2024 07:24:30 +0100
Message-ID: <20241028062308.866498546@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit b0bf1afde7c34698cf61422fa8ee60e690dc25c3 ]

The barrier_nospec() after the array bounds check is overkill and
painfully slow for arches which implement it.

Furthermore, most arches don't implement it, so they remain exposed to
Spectre v1 (which can affect pretty much any CPU with branch
prediction).

Instead, clamp the user pointer to a valid range so it's guaranteed to
be a valid array index even when the bounds check mispredicts.

Fixes: 8270cb10c068 ("cdrom: Fix spectre-v1 gadget")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/1d86f4d9d8fba68e5ca64cdeac2451b95a8bf872.1729202937.git.jpoimboe@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdrom/cdrom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 01f46caf1f88b..54b80911f3e28 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2313,7 +2313,7 @@ static int cdrom_ioctl_media_changed(struct cdrom_device_info *cdi,
 		return -EINVAL;
 
 	/* Prevent arg from speculatively bypassing the length check */
-	barrier_nospec();
+	arg = array_index_nospec(arg, cdi->capacity);
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
-- 
2.43.0



