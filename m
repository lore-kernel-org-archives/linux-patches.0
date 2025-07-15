Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158352E610D;
	Tue, 15 Jul 2025 13:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586952; cv=none; b=NUxNpbCdRTJ45PiS4J8ZQxSju5Ty3goqogFpRK6qAncLb1gWEGR4jDnp0zm799264TGKZ0xh09sc20To6LM+ah4yZ2QITjshr40tFHSa4IgZn2qQqI6LOUAqx528ZSz+zTL/o/w5B4dCMfgL38g/8hKHRBgqaEsp2XwLc+mCIgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586952; c=relaxed/simple;
	bh=mY3rDxIeWUBzgP+T5WuLIY4tciDv4KWhKm/2fLKWhus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KV6WrEVoo8+pGmiXPfVd2Vb6Wb8eDADm51UuDWMr1Qlg3VdhOhK3xE7v4YcAzOxDY7zGdln4lDuFCPp2YpfGon56J0XwdSxjsHsGgNzZW0r++bfguNRy2plFK8zGzJEFA5SHhI9BRFAX6pOP0RVNYyFNdyuLwZd3aXiIElCN0mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gm4sd396; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gm4sd396"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCB0C4CEE3;
	Tue, 15 Jul 2025 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586952;
	bh=mY3rDxIeWUBzgP+T5WuLIY4tciDv4KWhKm/2fLKWhus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gm4sd396Mt/7cZPdLAk+KmzpL8As9wRDKy+pqNBc4fyu3y4AcfHS4Jqr3g+zhP6Bv
	 BuQur1qdIhuMGHGO8kA04LbpypMtgbmUoE7/bRyKX3xF95GB7OphOk7uI5G1Pewp+t
	 ptX4P/EPFRL0odzZZyRHXjKP9la/qPo2TUVqiACU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggyu Kim <honggyu.kim@sk.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 110/192] samples/damon: fix damon sample prcl for start failure
Date: Tue, 15 Jul 2025 15:13:25 +0200
Message-ID: <20250715130819.303865993@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honggyu Kim <honggyu.kim@sk.com>

commit d9e01c62b7a0c258a7481c083f84c766a8f5597c upstream.

Patch series "mm/damon: fix divide by zero and its samples", v3.

This series includes fixes against damon and its samples to make it safer
when damon sample starting fails.

It includes the following changes.
- fix unexpected divide by zero crash for zero size regions
- fix bugs for damon samples in case of start failures


This patch (of 4):

The damon_sample_prcl_start() can fail so we must reset the "enable"
parameter to "false" again for proper rollback.

In such cases, setting Y to "enable" then N triggers the following crash
because damon sample start failed but the "enable" stays as Y.

  [ 2441.419649] damon_sample_prcl: start
  [ 2454.146817] damon_sample_prcl: stop
  [ 2454.146862] ------------[ cut here ]------------
  [ 2454.146865] kernel BUG at mm/slub.c:546!
  [ 2454.148183] Oops: invalid opcode: 0000 [#1] SMP NOPTI
  	...
  [ 2454.167555] Call Trace:
  [ 2454.167822]  <TASK>
  [ 2454.168061]  damon_destroy_ctx+0x78/0x140
  [ 2454.168454]  damon_sample_prcl_enable_store+0x8d/0xd0
  [ 2454.168932]  param_attr_store+0xa1/0x120
  [ 2454.169315]  module_attr_store+0x20/0x50
  [ 2454.169695]  sysfs_kf_write+0x72/0x90
  [ 2454.170065]  kernfs_fop_write_iter+0x150/0x1e0
  [ 2454.170491]  vfs_write+0x315/0x440
  [ 2454.170833]  ksys_write+0x69/0xf0
  [ 2454.171162]  __x64_sys_write+0x19/0x30
  [ 2454.171525]  x64_sys_call+0x18b2/0x2700
  [ 2454.171900]  do_syscall_64+0x7f/0x680
  [ 2454.172258]  ? exit_to_user_mode_loop+0xf6/0x180
  [ 2454.172694]  ? clear_bhb_loop+0x30/0x80
  [ 2454.173067]  ? clear_bhb_loop+0x30/0x80
  [ 2454.173439]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Link: https://lkml.kernel.org/r/20250702000205.1921-1-honggyu.kim@sk.com
Link: https://lkml.kernel.org/r/20250702000205.1921-2-honggyu.kim@sk.com
Fixes: 2aca254620a8 ("samples/damon: introduce a skeleton of a smaple DAMON module for proactive reclamation")
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/prcl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index 056b1b21a0fe..5597e6a08ab2 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -122,8 +122,12 @@ static int damon_sample_prcl_enable_store(
 	if (enable == enabled)
 		return 0;
 
-	if (enable)
-		return damon_sample_prcl_start();
+	if (enable) {
+		err = damon_sample_prcl_start();
+		if (err)
+			enable = false;
+		return err;
+	}
 	damon_sample_prcl_stop();
 	return 0;
 }
-- 
2.50.1



