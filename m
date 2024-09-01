Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A60D17CA1F;
	Sun,  1 Sep 2024 16:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208873; cv=none; b=Rrw+YIrCTZLgqLat7X4xOcGPpnncPWqUC9/KkFA5WTq/sPG2DJ/Ord+aEPELcndh7R7nXbV4yEnZjFJHXmwOcc5bW8G7PlD/tuE45MKl4bncFT8XBAqqPAS9IJ5KhVgBKwSm03ArfizH2CAhdwdoNJOuzv69m3TrOWzkIUh0EjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208873; c=relaxed/simple;
	bh=oS3ZcuJd1c0BV+3fasTGgAY2aSY7HhIfWAMeC6PiStU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8ZwrybFfw4ZDuMj0eUs+ckxls44MYhHp1NNb2ew1jd4A7i/FgWBEyErAXoSyShy/3rcPCnWTmlUJiXBehkH9SbJSIoMk9NXPUAXRLgy4o4U9wMzQbUGP2CYZ7l+ea/LG4jhosPxC9IL4yv+gFgIFOx4sjn9hu851EfnLc4BsD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrdxU3lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrdxU3lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132C3C4CEC3;
	Sun,  1 Sep 2024 16:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208873;
	bh=oS3ZcuJd1c0BV+3fasTGgAY2aSY7HhIfWAMeC6PiStU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrdxU3lhnavY4RblurtGMcXcTbnBxoBv5prli8Tns6ypAvBOUJdLk4/fSRAohEojl
	 v7E9OHDPCV3UrsGH1u0Vbj77HkvJDzUJmwCdmUz/8mA1sB19vT+Y863NvbuE6/qK8f
	 hSLKEDJruCPB9pTlNs8WTTQBbk/OsKiyLVbF2EDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/134] openrisc: Call setup_memory() earlier in the init sequence
Date: Sun,  1 Sep 2024 18:16:52 +0200
Message-ID: <20240901160812.585036226@linuxfoundation.org>
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
index ae104eb4becc7..bd0ba3157d515 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -280,6 +280,9 @@ void calibrate_delay(void)
 
 void __init setup_arch(char **cmdline_p)
 {
+	/* setup memblock allocator */
+	setup_memory();
+
 	unflatten_and_copy_device_tree();
 
 	setup_cpuinfo();
@@ -304,9 +307,6 @@ void __init setup_arch(char **cmdline_p)
 	initrd_below_start_ok = 1;
 #endif
 
-	/* setup memblock allocator */
-	setup_memory();
-
 	/* paging_init() sets up the MMU and marks all pages as reserved */
 	paging_init();
 
-- 
2.43.0



