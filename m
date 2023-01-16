Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CB846B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A69C433EF;
	Mon, 16 Jan 2023 16:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886498;
	bh=fMMyNyzbvRwmSTqzD8lXk4v83sQ5MyjeTWHT8yOk2uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFhEqjVbqvqwYgyNzOLDQtIYattBjK6DY7F1tGHsa2ZZog2Rrdk2D4a906R4emJgB
	 XGckb6B36LaSbn5U71i+uFPC3x0FZ56AR15b1d6zVn+hsh4HY5+Uj7LxAvPFLxFw2V
	 6MdAge33GP7lXXo4n8D28nKahYxkMLYLMvdhApNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiang Li <jiang.li@ugreen.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 412/658] md/raid1: stop mdx_raid1 thread when raid1 array run failed
Date: Mon, 16 Jan 2023 16:48:20 +0100
Message-Id: <20230116154928.458408657@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiang Li <jiang.li@ugreen.com>

[ Upstream commit b611ad14006e5be2170d9e8e611bf49dff288911 ]

fail run raid1 array when we assemble array with the inactive disk only,
but the mdx_raid1 thread were not stop, Even if the associated resources
have been released. it will caused a NULL dereference when we do poweroff.

This causes the following Oops:
    [  287.587787] BUG: kernel NULL pointer dereference, address: 0000000000000070
    [  287.594762] #PF: supervisor read access in kernel mode
    [  287.599912] #PF: error_code(0x0000) - not-present page
    [  287.605061] PGD 0 P4D 0
    [  287.607612] Oops: 0000 [#1] SMP NOPTI
    [  287.611287] CPU: 3 PID: 5265 Comm: md0_raid1 Tainted: G     U            5.10.146 #0
    [  287.619029] Hardware name: xxxxxxx/To be filled by O.E.M, BIOS 5.19 06/16/2022
    [  287.626775] RIP: 0010:md_check_recovery+0x57/0x500 [md_mod]
    [  287.632357] Code: fe 01 00 00 48 83 bb 10 03 00 00 00 74 08 48 89 ......
    [  287.651118] RSP: 0018:ffffc90000433d78 EFLAGS: 00010202
    [  287.656347] RAX: 0000000000000000 RBX: ffff888105986800 RCX: 0000000000000000
    [  287.663491] RDX: ffffc90000433bb0 RSI: 00000000ffffefff RDI: ffff888105986800
    [  287.670634] RBP: ffffc90000433da0 R08: 0000000000000000 R09: c0000000ffffefff
    [  287.677771] R10: 0000000000000001 R11: ffffc90000433ba8 R12: ffff888105986800
    [  287.684907] R13: 0000000000000000 R14: fffffffffffffe00 R15: ffff888100b6b500
    [  287.692052] FS:  0000000000000000(0000) GS:ffff888277f80000(0000) knlGS:0000000000000000
    [  287.700149] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [  287.705897] CR2: 0000000000000070 CR3: 000000000320a000 CR4: 0000000000350ee0
    [  287.713033] Call Trace:
    [  287.715498]  raid1d+0x6c/0xbbb [raid1]
    [  287.719256]  ? __schedule+0x1ff/0x760
    [  287.722930]  ? schedule+0x3b/0xb0
    [  287.726260]  ? schedule_timeout+0x1ed/0x290
    [  287.730456]  ? __switch_to+0x11f/0x400
    [  287.734219]  md_thread+0xe9/0x140 [md_mod]
    [  287.738328]  ? md_thread+0xe9/0x140 [md_mod]
    [  287.742601]  ? wait_woken+0x80/0x80
    [  287.746097]  ? md_register_thread+0xe0/0xe0 [md_mod]
    [  287.751064]  kthread+0x11a/0x140
    [  287.754300]  ? kthread_park+0x90/0x90
    [  287.757974]  ret_from_fork+0x1f/0x30

In fact, when raid1 array run fail, we need to do
md_unregister_thread() before raid1_free().

Signed-off-by: Jiang Li <jiang.li@ugreen.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e87184645c54..1919de4c8c12 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3132,6 +3132,7 @@ static int raid1_run(struct mddev *mddev)
 	 * RAID1 needs at least one disk in active
 	 */
 	if (conf->raid_disks - mddev->degraded < 1) {
+		md_unregister_thread(&conf->thread);
 		ret = -EINVAL;
 		goto abort;
 	}
-- 
2.35.1



