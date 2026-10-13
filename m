Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C431D331EB1;
	Tue, 13 Oct 2026 12:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894214; cv=none; b=W/2C3+hZr/RFzA9dfDwztYZNLibGnYPix9pIGGnVjeOl+Grn8oHfXoNtiHoqEoNvEdITKsbqeJ/lyhEN2RjP+FgD1Y4GfJE5e9l5bcqClVbHzSt51NkWT6LHdGRti58FVCr4E69q/w1L176DbZFro/6VzX6UdcNfsEtSocHcisk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894214; c=relaxed/simple;
	bh=2lBGVEoR0bI1sQzIKipFkQaNKvUBhLAtS2W9sp5ElXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVHfJIAz/XEhaC3k4faiWRxD/+nKlwTnO3lp1kZvIGSFU2TjIGJeCefAW372HMDMhVD+5iLTsctyzN24kpZy4rAqtc/XrKO9zDvVpxDgsVBQSkXLGKXV6bcgFSnmtuiuZchnJ1LpZ8YztV565tOtvhmE63YwUe/J34T0AJAM/a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHy8Fu7Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHy8Fu7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC4A1F000FF;
	Tue, 13 Oct 2026 12:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894213;
	bh=KCi3YHlJX+ROJ1MnUOfx6AxbQ1oAF8d9LYTT/P57RBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHy8Fu7ZsRGo/LCLtM1Upq33JFzNvzlKf3yOeEsbIpazDIaSsFGqD98CtlWpIFHjE
	 bqiJuD+YHyny4gJhxEUmfwFBJS41ZnklykIolpbq9xArPlzCeE6MpI9qk+64AJmjkh
	 +1b9p55QTHVxkG0rUCA/S7EZLr43VK6K1u6xOBic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 441/621] bpf: Clear buf on error in __bpf_get_task_stack
Date: Tue, 13 Oct 2026 13:37:16 +0200
Message-ID: <20261013112931.297498024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit f5d242825ca417bb6afe35fde6e8880f97ca43fb ]

Both bpf_get_task_stack and bpf_get_task_stack_sleepable helpers that
use __bpf_get_task_stack have buf defined as ARG_PTR_TO_UNINIT_MEM
argument and we should initialize the buf on every return path.

Adding missing buf memset for __bpf_get_task_stack fail paths. This
provides deterministic buffer contents, which is useful when the buffer
is used directly as a map key.

Fixes: 06ab134ce8ec ("bpf: Refcount task stack in bpf_get_task_stack")
Fixes: b992f01e6615 ("bpf: Guard against accessing NULL pt_regs in bpf_get_task_stack()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-10-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 1494a95e38610..02b6b0e9cb6ce 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -768,14 +768,17 @@ static long __bpf_get_task_stack(struct task_struct *task, void *buf, u32 size,
 	struct pt_regs *regs;
 	long res = -EINVAL;
 
-	if (!try_get_task_stack(task))
+	if (!try_get_task_stack(task)) {
+		memset(buf, 0, size);
 		return -EFAULT;
+	}
 
 	regs = task_pt_regs(task);
 	if (regs)
 		res = __bpf_get_stack(regs, task, buf, size, flags, may_fault);
+	else
+		memset(buf, 0, size);
 	put_task_stack(task);
-
 	return res;
 }
 
-- 
2.53.0



