Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845FC3AC0F3;
	Sat, 17 Oct 2026 16:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255186; cv=none; b=rLp4jHPUwtOnr2OZSUAKFrkZy2T/EtMa0yNVztLWfVbWvMYBV/UfNy0ozcZwA10rQrW5GIAXlW2mX4Cz0nPHd2FtJ/i++/nPDNywqMUxcAgh7DVpgY6NmHm47czto+F/2XE0jaSLLG494c7khyVP1fzqklf+ubLN/OoRQwaSKSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255186; c=relaxed/simple;
	bh=nskteiwnZNBrqNSuVceVoh4RiSukp1PmglxCgXV7lZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUSv6+gc+6+XH3umQrNtXXADp72FWjOMRlDRVqwDk5z/LNzlM0ctNoQyd2bIfDD0ZIkl45MBB4V6RPlyaytM1zkIu+WBxXZxcoObobFoWXeTpKvsxwhYbu4Y9oibuleuVQllM+aWZBnrUrCyfi9sfdrNbim8DH4R5Fay3fun5O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kUEWB82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kUEWB82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A161F000C5;
	Sat, 17 Oct 2026 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255185;
	bh=vXUyHBItE5hK8///QyWRkzCIdQQg3P2SY6CGk1lUzrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0kUEWB829etjTYEaLZGOsgC+e/7beDVRr2Yzaln9TWxl3NKKdiQaRCGpcz/bTrlqx
	 Kd8u+zXHnFieiSeE+9O2tqb6m8rgVDlvZqMauxjVg2Du+dZ/VTlm0ASeDeouMIRNoc
	 cckK0JUZHCU/d/5oiPqZ3LHQsPYIonf9JEO9n5So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 656/869] bpf: Clear buf on error in __bpf_get_task_stack
Date: Sat, 17 Oct 2026 17:58:17 +0200
Message-ID: <20261017160053.819813449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 49f724e63e38a..a43b2d8b13e04 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -635,14 +635,17 @@ static long __bpf_get_task_stack(struct task_struct *task, void *buf, u32 size,
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



