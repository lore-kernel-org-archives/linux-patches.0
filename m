Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F824C602;
	Mon,  8 Jan 2024 15:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vV9jkNpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB2DC433C7;
	Mon,  8 Jan 2024 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726666;
	bh=E8GnEUySZKWRjzd/vRrCtKflbKAb79VaT1ptmFRtsUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vV9jkNpexaeJ2En0T7zpLpjyKBQ3hGqItdCPbb3iqOCLCOr8/1QJ1Tab+8Jcpp8iA
	 K+yH6J4AOSW1QANKIkHJYBlue8URp/kBYffxow09JahAAdKfT6r0lonenTdA41Ntp2
	 pxDx6knTPYnK3grFmGvvgfPHnRXTdomxjjMt6Ap0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/124] ARM: sun9i: smp: Fix array-index-out-of-bounds read in sunxi_mc_smp_init
Date: Mon,  8 Jan 2024 16:07:45 +0100
Message-ID: <20240108150604.783791020@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 72ad3b772b6d393701df58ba1359b0bb346a19ed ]

Running a multi-arch kernel (multi_v7_defconfig) on a Raspberry Pi 3B+
with enabled CONFIG_UBSAN triggers the following warning:

 UBSAN: array-index-out-of-bounds in arch/arm/mach-sunxi/mc_smp.c:810:29
 index 2 is out of range for type 'sunxi_mc_smp_data [2]'
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.7.0-rc6-00248-g5254c0cbc92d
 Hardware name: BCM2835
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x40/0x4c
  dump_stack_lvl from ubsan_epilogue+0x8/0x34
  ubsan_epilogue from __ubsan_handle_out_of_bounds+0x78/0x80
  __ubsan_handle_out_of_bounds from sunxi_mc_smp_init+0xe4/0x4cc
  sunxi_mc_smp_init from do_one_initcall+0xa0/0x2fc
  do_one_initcall from kernel_init_freeable+0xf4/0x2f4
  kernel_init_freeable from kernel_init+0x18/0x158
  kernel_init from ret_from_fork+0x14/0x28

Since the enabled method couldn't match with any entry from
sunxi_mc_smp_data, the value of the index shouldn't be used right after
the loop. So move it after the check of ret in order to have a valid
index.

Fixes: 1631090e34f5 ("ARM: sun9i: smp: Add is_a83t field")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20231228193903.9078-1-wahrenst@gmx.net
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-sunxi/mc_smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-sunxi/mc_smp.c b/arch/arm/mach-sunxi/mc_smp.c
index cb63921232a6f..6ec3445f3c723 100644
--- a/arch/arm/mach-sunxi/mc_smp.c
+++ b/arch/arm/mach-sunxi/mc_smp.c
@@ -807,12 +807,12 @@ static int __init sunxi_mc_smp_init(void)
 			break;
 	}
 
-	is_a83t = sunxi_mc_smp_data[i].is_a83t;
-
 	of_node_put(node);
 	if (ret)
 		return -ENODEV;
 
+	is_a83t = sunxi_mc_smp_data[i].is_a83t;
+
 	if (!sunxi_mc_smp_cpu_table_init())
 		return -EINVAL;
 
-- 
2.43.0



