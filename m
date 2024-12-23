Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133112EAE6;
	Mon, 23 Dec 2024 16:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969769; cv=none; b=psPm/+MpcdS7DUulG6sKDxkUJZpjJek6IpfpDolJW0JcdrRHmXL7tl74S/22GJx+Zt+mF7RFGwgZHv9zOxc+kLCI+lC4qoLwJzo9wQhClS/fFvWlfB312G2bI16Od2ZSuWCuRa2myrnPXJH1RZT21P0LtXtMTp56jgT2UOnWGcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969769; c=relaxed/simple;
	bh=P21sjDcEsTxE8jrxaeg/3nRJHlRh1qvv1bl7JHLGs5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUdBzW/atFn/+wxQMKiHOn37bQnSkVVnjc3xTWiJ/GE4aGFasv+kWPItk1A1T/8uGv4hkC1wCbpvxSqTbQb9BAUfILROGaqrfKINL9c4kgNbKDVesVaT23xfure2yGqJwFEHDrIAoqpmEvng8Kn+VR1MUhHDUPtABA06LGy2HAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMAuuRHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMAuuRHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5DEC4CED3;
	Mon, 23 Dec 2024 16:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969768;
	bh=P21sjDcEsTxE8jrxaeg/3nRJHlRh1qvv1bl7JHLGs5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMAuuRHWDjsssrAToF60dFkanDleHtxgOaisHukeSCZU1nCNI7TwDvHbSW1oilbaT
	 sa6tVpFhsJCNLRDz4Db9sw0oobkLol+ugmbbmtJaCjUkIWelxrmE1VfVtqGUV6IBMQ
	 bajnTOH54LXFk3JcBZDo8MpwrZ3aKwmWVZlgAcXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/160] s390/mm: Consider KMSAN modules metadata for paging levels
Date: Mon, 23 Dec 2024 16:57:09 +0100
Message-ID: <20241223155409.350253318@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 282da38b465395c930687974627c24f47ddce5ff ]

The calculation determining whether to use three- or four-level paging
didn't account for KMSAN modules metadata. Include this metadata in the
virtual memory size calculation to ensure correct paging mode selection
and avoiding potentially unnecessary physical memory size limitations.

Fixes: 65ca73f9fb36 ("s390/mm: define KMSAN metadata for vmalloc and modules")
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/startup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index c8f149ad77e5..c2ee0745f59e 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -231,6 +231,8 @@ static unsigned long get_vmem_size(unsigned long identity_size,
 	vsize = round_up(SZ_2G + max_mappable, rte_size) +
 		round_up(vmemmap_size, rte_size) +
 		FIXMAP_SIZE + MODULES_LEN + KASLR_LEN;
+	if (IS_ENABLED(CONFIG_KMSAN))
+		vsize += MODULES_LEN * 2;
 	return size_add(vsize, vmalloc_size);
 }
 
-- 
2.39.5



