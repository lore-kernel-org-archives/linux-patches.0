Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399071C57B0;
	Tue, 27 Aug 2024 14:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770151; cv=none; b=emcu3z8PVWcFMzQeROM94ptDqRX/CvXQ+QHDTGh2RmQiKLDkbRHihuxvprIP9lkjVN58iqwOUrercxoaHyVi7fPEdv9hkZR8dtc75629Txg8jOTgCkTeUz7IYcQ0F9FOpxPvEbegwAKB5alVqdvPCJUQgxNWxrjLwxA3iUrVHzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770151; c=relaxed/simple;
	bh=iWDAeBo/SCMlyzIDgBSPigaoWUu+VbYp3HFGVitQjT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA4++VWd2W5njdQlSIvGhw7uASu4zF4ay6UPNVIn+9Rh8iMj7130jkpg3cko5KlXdJxGA9MnGfGpEGB0Uu9wvky2hwOLRp+u11mQzuSQ6GEi9wJ7FbFyyvWwXCz5QRZDF5dLmWXt6gvtqmPI/j4hHXw/XrO+nzEFWw8JNK+1oXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHDlspwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHDlspwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B52FC4AF10;
	Tue, 27 Aug 2024 14:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770151;
	bh=iWDAeBo/SCMlyzIDgBSPigaoWUu+VbYp3HFGVitQjT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHDlspwWCTgl3D+AVbkab8g9rnaOaOMI3OwlX7ZK9TqbH+gZRl9yfam0bE+XfW66z
	 EQOGBdFnzsa0m29x+Yw62YTkf3ZiRQY1fV+cT3YvM1f2/y7xadPXkQ80At2+zCXxAV
	 n+MRJ+2cbn3DyG4/tySHiyjxx5HnmevtWTSdS4T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/341] powerpc/xics: Check return value of kasprintf in icp_native_map_one_cpu
Date: Tue, 27 Aug 2024 16:36:13 +0200
Message-ID: <20240827143848.823922476@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f6ec6dba92dcb..700b67476a7d8 100644
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



