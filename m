Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DA8372ECE;
	Sat, 12 Sep 2026 07:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198873; cv=none; b=UKxeUMc9Dmr2FYXrHvoWK9owDwAEP2QMrkIQ5QDQv9GcQRpE5NRzgleFd+rAD1FtPXJEkc6cSS3dcPlu43p2NJNUBRjQT/0OOWLoXMwG07M4MvW4ukkhUAFHn82We/6Qb7k6m6XExz2XlsFIVM9zLtCAZXC2oPDAF28Lgy/0FTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198873; c=relaxed/simple;
	bh=rD8rrh1Qub1RxsEBtMi5I2Uej8dIqJVe5alLPfoRIxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zb585bUQzjYlqjCNKEuAYJGa5Iru03MYT6XngYnMaIeAXy7u322SArn18V+yrq37sKT/ZHE2Nqf5MTkfwyPx99qsYKhmBUmxhVOyzOx7yW9VoLCyZk3/XSI4QlK09OlTNX8UqFCcZRud0X4zi11TYCoHJhucH0xOf5bu0dNENsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ND5IhkKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ND5IhkKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252CD1F00893;
	Sat, 12 Sep 2026 07:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198869;
	bh=fRJAWz2zVbZ0NN2w+Rj/M/6bxOkt9OLGqpjVQM3XSt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ND5IhkKyfbK60qSFWYetqu4/FWBvMpS8A3ON2ZPNrxD0mCPF0T3H6CBQB4LnvrUOC
	 K6g1A8eydczoJrVIzkVjuNQCo4Ef9NSrVBe5HyBmRcrlA4UzjfascGjO3udvbstgAm
	 foaPCbfimeUe6tsZHYfq7ZrUThvbux9ZHPN8JgII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0470/1815] gpu: host1x: Fix offset calculation in trace_write_gather
Date: Sat, 12 Sep 2026 08:37:00 +0200
Message-ID: <20260912065659.920066091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit eb896850964d3dfce291b4fdff9c2d42d85e564b ]

When a gather longer than 2*TRACE_MAX_LENGTH (256) words is traced
through host1x_cdma_push_gather, the reported BO offset drifts from
the third iteration onward.

Fix the calculation by properly calculating the value on each loop
rather than accumulating.

In reality, gathers tend to be pretty short so this is unlikely to
ever have been observed.

Fixes: b40d02bf96e0 ("gpu: host1x: Use struct host1x_bo pointers in traces")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260609-b4-host1x-small-fixes-a-v1-3-7c1131c0b3ad@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/hw/channel_hw.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/host1x/hw/channel_hw.c b/drivers/gpu/host1x/hw/channel_hw.c
index 2df6a16d484e0..9dda73199889c 100644
--- a/drivers/gpu/host1x/hw/channel_hw.c
+++ b/drivers/gpu/host1x/hw/channel_hw.c
@@ -36,10 +36,9 @@ static void trace_write_gather(struct host1x_cdma *cdma, struct host1x_bo *bo,
 		for (i = 0; i < words; i += TRACE_MAX_LENGTH) {
 			u32 num_words = min(words - i, TRACE_MAX_LENGTH);
 
-			offset += i * sizeof(u32);
-
 			trace_host1x_cdma_push_gather(dev_name(dev), bo,
-						      num_words, offset,
+						      num_words,
+						      offset + i * sizeof(u32),
 						      mem);
 		}
 
-- 
2.53.0



