Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD52363C74;
	Wed, 20 May 2026 16:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294893; cv=none; b=GKTD/0xu4ce1UKlhmBo4aopcIB2KoH9bh3rg1hJ5ojQEeoRMNb0456SodPbmZTl6RZuIkwwzHbkYh6DzbfkJa0+Iih9nyw0H5DvedKKCxSSF4/mqEff8WQUq6cR1npziwW2204tdVW1cgSOLBXeQzjELzCvViI6tE6T84vrJ12w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294893; c=relaxed/simple;
	bh=PSEznv80X6JICgSD8qQat7slX8BJIV6z+zWHr/zOjNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKcC2TuRiqqifZJIb65KKcsvftOmsRwvljxNqDoi6PS+YskXGHt5VPTRHKgQQRggJQiMtf3jwNOSrSuacE0YzN9DFrnRqDwb0eNC3M2ggFnvWcHoiTz1i+lUlHFj5yiV9hpOXQPLs2fMUqPfyYh/oKnOEi8404uUDkH5quDMzc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcolNjJz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcolNjJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B1B1F000E9;
	Wed, 20 May 2026 16:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294892;
	bh=k/QQlbFGaX9bLICSOQmEbOcWLflUO2ZsKY34GuwdJVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcolNjJz4sJIN8Pp5HjmJhLiD4KNScR5jWa+va11pepG/peyNL6EIC/UcEgtTMztE
	 fNnu1FccSCYxWLMaH8cDl3ftv1DkkLsKfpFPvpFV+CdhkZHRQygWFIgAld0cjV7RlR
	 10R230SvGC0U3SbIlwJyRhC/WAz4Psdhpclo3guo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0171/1146] bpf: Fix use-after-free in offloaded map/prog info fill
Date: Wed, 20 May 2026 18:07:01 +0200
Message-ID: <20260520162152.157752399@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit a0c584fc18056709c8e047a82a6045d6c209f4ce ]

When querying info for an offloaded BPF map or program,
bpf_map_offload_info_fill_ns() and bpf_prog_offload_info_fill_ns()
obtain the network namespace with get_net(dev_net(offmap->netdev)).
However, the associated netdev's netns may be racing with teardown
during netns destruction. If the netns refcount has already reached 0,
get_net() performs a refcount_t increment on 0, triggering:

  refcount_t: addition on 0; use-after-free.

Although rtnl_lock and bpf_devs_lock ensure the netdev pointer remains
valid, they cannot prevent the netns refcount from reaching zero.

Fix this by using maybe_get_net() instead of get_net(). maybe_get_net()
uses refcount_inc_not_zero() and returns NULL if the refcount is already
zero, which causes ns_get_path_cb() to fail and the caller to return
-ENOENT -- the correct behavior when the netns is being destroyed.

Fixes: 675fc275a3a2d ("bpf: offload: report device information for offloaded programs")
Fixes: 52775b33bb507 ("bpf: offload: report device information about offloaded maps")
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Closes: https://lore.kernel.org/bpf/f0aa3678-79c9-47ae-9e8c-02a3d1df160a@hust.edu.cn/
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260409023733.168050-1-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/offload.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 0ad97d643bf49..0d6f5569588c3 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -435,9 +435,8 @@ static struct ns_common *bpf_prog_offload_info_fill_ns(void *private_data)
 
 	if (aux->offload) {
 		args->info->ifindex = aux->offload->netdev->ifindex;
-		net = dev_net(aux->offload->netdev);
-		get_net(net);
-		ns = &net->ns;
+		net = maybe_get_net(dev_net(aux->offload->netdev));
+		ns = net ? &net->ns : NULL;
 	} else {
 		args->info->ifindex = 0;
 		ns = NULL;
@@ -647,9 +646,8 @@ static struct ns_common *bpf_map_offload_info_fill_ns(void *private_data)
 
 	if (args->offmap->netdev) {
 		args->info->ifindex = args->offmap->netdev->ifindex;
-		net = dev_net(args->offmap->netdev);
-		get_net(net);
-		ns = &net->ns;
+		net = maybe_get_net(dev_net(args->offmap->netdev));
+		ns = net ? &net->ns : NULL;
 	} else {
 		args->info->ifindex = 0;
 		ns = NULL;
-- 
2.53.0



