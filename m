Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6753B79C;
	Sun,  1 Sep 2024 17:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210136; cv=none; b=HEZ7odqfqhd+CaQH7yfWtm/ZJn35rCAmDJ/QesAusyo7qQPEEtW0EA0Zzo57wEW+3UBwQ465bYl1jN8srRQOhBbgQ6UzVZh7ROzwWmWVHC1e7Aa3mfl0aFGVYWxywYgVC3tQnPQLLsH/lXrDrup5WjLpAWXI3tdtSlligBTCLnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210136; c=relaxed/simple;
	bh=q8VHbLgDdv/fsbJAurdtZBUYulTn3P0doaZvNBvB6XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwdvpFybCNYj1neVBdbrxmQo9ZBuQKZ8cMhP+ju9sGhElR/PyI1+HwzfyCuAr7PBtpPpoETk9fh4JBQWoLlVxhBoMfuRUFfRTvS1+wVqnhYnJ2ozkQI+LsVnx10DW1a6YhwsgY4ycWuHowbSx2C5u9Bej4NKss9SQx42kx+wspw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhAsMjrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhAsMjrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E78C4CEC3;
	Sun,  1 Sep 2024 17:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210136;
	bh=q8VHbLgDdv/fsbJAurdtZBUYulTn3P0doaZvNBvB6XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhAsMjrwjr4ZEBqP59CizBzdSyCPnx1BlpJehDKkrk0ukv3lxZz57sXTjzTdpkQLU
	 vfobWuwlF3nnjvMuN+GqXaoV949yJ5Mm/mhVSFxxZbtMJWkEHoRZJASgxU1ag3Rco+
	 jILAWKL3nMQmFyPwtlOxx6imZRKX/mQIN7pC7WGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/215] openrisc: Call setup_memory() earlier in the init sequence
Date: Sun,  1 Sep 2024 18:16:50 +0200
Message-ID: <20240901160827.055534146@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oreoluwa Babatunde <quic_obabatun@quicinc.com>

[ Upstream commit 7b432bf376c9c198a7ff48f1ed14a14c0ffbe1fe ]

The unflatten_and_copy_device_tree() function contains a call to
memblock_alloc(). This means that memblock is allocating memory before
any of the reserved memory regions are set aside in the setup_memory()
function which calls early_init_fdt_scan_reserved_mem(). Therefore,
there is a possibility for memblock to allocate from any of the
reserved memory regions.

Hence, move the call to setup_memory() to be earlier in the init
sequence so that the reserved memory regions are set aside before any
allocations are done using memblock.

Signed-off-by: Oreoluwa Babatunde <quic_obabatun@quicinc.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/setup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index 0cd04d936a7a1..f2fe45d3094df 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -270,6 +270,9 @@ void calibrate_delay(void)
 
 void __init setup_arch(char **cmdline_p)
 {
+	/* setup memblock allocator */
+	setup_memory();
+
 	unflatten_and_copy_device_tree();
 
 	setup_cpuinfo();
@@ -293,9 +296,6 @@ void __init setup_arch(char **cmdline_p)
 	}
 #endif
 
-	/* setup memblock allocator */
-	setup_memory();
-
 	/* paging_init() sets up the MMU and marks all pages as reserved */
 	paging_init();
 
-- 
2.43.0



