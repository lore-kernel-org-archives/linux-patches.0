Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7955A241FC
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQhM1Rvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DB1C433C9;
	Mon,  6 Nov 2023 13:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277457;
	bh=TT2tFTdY0mMaZwb5FVUOLW4Mt1N7wKj5Vs1BM69N3gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQhM1RvlmP1m7JVAELrScpkUPSXUIDDClPkQ7wI4IJ2DR0PCFbKVYZJ72sLCSWz6q
	 WhXbXyTrJxo2t5YxZSIV3HGkCH6cHN1nAaqAnsLLa0nsGerEcCxab8xBXMxR31BDlu
	 c6JkNXCzoK1+LaLihiGCc1DC6I7+9lTJd940lEZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majczak <lma@semihalf.com>,
	Radoslaw Biernacki <rad@chromium.org>,
	Manasi Navare <navaremanasi@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/95] drm/dp_mst: Fix NULL deref in get_mst_branch_device_by_guid_helper()
Date: Mon,  6 Nov 2023 14:03:36 +0100
Message-ID: <20231106130305.006138465@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
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

From: Lukasz Majczak <lma@semihalf.com>

[ Upstream commit 3d887d512494d678b17c57b835c32f4e48d34f26 ]

As drm_dp_get_mst_branch_device_by_guid() is called from
drm_dp_get_mst_branch_device_by_guid(), mstb parameter has to be checked,
otherwise NULL dereference may occur in the call to
the memcpy() and cause following:

[12579.365869] BUG: kernel NULL pointer dereference, address: 0000000000000049
[12579.365878] #PF: supervisor read access in kernel mode
[12579.365880] #PF: error_code(0x0000) - not-present page
[12579.365882] PGD 0 P4D 0
[12579.365887] Oops: 0000 [#1] PREEMPT SMP NOPTI
...
[12579.365895] Workqueue: events_long drm_dp_mst_up_req_work
[12579.365899] RIP: 0010:memcmp+0xb/0x29
[12579.365921] Call Trace:
[12579.365927] get_mst_branch_device_by_guid_helper+0x22/0x64
[12579.365930] drm_dp_mst_up_req_work+0x137/0x416
[12579.365933] process_one_work+0x1d0/0x419
[12579.365935] worker_thread+0x11a/0x289
[12579.365938] kthread+0x13e/0x14f
[12579.365941] ? process_one_work+0x419/0x419
[12579.365943] ? kthread_blkcg+0x31/0x31
[12579.365946] ret_from_fork+0x1f/0x30

As get_mst_branch_device_by_guid_helper() is recursive, moving condition
to the first line allow to remove a similar one for step over of NULL elements
inside a loop.

Fixes: 5e93b8208d3c ("drm/dp/mst: move GUID storage from mgr, port to only mst branch")
Cc: <stable@vger.kernel.org> # 4.14+
Signed-off-by: Lukasz Majczak <lma@semihalf.com>
Reviewed-by: Radoslaw Biernacki <rad@chromium.org>
Signed-off-by: Manasi Navare <navaremanasi@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230922063410.23626-1-lma@semihalf.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index b5e15933cb5f4..27305f3398819 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2612,14 +2612,14 @@ static struct drm_dp_mst_branch *get_mst_branch_device_by_guid_helper(
 	struct drm_dp_mst_branch *found_mstb;
 	struct drm_dp_mst_port *port;
 
+	if (!mstb)
+		return NULL;
+
 	if (memcmp(mstb->guid, guid, 16) == 0)
 		return mstb;
 
 
 	list_for_each_entry(port, &mstb->ports, next) {
-		if (!port->mstb)
-			continue;
-
 		found_mstb = get_mst_branch_device_by_guid_helper(port->mstb, guid);
 
 		if (found_mstb)
-- 
2.42.0



