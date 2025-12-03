Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE86830F800;
	Wed,  3 Dec 2025 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776029; cv=none; b=VqivmHIFwu8MV2eBCp/2B9y9I1tVr7+z0fl9v8aGjbKr4gmNole39UP1NPu46M0rzsrVabyt0oFlwuzRG+PpYd2zpgdtoFBCRgbiLP6SWFIkOVLF3s7xc+pdr0tRx58v3/hHBvkWY8e3WP87QuUWc8txkT++9z42nIEupxwVmaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776029; c=relaxed/simple;
	bh=BtFRgs2Y0TlkNskWTV8PVcJi/ZGf5kTdZDRRV2SC5X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWleBNJzvF3hEa6qxihcVsFFtSlP2Gbr2K1BBVBXO7RI+R/yDlo8jq+Eah2z12Rgw46M2krLvrhNH0/WL0M1Cv8sSz7UpljCQTy/bAq/BGc6sSZxxMTLl3AQqaPSWd9q9HErbD9VJcPl/sHGdan0hqcLcqlnstmPY0VnCqnjx8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/xq2FRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/xq2FRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053E2C4CEF5;
	Wed,  3 Dec 2025 15:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776029;
	bh=BtFRgs2Y0TlkNskWTV8PVcJi/ZGf5kTdZDRRV2SC5X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/xq2FRazRLnSj6dOUYP+/BjlJtltMV8E/abHnyrwdGYmNOsnwKLP47+qj5g0q03l
	 oEDQ0QY/4MwnxDfySM5N/wX5N9ANAFDzW+G/vNFuiX5EAkbjm11QUw9UJH1GRQGMVp
	 YpODrTHYzUwmLvCa3D6CdWLVTjwRPS/YFH75ugMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/300] uprobe: Do not emulate/sstep original instruction when ip is changed
Date: Wed,  3 Dec 2025 16:24:22 +0100
Message-ID: <20251203152402.771621741@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 4363264111e1297fa37aa39b0598faa19298ecca ]

If uprobe handler changes instruction pointer we still execute single
step) or emulate the original instruction and increment the (new) ip
with its length.

This makes the new instruction pointer bogus and application will
likely crash on illegal instruction execution.

If user decided to take execution elsewhere, it makes little sense
to execute the original instruction, so let's skip it.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20250916215301.664963-3-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 1ea2c1f311261..4f2a9fab8ae88 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -2242,6 +2242,13 @@ static void handle_swbp(struct pt_regs *regs)
 
 	handler_chain(uprobe, regs);
 
+	/*
+	 * If user decided to take execution elsewhere, it makes little sense
+	 * to execute the original instruction, so let's skip it.
+	 */
+	if (instruction_pointer(regs) != bp_vaddr)
+		goto out;
+
 	if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
 		goto out;
 
-- 
2.51.0



