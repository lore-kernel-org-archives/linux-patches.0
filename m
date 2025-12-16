Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A173446D1;
	Tue, 16 Dec 2025 12:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887576; cv=none; b=n+mvx8++M1W25mVksznUy+8aWKy8LCq1lR47OmdfaxbRqEW6h9IQXuJqyZS2vjfRxeN0WPLE9dedEbfWKPcuAUzkV4HXJBOK61AWjUUDQqQwqChwhbmvaHvz45Pnhnv4rap2Xa4cUAOM2tc5ar/VFKtjBYrQ8rezXVJq5jRgX6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887576; c=relaxed/simple;
	bh=qJGu0YMvNSbupV8QJ0nc+8rQelXbZJFcMpoQ4JTWcrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRvt3g4LzP7vMQ64zFcVStjch1l3QPO8pn9YDQkMEVezXNBkveCrlQjg36Ram70Mn0xGft796xxHMpoBpmi7+M1bHlRav4xYqAdPVRkLWPkQm1NNNiD+pIDvNHcK4Lb0YKHBYskP57k9OqHgfLfNYoJHXrLN2nujcs77gY6Ugw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIW6bKEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIW6bKEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D7BC4CEF1;
	Tue, 16 Dec 2025 12:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887576;
	bh=qJGu0YMvNSbupV8QJ0nc+8rQelXbZJFcMpoQ4JTWcrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIW6bKEcu3oyV10XD4CdPzigjzGltuEzcVeUOrso+KoTbiafZoDbajiLN2rxwhvIX
	 BNQOUrRD+IQHMk1Fbd+aat+c/J8ImObnVBHHSyHzMnCVyecqAyLbhvVaXQokH0I/uu
	 Y4drXX1g3xBFWZs7TVxd/6UOf9rKtSnH2HvkEsFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 271/614] accel/amdxdna: Clear mailbox interrupt register during channel creation
Date: Tue, 16 Dec 2025 12:10:38 +0100
Message-ID: <20251216111411.194227164@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 6ff9385c07aa311f01f87307e6256231be7d8675 ]

The mailbox interrupt register is not always cleared when a mailbox channel
is created. This can leave stale interrupt states from previous operations.

Fix this by explicitly clearing the interrupt register in the mailbox
channel creation function.

Fixes: b87f920b9344 ("accel/amdxdna: Support hardware mailbox")
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251107181115.1293158-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_mailbox.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/amdxdna/amdxdna_mailbox.c b/drivers/accel/amdxdna/amdxdna_mailbox.c
index da1ac89bb78f1..6634a4d5717ff 100644
--- a/drivers/accel/amdxdna/amdxdna_mailbox.c
+++ b/drivers/accel/amdxdna/amdxdna_mailbox.c
@@ -513,6 +513,7 @@ xdna_mailbox_create_channel(struct mailbox *mb,
 	}
 
 	mb_chann->bad_state = false;
+	mailbox_reg_write(mb_chann, mb_chann->iohub_int_addr, 0);
 
 	MB_DBG(mb_chann, "Mailbox channel created (irq: %d)", mb_chann->msix_irq);
 	return mb_chann;
-- 
2.51.0



