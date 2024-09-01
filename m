Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1EA17E00C;
	Sun,  1 Sep 2024 16:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208795; cv=none; b=ldCHGdyUqShprmjv2pfK6ivf64LiQWyT0tiVFjFXFrZMH8vbO4rr2Pli5/ykagM2OF4hl59SvByH36jRWM87ScReBv1mp4DDXuQ8lirjlTxmVEs8ms6TifaQst83yZnlgfDAw154PsslYOk5om2IemPPiUuLrhy7enlEMeD+Tag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208795; c=relaxed/simple;
	bh=KDN11cNtpg3d52qJzPCLDerynQFUapxl9kCUMqVPDIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfmoqK0SCvQMOLl8c1UdIXJEQhB95caBs8F1CXpOXDtYXM2W+3iy561aNUI3wQqfiTm26wjmgrQoLPyqX4UHKa6RucMcnwBnTDXzOG/abF+1rwvZkk7oq71IFK7ZH0/1z5IcwxjXGoN5qNju5xi7Ska+X+CttPTUdsUm+vGtNfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdccjEoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdccjEoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D53C4CEC3;
	Sun,  1 Sep 2024 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208794;
	bh=KDN11cNtpg3d52qJzPCLDerynQFUapxl9kCUMqVPDIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdccjEoE0DhfQWeKCqEjpipAj8xXrqM8uOiEnFN62zQd/kFV0hxeBD/ZxBeXIKHgI
	 0Akj0BtzZhcRwjmkE6W2yQT43+Cp1PRB3ghMd8nYbGVUPfYhkUccBl4vgh4Mn0SKGO
	 D2SxRj/a5ScV2gY3HtlcqJvxZHzlKuqNyr/nVB2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/134] powerpc/xics: Check return value of kasprintf in icp_native_map_one_cpu
Date: Sun,  1 Sep 2024 18:16:27 +0200
Message-ID: <20240901160811.654587166@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7d13d2ef5a905..66de291b27d08 100644
--- a/arch/powerpc/sysdev/xics/icp-native.c
+++ b/arch/powerpc/sysdev/xics/icp-native.c
@@ -235,6 +235,8 @@ static int __init icp_native_map_one_cpu(int hw_id, unsigned long addr,
 	rname = kasprintf(GFP_KERNEL, "CPU %d [0x%x] Interrupt Presentation",
 			  cpu, hw_id);
 
+	if (!rname)
+		return -ENOMEM;
 	if (!request_mem_region(addr, size, rname)) {
 		pr_warn("icp_native: Could not reserve ICP MMIO for CPU %d, interrupt server #0x%x\n",
 			cpu, hw_id);
-- 
2.43.0



