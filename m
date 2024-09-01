Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E2717E01C;
	Sun,  1 Sep 2024 16:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207717; cv=none; b=LKh5xRGKh+CZUQvUbyJIQI/QwceIxQh9HqoB78fYVcSekT/7myShuP49KXpHniCvAfQWIGQEP5fKHcKXQz4FmOwcKSSxDZdHcd+zSqSc5sI8R3BlHTZWR+vO3mFE3vKn/WtQiDPa1F5Qczy3FwY20bCCqd2b7YPZDr0XUxK0TBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207717; c=relaxed/simple;
	bh=jLd0gF9qozKn4XVnjGm58Slr2T6DzctitxFVluO8PP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQMjsSXoVyWvPxNnoMX+KIFhfDmybyvI9EWNtPEtuC57Gb7vJK2DrFf0ZFzMqxRnnC0HCj6tVVN9z7itNB/7PJQJTAgjs0a2pKBJkgX7F2bj3oM4MK3KYb6SN6Yqh74EHaXgHtCf+A0j6cuN7FPL4Ol3dEC28lVqw0DIur9OEMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRjsq0U2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRjsq0U2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0E5C4CEC3;
	Sun,  1 Sep 2024 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207717;
	bh=jLd0gF9qozKn4XVnjGm58Slr2T6DzctitxFVluO8PP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRjsq0U2/uyG7VNIbX4jAkbhrkUngeVv45qXlg1nkVWPMTswVvQnCznUk3b1XPKID
	 NS2yTq4DTpYWiRXxgAQEopNOsxC8akabTBweTMokva/B7a5O6ovl5e49tH6EkH0W6H
	 tDSJB/I3sGbGJ5GHAGUYKd4d6LUohxA8kP8VzP2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/98] powerpc/xics: Check return value of kasprintf in icp_native_map_one_cpu
Date: Sun,  1 Sep 2024 18:15:55 +0200
Message-ID: <20240901160804.641050000@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 340de58a15bd6..71278d554715d 100644
--- a/arch/powerpc/sysdev/xics/icp-native.c
+++ b/arch/powerpc/sysdev/xics/icp-native.c
@@ -240,6 +240,8 @@ static int __init icp_native_map_one_cpu(int hw_id, unsigned long addr,
 	rname = kasprintf(GFP_KERNEL, "CPU %d [0x%x] Interrupt Presentation",
 			  cpu, hw_id);
 
+	if (!rname)
+		return -ENOMEM;
 	if (!request_mem_region(addr, size, rname)) {
 		pr_warn("icp_native: Could not reserve ICP MMIO for CPU %d, interrupt server #0x%x\n",
 			cpu, hw_id);
-- 
2.43.0



