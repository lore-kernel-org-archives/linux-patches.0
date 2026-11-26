Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704116;
	b=mkczcM80wtKzksl4IIy0iv76p7N14kg4g7aWMyb4TR7orJ/nMi61fP9XSpO+NtV41Ovr
	 8kiIOtyAWF43t7++cErNzwbPU4TCFTHY8jO2dWFgjVO7rSa6m7ECdg7YIYb8S1CToHifG
	 6CXzSe4GLb5Y9NFuHAhSP9bpg3j4E3vW2BIj3LKghIJIwaqkflMLEYvP7NRzBTM40hfpP
	 4/4RqRj0kTrPyEVl3z52g1hCm+JLg/w8HLQkdwXODXMu78BVb7qbRwO3NnXflrK/VdPl8
	 9rJ0VG0GdM1CUuLpK4MPw7TRDbYSTORYlYDo4ehupN3YAoiCWquNuaezisGM9fc7TUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fTM4qFQYKcpiuNHiXuocAngi8yOrfZMVd4Sakl8T7j4=;
	b=pkBVfOh4bBq5oFYIipGbMuypgmdKtErsztMGYQXHyLe5ql/ASbq1uaxRfIvr9iipszL/
	 Qmlw2GEvk8lz58e22HtzAne4bS/SOdbGCppLbkJpyxaY7jFeiBUGTbz/ptERUKWkEkJCw
	 Ztcf1b0pFbE75Uh/GMiQqsa6L1fcVDI8y8bGGdTnUrzzi4L/QcleX2kglej6Nx9crYSgZ
	 HKSjZ96JW3GKaccw5aEwy3cJOfNJ56tdfnEXxdXqZ4GceJ4Bi/HG2hqyTujYYtaqpXaqf
	 ek15VfDr3v4rXDT8xLnVegV23NtyGh4aoR99dqvV4uDUrZ4LRmRvwxY816a/7ndBgWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kn7FDsOp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF675606A31C;
	Thu, 26 Nov 2026 14:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kn7FDsOp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFFB1F000C0;
	Thu, 26 Nov 2026 14:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704115;
	bh=fTM4qFQYKcpiuNHiXuocAngi8yOrfZMVd4Sakl8T7j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kn7FDsOprRth4YPWJxIfVNywCtv/PCvBwaiNQ6RgUHxIHN5LbTVwF7PAyR8EpgTA+
	 eBsUZWWUVtsTnMgdJMVEBCXDCIL/CDhXLi+rZdGNlsP9kqn0wXKsbExXsKLohBP4Xn
	 5gPoFZJHH4EmQClKXlnxq8wljlulAeqlPWXUwl6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Tony Lindgren <tony@atomide.com>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/265] ARM: OMAP2+: omap4-common: Fix refcount leak bug
Date: Thu, 26 Nov 2026 15:35:42 +0100
Message-ID: <20261126143605.938632802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang He <windhl@126.com>

commit 7c32919a378782c95c72bc028b5c30dfe8c11f82 upstream.

In omap4_sram_init(), of_find_compatible_node() will return a node
pointer with refcount incremented. We should use of_node_put() when
it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Message-Id: <20220628112939.160737-1-windhl@126.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap4-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 0b80f8bcd3047..1553d70546c1c 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -140,6 +140,7 @@ static int __init omap4_sram_init(void)
 			__func__);
 	else
 		sram_sync = (void *)gen_pool_alloc(sram_pool, PAGE_SIZE);
+	of_node_put(np);
 
 	return 0;
 }
-- 
2.53.0



