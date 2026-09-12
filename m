Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A44632A3DA;
	Sat, 12 Sep 2026 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223196; cv=none; b=jmtvtOMzDpNIKc/Fa54OS8CIrV7hYqJrNl7O/7FoCiFswGD+1nGTVzRdTbLJcwAzaljfUJ4KU7MEg8tR6mWiVcFNaEYBGwuoCjpPQAGePLRFawpJOFDHfYMAz1/fMLcoYXbUxELB0BYsUQJ+u/+kWLPl2HQ0cJ28LKAZtyK1NzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223196; c=relaxed/simple;
	bh=29LpUu4Fj+XL12Kwe+fWCbqrMl/hBc/PdN5ziiIA3OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3+yOzZ9YJkCHWjxGxdPdmh0cRvk6Trn/MLB8q5vGojs0b7hSnmJMwS8gOatsJS2n+60BIic2Z2/4F0giqvQr+iDdY0yXYWR32v1nHRkjC9pvmbEsi9xUYEY8en5hWbcwChcCJr/h0OoIOr7LF4VNZFRiRTYKa5M68hP3PwBXEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMEcHx46; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMEcHx46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A441F000FF;
	Sat, 12 Sep 2026 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223195;
	bh=QNFTnRl7B1HDFjSfIh6Z/3B1pXdGxXxvWPNasKa8IOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IMEcHx46hcDMphRqwMtukEpZiRd2TMXx/Bfjy9HPpLLQt+pgQbN4+RdPHMUuDByVw
	 roWfO0U84XOhXvULgJRxUKYkviHysTT6oLOtqjtv+NnWN5WKJrW80JrHpgec1Z+4Qe
	 Tti2waSI+UHxv1KrI4IhNmVUxluSr6N2fKai+p4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0740/1424] cxl/mbox: Break poison list loop on an empty payload
Date: Sat, 12 Sep 2026 08:52:52 +0200
Message-ID: <20260912065623.868415929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index fecaa18f4dd20..d98cb4ddca55d 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1333,6 +1333,11 @@ int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
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



