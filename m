Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B3944393;
	Sun,  1 Sep 2024 16:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209557; cv=none; b=PRHXN0KHSrwf0/830opZhJnWukA+PviNaHzqT15qI8kczIABF2ZUEIgK83AFfD9fyIkzTkNP+Ek6EDwpS+LjfTF8ANkNf7AIyr1Um2U/SpwoebQ+BFFdNcgoiv5SuqkyVkETZECX25Ev+fPw5HBT34yhJqd6oAfO8atVFBQL5vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209557; c=relaxed/simple;
	bh=r1j2cqFG0lQo3EpNK5Em0osHvvOKDSMbWAMp/xvEDRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWvNoTTH3fd7SikP1rKLyn21gIyWAqFfZfzKD16Nyr1V/4ABkQT6nlHJwY7W7jREl4SYASpacZ3lnnJZmy3SGXMYCrGKSdSEwvoEJ895b2Za59ajBJEDtFTul+UYLa/gi14wx7qMNZAzeWDfnpxru1h8B7EIWAjYG/ntPWb/r9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nP0VVREx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nP0VVREx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03649C4CEC3;
	Sun,  1 Sep 2024 16:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209557;
	bh=r1j2cqFG0lQo3EpNK5Em0osHvvOKDSMbWAMp/xvEDRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nP0VVREx/N8ibDsdpS/LAhlSk6j+BNJsrwNp+eQCJMEeUPBE0gpYOnY8jIW8Tb0zs
	 dG9R45VXMZZsWv5EalGNKg87iyzyYwYO6o5h+oKMX3aju7JspNXfP1yFp4b/KD5Sjl
	 pWNpS5ZhKRqSS/7ryVdJHBu0ijPYtfYRgDryzB5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/151] openrisc: Call setup_memory() earlier in the init sequence
Date: Sun,  1 Sep 2024 18:17:14 +0200
Message-ID: <20240901160816.898477232@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c6f9e7b9f7cb2..8c65810eeca24 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -284,6 +284,9 @@ void calibrate_delay(void)
 
 void __init setup_arch(char **cmdline_p)
 {
+	/* setup memblock allocator */
+	setup_memory();
+
 	unflatten_and_copy_device_tree();
 
 	setup_cpuinfo();
@@ -310,9 +313,6 @@ void __init setup_arch(char **cmdline_p)
 	}
 #endif
 
-	/* setup memblock allocator */
-	setup_memory();
-
 	/* paging_init() sets up the MMU and marks all pages as reserved */
 	paging_init();
 
-- 
2.43.0



