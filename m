Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC1D1553BC
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 02:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736218011; cv=none; b=PRmVEXOR+oZgyaBwVcDTx8+j/PVRpX5UG++8V6bSi6lCpRQRneSeVlW62LgPRd6OrTiQ47VeoZKm+BANkBMxnBN4NzCAPpxRSgP930i6vD9lbNxaMCF/S3rB3ihm8txkCTy9o4g9T3DWEvtjDfwEaJN6dKFfc1alm+s4tQbfSAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736218011; c=relaxed/simple;
	bh=e307X2A5M2l0pbJ6+KzrFKwYZJPrkb0u9bLH0ykj7Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzpeIvpWsLUIVTizKO86n1Q1WPrpThfa+1Ov1Pqo1USVGo6py77U8+idcypEQYQqX3hU6uFnu1jT+IqVZs2ZFI122Z90fLzs+5dZT6oHv8XrCksJ6la+0RCoZpAX11Sa8s5je0fk1TxWUd70Ilwt+u0mxuzBUv+YgV73aNx6VvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=eHcTXFh8; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="eHcTXFh8"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 4F48E14C1E1;
	Tue,  7 Jan 2025 03:40:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1736217649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0IEOW76cDyxbtCdSxV9V+cKeUnyii/PZpUPPWjx212g=;
	b=eHcTXFh8Msm+77HChV9Ix2Z3OVrmy7H8jPYx2fVE+KY9YGA1qpMQrsFA9+mkLF8SnFk2m+
	Gv7g7yaqH5N7zv70667LjpHORbbvp3/psAKX/iE6m2jZVkDdcOH9DCqo6hg1kdB/dNHEuL
	kRcfGW6CrnB0s+Rp9xwVSzv14a/f4HqXO4pdB17YOwVf4ZXRc23fk0LwH3Rud9vj/f5cvo
	3rO6XSqDDyhQkXM8bIKFFflwgZxBG3jaZNoXg2imqE/IlcJ9lHk26e5G98Vo7YyatEHEuL
	HmvZ5trFpVjoyMt2Z0FIY7dlNCj4xwFaMy5Qf5qQyNBmPETZBj6p8w8ZjtOzFA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 67cabf3a;
	Tue, 7 Jan 2025 02:40:45 +0000 (UTC)
Date: Tue, 7 Jan 2025 11:40:30 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 098/138] zram: fix uninitialized ZRAM not releasing
 backing device
Message-ID: <Z3yUHnBIiz9q_jgf@codewreck.org>
References: <20250106151133.209718681@linuxfoundation.org>
 <20250106151136.941319893@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250106151136.941319893@linuxfoundation.org>

Greg Kroah-Hartman wrote on Mon, Jan 06, 2025 at 04:17:02PM +0100:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kairui Song <kasong@tencent.com>
> 
> [ Upstream commit 74363ec674cb172d8856de25776c8f3103f05e2f ]
> 
> Setting backing device is done before ZRAM initialization.  If we set the
> backing device, then remove the ZRAM module without initializing the
> device, the backing device reference will be leaked and the device will be
> hold forever.
> 
> Fix this by always reset the ZRAM fully on rmmod or reset store.


This causes a null pointer deref when reseting an uninitialized device:

armadillo:/sys/block/zram0# echo 1 > reset
[   28.054565] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[   28.063377] Mem abort info:
[   28.066182]   ESR = 0x96000004
[   28.069241]   EC = 0x25: DABT (current EL), IL = 32 bits
[   28.074557]   SET = 0, FnV = 0
[   28.077612]   EA = 0, S1PTW = 0
[   28.080755] Data abort info:
[   28.083633]   ISV = 0, ISS = 0x00000004
[   28.087473]   CM = 0, WnR = 0
[   28.090445] user pgtable: 4k pages, 48-bit VAs, pgdp=00000000464f9000
[   28.096888] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[   28.103700] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[   28.109965] Modules linked in: moal(E) cfg80211(E) mlan(E)
[   28.115458] CPU: 3 PID: 1900 Comm: sh Tainted: G            E     5.10.233-rc1-gbbdff754b92c #1
[   28.124153] Hardware name: Atmark-Techno Armadillo-IoT Gateway G4 Board (DT)
[   28.131201] pstate: a0000005 (NzCv daif -PAN -UAO -TCO BTYPE=--)
[   28.137211] pc : zcomp_cpu_dead+0x20/0x70
[   28.141220] lr : cpuhp_invoke_callback+0xd4/0x204
[   28.145920] sp : ffff800011a1bb10
[   28.149231] x29: ffff800011a1bb10 x28: ffff000006562580 
[   28.154542] x27: 0000000000000000 x26: ffff80001148aab8 
[   28.159855] x25: ffff800010716210 x24: 0000000000000000 
[   28.165169] x23: ffff80001149cb70 x22: 0000000000000000 
[   28.170480] x21: 0000000000000010 x20: ffff80002e856000 
[   28.175791] x19: ffff80001149d790 x18: 0000000000000000 
[   28.181102] x17: 0000000000000000 x16: 0000000000000000 
[   28.186413] x15: 0000ffff9aa2f5b0 x14: 0000000000000000 
[   28.191726] x13: ffff800011a1bc96 x12: ffff800011a1bc70 
[   28.197036] x11: 0fffffffffffffff x10: 000000000000000a 
[   28.202349] x9 : 0000000000000000 x8 : ffff000002a102b8 
[   28.207660] x7 : 0000000000000000 x6 : 0000000000000040 
[   28.212973] x5 : ffff00003fb4f6f0 x4 : 0000000000000000 
[   28.218285] x3 : 0000000000000010 x2 : ffff80001148aab8 
[   28.223596] x1 : 0000000000000010 x0 : 0000000000000000 
[   28.228907] Call trace:
[   28.231353]  zcomp_cpu_dead+0x20/0x70
[   28.235013]  cpuhp_invoke_callback+0xd4/0x204
[   28.239370]  cpuhp_issue_call+0x168/0x1b4
[   28.243378]  __cpuhp_state_remove_instance+0x144/0x1f0
[   28.248513]  zcomp_destroy+0x24/0x44
[   28.252086]  zram_reset_device+0xfc/0x11c
[   28.256093]  reset_store+0xa4/0x130
[   28.259581]  dev_attr_store+0x18/0x30
[   28.263244]  sysfs_kf_write+0x44/0x54
[   28.266903]  kernfs_fop_write_iter+0x134/0x1c4
[   28.271346]  new_sync_write+0xfc/0x1b0
[   28.275093]  vfs_write+0x240/0x2b0
[   28.278492]  ksys_write+0x74/0x110
[   28.281891]  __arm64_sys_write+0x1c/0x30
[   28.285815]  el0_svc_common.constprop.0+0x78/0x1c0
[   28.290603]  do_el0_svc+0x1c/0x30
[   28.293916]  el0_svc+0x10/0x20
[   28.296968]  el0_sync_handler+0x108/0x114
[   28.300975]  el0_sync+0x180/0x1c0
[   28.304290] Code: 912ae042 a90153f3 f90013f5 f8605854 (f85f0033) 
[   28.310382] ---[ end trace e91dc675f5f4a195 ]---


I'll look a bit more into it today and reply to this mail with anything
I've found.
(didn't test on master or anything else either)

-- 
Dominique
