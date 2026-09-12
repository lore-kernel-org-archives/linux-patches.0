Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D61527FB37;
	Sat, 12 Sep 2026 14:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223405; cv=none; b=PDEje68wRZ5u9qb1VBNaC41icfBS4rueoozMy8i6ozE/StCQDfJE3pADm2AyMANmbiAnAJwZunb7wW0OtI9idLyB+8clK7gWt00KjBIAeuVXQr7vlVBs8kmJf3Zx7TtwVVc5Q0FtSFSk5Ix3MRng69b8tRa3F5vEoZhSHmnEbWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223405; c=relaxed/simple;
	bh=bO6ZrmISwHwOrxR5SvMUbDql3qx1fMJH7RRSCPPpWY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1uY8LCv9KRwF/4GdwztDIGpuDwZANxOiqcWqxUrFS3kpRfFlyBXqYk9pML6D9Et3Rm62QBhzLH0vl9eN05AyGP4k5o3cJKOzAOKk5PD/dSxsaLQwj6/up/5YWdOGhHIyqrrgN+T9wftMBCNzsyo6+U5S0JavTqwOzumHYRPUxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkcQ2aU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkcQ2aU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5F71F000FF;
	Sat, 12 Sep 2026 14:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223403;
	bh=VsyV8mWMvUFNL+kW2+iNu55+1hMr3YLvSzqUv4i1iao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkcQ2aU65yuE1x44cbwHrBr553/ckcSIe7DjTiZHuo5SGztAGJNErHqJW6NalQt6y
	 8iCendnLwisg9gTeRIpFtb4Y9DHhHj6v3xkxHz3lyK/6FX+d7oBjmDQZ3DJaDkSMU9
	 d488Z72uNbsnd0jrn1OTANTa9qyOkcFOmyhcD7AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0784/1424] gpu: host1x: Fix offset calculation in trace_write_gather
Date: Sat, 12 Sep 2026 08:53:36 +0200
Message-ID: <20260912065624.855308886@linuxfoundation.org>
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



