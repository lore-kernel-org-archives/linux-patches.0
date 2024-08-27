Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D471C4EDC;
	Tue, 27 Aug 2024 15:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772231; cv=none; b=qmRfBgRrbP16xphVBOuORSkDEkZ0q3VJlpphTmW+JcnwXALAKgZ0/kemToPmLjVpg9/Mn126TNIZP2GEal/AhDc3D11ZpcDW/EziX7KbxhoG4YyPhF/h4NdC0aiOxMXLeo5RzaV/7OUeGV9oGHsR5wF9h0+nFpstmKDmAMIvcpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772231; c=relaxed/simple;
	bh=PE3pzd7qgkAtVfa012DNc/DLarDGo2dJCu0KSNXxbw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcDmNB9Aw8cA053bnD31N6RWjFB3nY7ahPt/AFv1/YRboO1nCpKuQtq99UjkmJII45QX5FeUJeeRfIvd5ahdzf6tuSnXC7KAo1n7tnzervY9lZ2rN8SqmLp+C3D3GJ+OsgwlrNJN5vJBsJzaLe6nTSP2rL8AipD50AMRYri79dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qpa2vUhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qpa2vUhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD2CC61062;
	Tue, 27 Aug 2024 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772230;
	bh=PE3pzd7qgkAtVfa012DNc/DLarDGo2dJCu0KSNXxbw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qpa2vUhNjp38vVvXEAXwQuYP6fxjW38lTbxdOlMEFNLaquAzcluX2zcgEcMkTTLEj
	 tN+y7jbpCsJ4qT1ihONHHl5h1Bug/zYannL2V2OyG5hkjwy1vxmbcpSiD567iBWWy1
	 7MDebX5hklWU3QP+hTTgKADoQqvmlPZOL9cmhR5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/321] powerpc/xics: Check return value of kasprintf in icp_native_map_one_cpu
Date: Tue, 27 Aug 2024 16:37:40 +0200
Message-ID: <20240827143844.021167879@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 45b1ba7e5d1f6881050d558baf9bc74a2ae13930 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231122030651.3818-1-chentao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xics/icp-native.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/sysdev/xics/icp-native.c b/arch/powerpc/sysdev/xics/icp-native.c
index edc17b6b1cc2f..9b2238d73003b 100644
--- a/arch/powerpc/sysdev/xics/icp-native.c
+++ b/arch/powerpc/sysdev/xics/icp-native.c
@@ -236,6 +236,8 @@ static int __init icp_native_map_one_cpu(int hw_id, unsigned long addr,
 	rname = kasprintf(GFP_KERNEL, "CPU %d [0x%x] Interrupt Presentation",
 			  cpu, hw_id);
 
+	if (!rname)
+		return -ENOMEM;
 	if (!request_mem_region(addr, size, rname)) {
 		pr_warn("icp_native: Could not reserve ICP MMIO for CPU %d, interrupt server #0x%x\n",
 			cpu, hw_id);
-- 
2.43.0



