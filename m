Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB4E494811;
	Mon, 31 Aug 2026 14:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185174; cv=none; b=F10dj0aPaAUWlK0yAfeLXlUKhk/uVMPSDfqb/a/PYkTmLSw9zxSQ0eaeh55iKBrRHm/6rQvf23IbsEhnNxJrc/8D0PoJAdkwjkv320UnQJD0bvZPKSNok4vKD1s/Ujft1sJgF/Wu3PX0s8gD0RlL0iU+q+4dkixwktpLaaQfSjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185174; c=relaxed/simple;
	bh=dYaFDCIGkZIkA5lnBDuuNftQ+60bgt0s5bH27rxs57c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuXyTbFRzqF3rGljj4eFHvVceiMrtVMOBUvxeR6T7pi+J26BWrdFvn2ZwqX9o07kGFUdkpAcV8/A3xQuHp/qE6K6YLB3OD3TSBNmNDg6669RK+cM15t8oNSvVkNT23wckw4eZ1pPTQftNG0nAcT70xRD9en8D7An75h+QrQk9ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMVFp9kq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMVFp9kq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730D01F000E9;
	Mon, 31 Aug 2026 14:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185173;
	bh=NVHQyc9Os580lQnPu7lVrRehGZSgGrR0pVvtfzszGao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMVFp9kqHmo0VIDBxOar5YRyRmGDQ8FeQQ24L7fkTP4vh0m7KZLvVnjBdG27onK6d
	 bgzhfJu0hf3yF22MeJWwfbygHFAwef+vUOQLWV39U+5gtF6KQpUUlPcyY1AuQAcQr6
	 m4uY6+HogORNb1KoPSdsNTUMX3wWwMc35R+HYPQM=
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
Subject: [PATCH 5.10 10/43] bpf: Fix use-after-free in offloaded map/prog info fill
Date: Mon, 31 Aug 2026 15:35:18 +0200
Message-ID: <20260831133358.998190580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bd09290e36484..bfd2ce6733692 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -277,9 +277,8 @@ static struct ns_common *bpf_prog_offload_info_fill_ns(void *private_data)
 
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
@@ -504,9 +503,8 @@ static struct ns_common *bpf_map_offload_info_fill_ns(void *private_data)
 
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



