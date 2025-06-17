Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1E22DFF2A;
	Tue, 17 Jun 2025 15:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175261; cv=none; b=NC/RWfwq5gCAoj1ziQZG2oTGMUXHGR0qPbfsr7AhxpLdHp9ivmCVhrnLsflqu431WW+mo3YvG/RUAoxZ5lz5c9YYm1exaeWY/BEIoOWHZzufKnuxRouG99hBaTCmlcXdt/1Zbw57jG+hCJu4Cz7fYoi1nrzvftRiUoStxHBAA5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175261; c=relaxed/simple;
	bh=t+gJwPcXpMOniBpQDMN1Tyl5rxeceilqJ7IOBYA5j9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LN1CvBsedDW92rny14uqoif35SAEbsiuGXX6k0cG6y5D5Y55h4xb8bZhrLmUY0pQutvPmbH2eYA4Rl/zSIwEWq5aS+OqmJUidyxUIoM+LJskVNG531haaptA5be83BaG3/v5yQg9Yjn6KTYj4mxHzGzlCIwRQC7pk8M1zDyiqW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8vGA7VJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8vGA7VJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BCBC4CEF4;
	Tue, 17 Jun 2025 15:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175261;
	bh=t+gJwPcXpMOniBpQDMN1Tyl5rxeceilqJ7IOBYA5j9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8vGA7VJEIRoJr79jziuuuv5cRflWHkTTXWVqBllFHYmCYm2AscY+G2QQLpFcRggY
	 PTuNfOo/zpDPQAXDdasAI2W4hxRjhZkpGwggsvgI8DykKMRwP6BIDgUOcYpEz44o1/
	 /nE0PaCSK+5hRrOWoFJizHFQw8WcIMd/Bg3QQ1Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/512] bpf: Check link_create.flags parameter for multi_kprobe
Date: Tue, 17 Jun 2025 17:21:15 +0200
Message-ID: <20250617152424.008883725@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit 243911982aa9faf4361aa952f879331ad66933fe ]

The link_create.flags are currently not used for multi-kprobes, so return
-EINVAL if it is set, same as for other attach APIs.

We allow target_fd, on the other hand, to have an arbitrary value for
multi-kprobe, as there are existing users (libbpf) relying on this.

Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250407035752.1108927-1-chen.dylane@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e5c063fc8ef97..042263e739e29 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2932,6 +2932,9 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (sizeof(u64) != sizeof(void *))
 		return -EOPNOTSUPP;
 
+	if (attr->link_create.flags)
+		return -EINVAL;
+
 	if (!is_kprobe_multi(prog))
 		return -EINVAL;
 
-- 
2.39.5



