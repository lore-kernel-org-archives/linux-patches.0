Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AF723236D;
	Mon, 10 Mar 2025 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628205; cv=none; b=sW3v07xoJ9VJVZ6SK2QhegjcZ5Wf7hKnC7DQuqgq1+B3NmzRbfCK5X7Y9f1g1LlN9dOGXUx0Hh+nZZilMr3wLihQBJh4bdL8Y6RaKT5d4b1dfevzQN4Dj04HPL3KltEy9e2YHqNMrtzBeFQRoEzB8svGOwTtJG0X53MNCBn1N/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628205; c=relaxed/simple;
	bh=BsMtMUihKrGvv1qflL/ygO6Vdf7N9Cx3Vde3ukFQqqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcH5PjGt9KSZO0z5x4E0sVv3dYfPge2Z8Z9tLSCHXjAI+vQLIZxUG4ZboBFFDOCXb7/9nGWcOQZjFtDm2aPOvPka9woteO8KX2PUUbVQkw4InWebgbF/0UtBtlmZ86aCsERLqoMJV3Mfg6XMKMiY+a5CPCm7Mmxb8Dq9A2Gefrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCr1SvwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCr1SvwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AC0C4CEE5;
	Mon, 10 Mar 2025 17:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628204;
	bh=BsMtMUihKrGvv1qflL/ygO6Vdf7N9Cx3Vde3ukFQqqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCr1SvwW8VOBQK4HwewTG8vvcqnfMZgJsiA13nG6gZXpqHSyUFKlFXwR2d/qSxu1w
	 SfCPulWNAnPf0rmfgAKf6yv99txv91nS7D1CFCoK26qRTVe2Fj6isHYaYPuE76fZ9I
	 S6gyZgTjgdrIa5+zERs6OfF1OqkQ4uh6yxzMoib8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	stable <stable@kernel.org>,
	Fei Li <fei1.li@intel.com>
Subject: [PATCH 6.6 123/145] drivers: virt: acrn: hsm: Use kzalloc to avoid info leak in pmcmd_ioctl
Date: Mon, 10 Mar 2025 18:06:57 +0100
Message-ID: <20250310170439.735095272@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoyu Li <lihaoyu499@gmail.com>

commit 819cec1dc47cdeac8f5dd6ba81c1dbee2a68c3bb upstream.

In the "pmcmd_ioctl" function, three memory objects allocated by
kmalloc are initialized by "hcall_get_cpu_state", which are then
copied to user space. The initializer is indeed implemented in
"acrn_hypercall2" (arch/x86/include/asm/acrn.h). There is a risk of
information leakage due to uninitialized bytes.

Fixes: 3d679d5aec64 ("virt: acrn: Introduce interfaces to query C-states and P-states allowed by hypervisor")
Signed-off-by: Haoyu Li <lihaoyu499@gmail.com>
Cc: stable <stable@kernel.org>
Acked-by: Fei Li <fei1.li@intel.com>
Link: https://lore.kernel.org/r/20250130115811.92424-1-lihaoyu499@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/acrn/hsm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/virt/acrn/hsm.c
+++ b/drivers/virt/acrn/hsm.c
@@ -49,7 +49,7 @@ static int pmcmd_ioctl(u64 cmd, void __u
 	switch (cmd & PMCMD_TYPE_MASK) {
 	case ACRN_PMCMD_GET_PX_CNT:
 	case ACRN_PMCMD_GET_CX_CNT:
-		pm_info = kmalloc(sizeof(u64), GFP_KERNEL);
+		pm_info = kzalloc(sizeof(u64), GFP_KERNEL);
 		if (!pm_info)
 			return -ENOMEM;
 
@@ -64,7 +64,7 @@ static int pmcmd_ioctl(u64 cmd, void __u
 		kfree(pm_info);
 		break;
 	case ACRN_PMCMD_GET_PX_DATA:
-		px_data = kmalloc(sizeof(*px_data), GFP_KERNEL);
+		px_data = kzalloc(sizeof(*px_data), GFP_KERNEL);
 		if (!px_data)
 			return -ENOMEM;
 
@@ -79,7 +79,7 @@ static int pmcmd_ioctl(u64 cmd, void __u
 		kfree(px_data);
 		break;
 	case ACRN_PMCMD_GET_CX_DATA:
-		cx_data = kmalloc(sizeof(*cx_data), GFP_KERNEL);
+		cx_data = kzalloc(sizeof(*cx_data), GFP_KERNEL);
 		if (!cx_data)
 			return -ENOMEM;
 


