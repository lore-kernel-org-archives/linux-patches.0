Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3624F47A86E;
	Sat, 12 Sep 2026 12:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215396; cv=none; b=MjqXjBu4pNCeERm8iARt17p3xYRQ3x825/1q+ARFozgS8t8DnUAAjBYxpwQqsBQn6MZabufvIV1mMKY+xbJ0nCQ+WoUV/EIi2SKGEcXjT1xLLE1ObDRfidq3zpZd8PyzGWTXL17iHFXu8ZU5vk3BcQirN95ljeCVAbinkvUAYus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215396; c=relaxed/simple;
	bh=iMHSmLb05sKG3k8JgYDWCTJwQaCOfBYMz5HeM3NYROo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAzjzvhxmhe8IlD/xGdIBWKO8mAX0Ofx9rhNgvuc3RJ6PxSa0pIvOUkw1+TtsGX+qNKXqm9xmUUmMl6C9HdvtJcFPSGyznvtG4FaGhtq539PWj4VX/2GCs7NMR0yAvB1zZ4QV5zh1TatSHi/fZ9TtePe5qgQLsEcKUuJ5aeW6io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHs1CYyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHs1CYyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577E21F000FF;
	Sat, 12 Sep 2026 12:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215390;
	bh=n0lIruvSuHz5xvdn1YCb/QMvRk4fUGR/zKeh8KCDAKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHs1CYylinw7Dn2EZm5trZU3ytg0wZDeEkSRFsLHx1yvORGDJqN6RPd+wJYGC9wSG
	 pdzXWM19MrOQTomO+Az9TDoQOPyGoF2osnHw5mYCqCuFAtRAkyVJT3jmdJq/iAPwyN
	 4abE4KZFOSmulpe3cPRxP461PWZqnngnJAw3+g0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guzebing <Guzebing1612@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0523/1376] cxl/memdev: Fix firmware upload exact-fit handling
Date: Sat, 12 Sep 2026 08:49:09 +0200
Message-ID: <20260912065619.193067118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guzebing <Guzebing1612@gmail.com>

[ Upstream commit af5035e1b3e400067bb003975936e5407377e7a3 ]

cxl_fw_prepare() classifies a firmware image as a one-shot transfer
only when its Transfer FW input payload is smaller than the mailbox
payload size. An image that exactly fills the payload is therefore
treated as a multi-part transfer.

The firmware loader invokes cxl_fw_write() only once for that image.
Since both offset == 0 and remaining == 0, the multi-part action
selection sends INITIATE, never sends END, and then attempts to activate
the target slot.

Include equality in the one-shot classification so exact-fit images use
the FULL action.

Fixes: 9521875bbe00 ("cxl: add a firmware update mechanism using the sysfs firmware loader")
Signed-off-by: Guzebing <Guzebing1612@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260713112744.2543829-1-guzebing1612@gmail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/memdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 4d544a55ac3e8..d2a554c2f92b0 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -845,7 +845,7 @@ static enum fw_upload_err cxl_fw_prepare(struct fw_upload *fwl, const u8 *data,
 	if (!size)
 		return FW_UPLOAD_ERR_INVALID_SIZE;
 
-	mds->fw.oneshot = struct_size(transfer, data, size) <
+	mds->fw.oneshot = struct_size(transfer, data, size) <=
 			    cxl_mbox->payload_size;
 
 	if (cxl_mem_get_fw_info(mds))
-- 
2.53.0



