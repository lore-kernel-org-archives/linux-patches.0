Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063162;
	b=nx3ggskr4jyNy3Nyrk64iktdMXWBw2ctAC+nLXf/b//7kgO0Y67b6UxLSyqqO1UXlscn
	 Y8HABiK/AYLXpc2FFl+zENuDJiJg3+XXGBwWkfy6RkjkdSe6VUTuqZPkdb63aGlOzmwXI
	 lLgFfgvKrnKHIcw1hfXDaHG7EApD1TkSk//hxynymRSlfeWROGZKh+lkNTKRMW7d3inSF
	 h8ZZdhcnt5vRMhMn+QKD3ElF265uHAjsyB+2l8pzkgFHSU0mw9oy2me+M+w++/JlpZW6i
	 /D+HgkEoJSxdId0LXg/wBl8ubCkyd3N9pEwsTTg71odTV5U5MVCGzeKRf8JFFCZ3vcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HSwIZK7YnJBtlgRci62wslfsA12YpEkrtfekxrkWgQw=;
	b=qv0txY70yo5I4yKmH6UZ7/Vca14ku+3PIsg7FHLaAn7zUvhvwL6dYr8ng2jqH6lpz4iS
	 X22kM6+AMNvhcYdJKq/JLYlvJzJj0+Irqkp/bFO/pEI37YGQ0S4bhTvfH9ufhoR5Of+M6
	 ckGNmQSVHapZc92u0ABADYB+NAhw+i4P8oj8V2yHLnjD+nY4uwAUWerQRiJTuvNbrsmMN
	 o/eDULv7LDLVhBlA5Swv18OtYz0jhr9kzpJBaWh16Sl9V3NERNP+AQEzSDgV7yvEl6U9z
	 +GFsTakuy5G4U+VR6N7x0ctbDiWb8nmjeo1wVJHtXyrC4JtY+szoSWYUkAlCdaFMltA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OXIJYt3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A4E606D833;
	Sat,  7 Nov 2026 14:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OXIJYt3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC9B1F0089F;
	Sat,  7 Nov 2026 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063162;
	bh=HSwIZK7YnJBtlgRci62wslfsA12YpEkrtfekxrkWgQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXIJYt3vQgKemRHzurKxXrFIMjxB12JNwkjiF0sjaeNKais8CuedEJtW+wJJOywyW
	 b03jktANJferR+ULTh+tsD61jbcLQCk4TVoVSO3SK/T7WzGV7zU4/rK3RTHNqpgttc
	 szqKXZo8Ep4LsRGRwR6yD7bAX5RLvLIAvXZOe2ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 384/869] mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
Date: Sat,  7 Nov 2026 08:51:06 -0500
Message-ID: <20261107134906.347817144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 485a9149ad406e00949327a3231b9084d7073706 ]

In an extreme and unlikely situation, si_meminfo_node() might let the
caller show zero total ram.  That could cause a divide by zero in
damon_get_node_mem_bp().  It could also show free memory larger than the
total memory.  This could cause underflow and make DAMOS temporarily make
unexpected behavior.  Thanks to safety guards in the auto-tuning feedback
loop, that should not be a real problem, though.  Fix the problems by
respectively returning 100% and 0% for used and free memory queries in the
corner cases.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-7-sj@kernel.org
Link: https://lore.kernel.org/20260328133216.9697-1-sj@kernel.org [1]
Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8fa788b0d709c..0bed1cd9e3a23 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2145,6 +2145,13 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 	}
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram || i.totalram < i.freeram) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
+			return 10000;
+		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+			return 0;
+	}
+
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;
 	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
-- 
2.53.0



