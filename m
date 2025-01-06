Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04531DB92A;
	Mon,  6 Jan 2025 15:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177828; cv=none; b=OyYI6fOzDAV9K6mK2SRjn4ciuTquzQMngcu7qS8v6cBtUDmk8hD6v680Kjt0uSFqPbAC2vkN6pLpCYBi37qm9DUDOhCwobh8lvwaG59JdJ2axKyMN5TbXqO+jDmjn7WB0vIN/gdG5x0iR52LsimN107aik5Otlhi+0elBA4p1EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177828; c=relaxed/simple;
	bh=F/9FkcKH0m8y23f1n4vAtVdnUem4gxvsnimA00ZhkKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmMqRyjnczcb8z808T7rCurtw64ldymJNoNVa1Gl/YU42Ft5M2UQGo9jnFgRhj/SDwmOqWqLC6TVsLcE6FcnNk7nG7ByRGiIivZJ6LE3DqUc6kO2LsAj8EXhEKlMCF2+Q3rP6LGCAIO33a7W0Mg61/4s01UIPW1ezrqakVblkKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8EVEETG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8EVEETG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3283AC4CED2;
	Mon,  6 Jan 2025 15:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177828;
	bh=F/9FkcKH0m8y23f1n4vAtVdnUem4gxvsnimA00ZhkKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8EVEETGdeIg7jyYPqjJdrFS0z8fUCVxrv++Ci4P/y1xGNI29hH0bPYanRN1hL/cR
	 iSPYqZeVmUSOg1w+aHzimQdg1KEAeJvlkWqueYo7OUl36z71ucOGw+WAVYOLv78ZFL
	 K/jfbN2sbhEHgwPhYcO8IyZB9Igh2Ohzf8uoOBUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/156] net: wwan: iosm: Properly check for valid exec stage in ipc_mmio_init()
Date: Mon,  6 Jan 2025 16:15:56 +0100
Message-ID: <20250106151144.369897077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

[ Upstream commit a7af435df0e04cfb4a4004136d597c42639a2ae7 ]

ipc_mmio_init() used the post-decrement operator in its loop continuing
condition of "retries" counter being "> 0", which meant that when this
condition caused loop exit "retries" counter reached -1.

But the later valid exec stage failure check only tests for "retries"
counter being exactly zero, so it didn't trigger in this case (but
would wrongly trigger if the code reaches a valid exec stage in the
very last loop iteration).

Fix this by using the pre-decrement operator instead, so the loop counter
is exactly zero on valid exec stage failure.

Fixes: dc0514f5d828 ("net: iosm: mmio scratchpad")
Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Link: https://patch.msgid.link/8b19125a825f9dcdd81c667c1e5c48ba28d505a6.1735490770.git.mail@maciej.szmigiero.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mmio.c b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
index 63eb08c43c05..6764c13530b9 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mmio.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
@@ -104,7 +104,7 @@ struct iosm_mmio *ipc_mmio_init(void __iomem *mmio, struct device *dev)
 			break;
 
 		msleep(20);
-	} while (retries-- > 0);
+	} while (--retries > 0);
 
 	if (!retries) {
 		dev_err(ipc_mmio->dev, "invalid exec stage %X", stage);
-- 
2.39.5



