Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696121B424F;
	Sun,  7 Sep 2025 20:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276000; cv=none; b=jOESRDpQAJ+cYhmqLqLU7AvbUtTOYct8SeVOwwoEUWiGNWjhk588/GpV9zeSmQ9YkuB4uisJmf/pWUGxRjVWMV9/yDPwym1OH2s3gmpxx3fwA1aDWphWB0MEGbWE1OMu9CFX7e6aU1i5fPTIbUyyh4lsN2Ey7YBV//ywhwgZcco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276000; c=relaxed/simple;
	bh=gvvs7+t5UH+xOJjEmNovhINiMA4qMU0fZ40YxIq2AvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJBCyhEWNPEtg+W92uhrRZ190TztfuVx6b3SM5KORYXJ1Y1Mz1xc9iIvq0n7GBlbBDfr5FXRbvLXa252noqg9nG9AeRH2TvMHYxvna+Ve2xHl58S2uQBnQcVhXcwsHm4Ztj9zazz/t1w+45DKv/Ul6D0Ay1/Cp42UKbe5uAO0Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6lxrrWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6lxrrWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03E9C4CEF0;
	Sun,  7 Sep 2025 20:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276000;
	bh=gvvs7+t5UH+xOJjEmNovhINiMA4qMU0fZ40YxIq2AvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6lxrrWiuSMsVBEpBQuh40GfLp6Sy7jkMsXPAUSn6veuT4orbnciTDVE+hazG3N1C
	 f/oQkKS4GESisnrGbLLLw2yn1uvMovpjdxalf4CCgB8cydk/oXmKsyy47WpaqUuBnG
	 U36GID5mGisdxQ1W1wuOclh0DpQpcrqNaFMgT+94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/64] tee: fix NULL pointer dereference in tee_shm_put
Date: Sun,  7 Sep 2025 21:57:49 +0200
Message-ID: <20250907195603.605258912@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit e4a718a3a47e89805c3be9d46a84de1949a98d5d ]

tee_shm_put have NULL pointer dereference:

__optee_disable_shm_cache -->
	shm = reg_pair_to_ptr(...);//shm maybe return NULL
        tee_shm_free(shm); -->
		tee_shm_put(shm);//crash

Add check in tee_shm_put to fix it.

panic log:
Unable to handle kernel paging request at virtual address 0000000000100cca
Mem abort info:
ESR = 0x0000000096000004
EC = 0x25: DABT (current EL), IL = 32 bits
SET = 0, FnV = 0
EA = 0, S1PTW = 0
FSC = 0x04: level 0 translation fault
Data abort info:
ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
CM = 0, WnR = 0, TnD = 0, TagAccess = 0
GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000002049d07000
[0000000000100cca] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 0000000096000004 [#1] SMP
CPU: 2 PID: 14442 Comm: systemd-sleep Tainted: P OE ------- ----
6.6.0-39-generic #38
Source Version: 938b255f6cb8817c95b0dd5c8c2944acfce94b07
Hardware name: greatwall GW-001Y1A-FTH, BIOS Great Wall BIOS V3.0
10/26/2022
pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : tee_shm_put+0x24/0x188
lr : tee_shm_free+0x14/0x28
sp : ffff001f98f9faf0
x29: ffff001f98f9faf0 x28: ffff0020df543cc0 x27: 0000000000000000
x26: ffff001f811344a0 x25: ffff8000818dac00 x24: ffff800082d8d048
x23: ffff001f850fcd18 x22: 0000000000000001 x21: ffff001f98f9fb88
x20: ffff001f83e76218 x19: ffff001f83e761e0 x18: 000000000000ffff
x17: 303a30303a303030 x16: 0000000000000000 x15: 0000000000000003
x14: 0000000000000001 x13: 0000000000000000 x12: 0101010101010101
x11: 0000000000000001 x10: 0000000000000001 x9 : ffff800080e08d0c
x8 : ffff001f98f9fb88 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : ffff001f83e761e0 x1 : 00000000ffff001f x0 : 0000000000100cca
Call trace:
tee_shm_put+0x24/0x188
tee_shm_free+0x14/0x28
__optee_disable_shm_cache+0xa8/0x108
optee_shutdown+0x28/0x38
platform_shutdown+0x28/0x40
device_shutdown+0x144/0x2b0
kernel_power_off+0x3c/0x80
hibernate+0x35c/0x388
state_store+0x64/0x80
kobj_attr_store+0x14/0x28
sysfs_kf_write+0x48/0x60
kernfs_fop_write_iter+0x128/0x1c0
vfs_write+0x270/0x370
ksys_write+0x6c/0x100
__arm64_sys_write+0x20/0x30
invoke_syscall+0x4c/0x120
el0_svc_common.constprop.0+0x44/0xf0
do_el0_svc+0x24/0x38
el0_svc+0x24/0x88
el0t_64_sync_handler+0x134/0x150
el0t_64_sync+0x14c/0x15

Fixes: dfd0743f1d9e ("tee: handle lookup of shm with reference count 0")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_shm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 6fb4400333fb4..6d2db6cc247b3 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -438,9 +438,13 @@ EXPORT_SYMBOL_GPL(tee_shm_get_from_id);
  */
 void tee_shm_put(struct tee_shm *shm)
 {
-	struct tee_device *teedev = shm->ctx->teedev;
+	struct tee_device *teedev;
 	bool do_release = false;
 
+	if (!shm || !shm->ctx || !shm->ctx->teedev)
+		return;
+
+	teedev = shm->ctx->teedev;
 	mutex_lock(&teedev->mutex);
 	if (refcount_dec_and_test(&shm->refcount)) {
 		/*
-- 
2.50.1



