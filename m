Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE12196DA5;
	Thu,  6 Jun 2024 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683270; cv=none; b=I4/M8Ab9+dhJ/Y/o6fI8/P9QymmPohoyLCiMTZnxDq0cRWklsxCGTzjPJTlTCyGoCU3KR5xkM6nVvnMDPAllWfyeoz2r6UfuA3L8wJ1IjPxTpuI710TfoH/fAtYePQGnGdyQiQ5P2dqtZhGiJEFeLhnbUJstcSPCakS56Aj2qyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683270; c=relaxed/simple;
	bh=G+iBCIFgqihh6qxDCjUDlpdfilzoPgn7ARVTsFMOoCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGa/Kh74k4OdP8yN4VbcNZPyOD/ef0dDHmeuAmUspgvtBi0TXDXM+RvZfXOlAftkdarEQ67Qq3kk5R0Dh2yE/vnylV5Ocvx26rELYAf5XcjavzeGLoZmdNcVP/UVkyfnRsSg74FZonvznoZ3rihB5SEncGyQ8e1LAoNXoELw74I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdZCAYFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdZCAYFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B86C2BD10;
	Thu,  6 Jun 2024 14:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683270;
	bh=G+iBCIFgqihh6qxDCjUDlpdfilzoPgn7ARVTsFMOoCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdZCAYFzrW7BrNW0MKxRWViSUujU2aOmNwAYON2XVVioZei4daeV9825tBuSsf7aS
	 /5+GYbUgaoZI5Yip71DW9kTJcfLkRT7E6VPFOrVrnCfED9upG/RGkMuEcTkar06m12
	 7W8rWHfNCrILf0WbemrrnJ0WgbW9Mk5FcErovNUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+838346b979830606c854@syzkaller.appspotmail.com,
	Stanislav Fomichev <sdf@google.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/744] bpf: Add BPF_PROG_TYPE_CGROUP_SKB attach type enforcement in BPF_LINK_CREATE
Date: Thu,  6 Jun 2024 15:58:05 +0200
Message-ID: <20240606131739.227636477@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 543576ec15b17c0c93301ac8297333c7b6e84ac7 ]

bpf_prog_attach uses attach_type_to_prog_type to enforce proper
attach type for BPF_PROG_TYPE_CGROUP_SKB. link_create uses
bpf_prog_get and relies on bpf_prog_attach_check_attach_type
to properly verify prog_type <> attach_type association.

Add missing attach_type enforcement for the link_create case.
Otherwise, it's currently possible to attach cgroup_skb prog
types to other cgroup hooks.

Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
Link: https://lore.kernel.org/bpf/0000000000004792a90615a1dde0@google.com/
Reported-by: syzbot+838346b979830606c854@syzkaller.appspotmail.com
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240426231621.2716876-2-sdf@google.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4902a7487f076..e886157a9efbb 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3809,6 +3809,11 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 			 * check permissions at attach time.
 			 */
 			return -EPERM;
+
+		ptype = attach_type_to_prog_type(attach_type);
+		if (prog->type != ptype)
+			return -EINVAL;
+
 		return prog->enforce_expected_attach_type &&
 			prog->expected_attach_type != attach_type ?
 			-EINVAL : 0;
-- 
2.43.0



