Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408B53C416A;
	Sat, 12 Sep 2026 12:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215402; cv=none; b=b/GPKhtUKVB2ezbfdxiiKOOss58YU165KyWzFFQm5fjj0vLrvRp0nr6Jg1zZYlL78C2IxQ0xaNWHVSxwYb8GaJdtBXaYc7/dr6JEQ/B6kIbhtBMnZrGx/eRNHM8RadJ8lvyEUcRk5PIclRK5/R/55IAMCoLXey+iOOYKZmojo/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215402; c=relaxed/simple;
	bh=P03kS5xEQkWAjIWUOEBOTQJQxhiQ87zYfE8I89w5LSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4a7GhCsUX8db/FCLwM0lImoOUVygtZ0zVLYfOuyfGhUq+6O4iAHRfkctQyFBzJwknvV65ttPL348xe2Y/KrPIGalLFDmL/PcmVK1dgidp9OMxWTgHl+PeKuswpEORB65ZpY6hX0s9carmUx3GGmc/mJMCD0lLSR7Ah+SRmOY8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVAF5LgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVAF5LgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1312A1F00898;
	Sat, 12 Sep 2026 12:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215395;
	bh=mhxuFEAwdf4hE7vatcSsJ6rYhPwdMBOY06p8GiPLV88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVAF5LgI8J8qeTiSK1AOrnPfIrtJqrlF3iybw8bLzf1PpUn4Gpme1+i/SAkOPlkT9
	 K1rLZmIahWnnsMFfmsHsRwf4WVeoBIGphlNFbkhWaw14ghXzz/fXykUu9PWsr8gTuU
	 M2CkdtFPqzFOOLuKV7Jep0ga9rEIqDjxy/p7/W5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0524/1376] cxl/mbox: Break poison list loop on an empty payload
Date: Sat, 12 Sep 2026 08:49:10 +0200
Message-ID: <20260912065619.214554130@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 8b301c4afbce4bc3f94528441d8d5ce1366504ad ]

A device that returns count == 0 with CXL_POISON_FLAG_MORE set on every
iteration never advances nr_records, so the max_errors guard never
trips and the do/while loops forever while holding poison.mutex. That
hangs the sysfs-triggered scan thread and blocks all subsequent poison
operations on the device. The existing "Protect against an uncleared
_FLAG_MORE" guard was intended to bound a misbehaving device but does
not cover the count == 0 case.

Stop the loop on an empty payload so a malfunctioning or malicious
device cannot wedge the poison scan.

Link: https://sashiko.dev/#/patchset/20260702090849.47501-1-icheng@nvidia.com?part=3
Fixes: ed83f7ca398b ("cxl/mbox: Add GET_POISON_LIST mailbox command")
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260709155714.1893280-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 9b178abd1528e..b094aac78ca15 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1358,6 +1358,11 @@ int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
 		if (rc)
 			break;
 
+		if (!le16_to_cpu(po->count)) {
+			dev_dbg(&cxlmd->dev, "Poison empty payload!\n");
+			break;
+		}
+
 		for (int i = 0; i < le16_to_cpu(po->count); i++)
 			trace_cxl_poison(cxlmd, cxlr, &po->record[i],
 					 po->flags, po->overflow_ts,
-- 
2.53.0



