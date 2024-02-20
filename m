Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6761509AC;
	Tue, 20 Feb 2024 21:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463164; cv=none; b=Xf8ekYyse3xOKC2XpJe+0mfuvA4qtFWY0mSf+rNGLvjv2E6+o6EQKd0FNIr+GXtdroN4EMDUHM49JdH4IY91sutmto64JMXnl9PwbESvfkdksEBJLkm63a1HaIBU0d6SCX7UzPpTiIo1uAH832KmymC+naNF0VXg42kIR6KeudA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463164; c=relaxed/simple;
	bh=sBQW1Ri1hDfvnMWDV+eiTCFBa/5WFN3a2psadJlSmlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Un3wUzFav+YiSEbbUBWJPqtsxplDT+q/mZlMYdnFcU9YOL8m1zEw1p6AUoqjG682O6LiAvXGv4UAiQDbNwEQNAzO29LRb1zs26cSao9co2wTyG4k6cTRNCeAJDM9v0W3DQ021fQFF9Sn65OnU90hdJ1HYbmIABD1QYA8FFKSdhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXE3fl1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXE3fl1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02269C433F1;
	Tue, 20 Feb 2024 21:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463164;
	bh=sBQW1Ri1hDfvnMWDV+eiTCFBa/5WFN3a2psadJlSmlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXE3fl1fwF00Za0rVs4g3ruUtEIDz3vwRF4w2nPltTzJU5R3OSHa88q4LGcenneZB
	 S9JMR6DHP1CCTzSUNWKvHHZGeJAThhSAfO5Wgak/lM6jiC1UJoo9ZOv6nnwvjdZZyU
	 kX6ZxIw1AG+uo7PsoFEN6H/kd1iHQ28E7z0OYH7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinthu Raja <sinthu.raja@ti.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 155/197] net: ethernet: ti: cpsw_new: enable mac_managed_pm to fix mdio
Date: Tue, 20 Feb 2024 21:51:54 +0100
Message-ID: <20240220204845.714288172@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Sinthu Raja <sinthu.raja@ti.com>

commit 9def04e759caa5a3d741891037ae99f81e2fff01 upstream.

The below commit  introduced a WARN when phy state is not in the states:
PHY_HALTED, PHY_READY and PHY_UP.
commit 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")

When cpsw_new resumes, there have port in PHY_NOLINK state, so the below
warning comes out. Set mac_managed_pm be true to tell mdio that the phy
resume/suspend is managed by the mac, to fix the following warning:

WARNING: CPU: 0 PID: 965 at drivers/net/phy/phy_device.c:326 mdio_bus_phy_resume+0x140/0x144
CPU: 0 PID: 965 Comm: sh Tainted: G           O       6.1.46-g247b2535b2 #1
Hardware name: Generic AM33XX (Flattened Device Tree)
 unwind_backtrace from show_stack+0x18/0x1c
 show_stack from dump_stack_lvl+0x24/0x2c
 dump_stack_lvl from __warn+0x84/0x15c
 __warn from warn_slowpath_fmt+0x1a8/0x1c8
 warn_slowpath_fmt from mdio_bus_phy_resume+0x140/0x144
 mdio_bus_phy_resume from dpm_run_callback+0x3c/0x140
 dpm_run_callback from device_resume+0xb8/0x2b8
 device_resume from dpm_resume+0x144/0x314
 dpm_resume from dpm_resume_end+0x14/0x20
 dpm_resume_end from suspend_devices_and_enter+0xd0/0x924
 suspend_devices_and_enter from pm_suspend+0x2e0/0x33c
 pm_suspend from state_store+0x74/0xd0
 state_store from kernfs_fop_write_iter+0x104/0x1ec
 kernfs_fop_write_iter from vfs_write+0x1b8/0x358
 vfs_write from ksys_write+0x78/0xf8
 ksys_write from ret_fast_syscall+0x0/0x54
Exception stack(0xe094dfa8 to 0xe094dff0)
dfa0:                   00000004 005c3fb8 00000001 005c3fb8 00000004 00000001
dfc0: 00000004 005c3fb8 b6f6bba0 00000004 00000004 0059edb8 00000000 00000000
dfe0: 00000004 bed918f0 b6f09bd3 b6e89a66

Cc: <stable@vger.kernel.org> # v6.0+
Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Sinthu Raja <sinthu.raja@ti.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw_new.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -772,6 +772,9 @@ static void cpsw_slave_open(struct cpsw_
 			slave->slave_num);
 		return;
 	}
+
+	phy->mac_managed_pm = true;
+
 	slave->phy = phy;
 
 	phy_attached_info(slave->phy);


