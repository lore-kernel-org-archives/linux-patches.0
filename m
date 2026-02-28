Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4C0379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302059; cv=none; b=sdUTV4tC/wmT7oG3XFbXN0jzuOPW9ZcnHoZZLOwkuVJl81vRk2v+w8Zn4hIDaWKu192om3Bjtc4lutkGJxyvCeqT78pU6mtVZgBnxFWy09IQp4rqAeH5wyp/nLhplNijawEoIVeYqUwb9nN4BQWfjoJLXdHEGGScB5G0yDnYdUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302059; c=relaxed/simple;
	bh=sqXu3nz46Er5Jq7Q2rMUAnMpi7hLfT+8X1MmsYwMe+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIQ13nNTq71lb/A70mc8bwaCgUWjxK7GiueJ0Y8RsIoDpNPE7S4qPSlqupqRO51lXSOXdr7fUnK1PSvASNj0bIKoam+4B2AOSLIAqWQl8DiSawJFFzW7Gg32UZlKu9FgYGMAm54WllPNNiYiTaMW3Yi6cp01R9HP97XZcx1kySw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oq8UDyu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oq8UDyu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD9EC19423;
	Sat, 28 Feb 2026 18:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302059;
	bh=sqXu3nz46Er5Jq7Q2rMUAnMpi7hLfT+8X1MmsYwMe+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oq8UDyu0KK7AJGeBInlvx4NDwuePrIuPLTrxbwS+4zoIoV4VdsQPobFL6vpRnL4ek
	 Zf/iI6S2Gct4r0PQaYmNXdv5VHxFdA8rljWi8zqkCNCZFR5oOhk9m3FVHTiXSqNhNU
	 wB49lPyRBTdefd8uqv+1MksJ3d0x6BtE89qzmgptkGuPYNec2dvWtVEcVT3L1VJUoE
	 DvyfcnMy6T04RfgPuOnEXRHc/8ILD7kVY9qFBVuVSKcnpkTnh00ai4HxKrf/y1ckik
	 or6gAtf00GDeNGfnjXgoLCBFpCAxcrTpm95IU6nPMfBc1wsdrJrNmKVbW32Bl8WkZx
	 V3h7MlUbda9kQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Salah Triki <salah.triki@gmail.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/283] s390/cio: Fix device lifecycle handling in css_alloc_subchannel()
Date: Sat, 28 Feb 2026 13:02:58 -0500
Message-ID: <20260228180709.1583486-36-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit f65c75b0b9b5a390bc3beadcde0a6fbc3ad118f7 ]

`css_alloc_subchannel()` calls `device_initialize()` before setting up
the DMA masks. If `dma_set_coherent_mask()` or `dma_set_mask()` fails,
the error path frees the subchannel structure directly, bypassing
the device model reference counting.

Once `device_initialize()` has been called, the embedded struct device
must be released via `put_device()`, allowing the release callback to
free the container structure.

Fix the error path by dropping the initial device reference with
`put_device()` instead of calling `kfree()` directly.

This ensures correct device lifetime handling and avoids potential
use-after-free or double-free issues.

Fixes: e5dcf0025d7af ("s390/css: move subchannel lock allocation")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 3ff46fc694f85..e50592c3d30ca 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -247,7 +247,7 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 err_lock:
 	kfree(sch->lock);
 err:
-	kfree(sch);
+	put_device(&sch->dev);
 	return ERR_PTR(ret);
 }
 
-- 
2.51.0

