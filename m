Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1F4343893;
	Sat, 12 Sep 2026 12:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215616; cv=none; b=h5uTUfP6WBpbFoOnZO1QqUTFdPi2iQMFdqw8+hKHdUIcXNjWdkAEJPfJzFnCO2fF9cBJuTJdaMb2XIfMPcVJW1hDJgCdj6x6aMGuCVeiaEenJUgnM7rBEuOWVxJts1HpYcR1Wfuvrx4pi6Q6I9cP6VVbXDRLTHGui+QOi1lnho4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215616; c=relaxed/simple;
	bh=V9aAGgwZkvKdnf8jUh7wDgyF/QPfpwq52mAfYDkUOB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7jltApC7DBeh1F2HbERvy9JmSJIG1F3nB0+mhrZZBn7R+mFc8c2HE+M8fYDbVma94ORDYiZ/4O9C82JXUw+yn3ydjPnsW3fR+TjiiKrVdD9IdW5u44HGKzPzJRTmRXDDg1fdkLF4hWzNs0D8kG5o9YU/Sp8zotKoHL/j+KMIZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSzYTSdJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSzYTSdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE1B1F000FF;
	Sat, 12 Sep 2026 12:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215615;
	bh=njI81yzq6pw8SFmv5H7p5fa/9kDvwl7LS0efUkuguUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSzYTSdJKasUS3c/ngosRaSFIUzDC6MnuNuYTd4YXAgfDnpb8/euHCcLzq1fKU+oj
	 rSLb+pGDhGqNVU05hmhvizKjODiJcZH8vT6bgeyvrw83K4pAL7yER665dlkqdAVTY+
	 aVTZnDxDRmjwVpeUPH3F+SRvDQT95aOsdrKRexEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0569/1376] gpu: host1x: Fix offset calculation in trace_write_gather
Date: Sat, 12 Sep 2026 08:49:55 +0200
Message-ID: <20260912065620.212725121@linuxfoundation.org>
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
index d44b8de890be0..46b6494768b4d 100644
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



