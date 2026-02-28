Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E394236D9FB;
	Sat, 28 Feb 2026 17:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301447; cv=none; b=Z2+TSlY2rrGz/TDuZUL5+lbZ/Y5um6UEd19jUJumns592xU7TxSmQzOCeBCLv0h59aUwA0Ekn8kdSWGw2gGyOHYLmdBJ4esIWV5YGP4AvHASMrtNTvBKnYNE6vtQfo/hrKawDWTL4KwIrTSyEPkbv4YYOA7093cuCEgIaUGYnQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301447; c=relaxed/simple;
	bh=HOK6VVPwQMZSA/gCzjs8rx3EJsSJSCglVu5VDB49tKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJyz2A+dvyLo+LxiX9X79B/jRzr3rHZJE+YxAHrsGKZk1SR1lgfDV3+oQkEhOfleBCfeLkdyeQX3rYoHYo5/xLJYBu38gg1AqPIhV1ZYWJiCdyxDDlzE0nKgIrP9gQ29qWWY26e2BG0coiQDS9xMblSCM9t+yZomG7IalDMRN1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YYrIy9XB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYrIy9XB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BBAC116D0;
	Sat, 28 Feb 2026 17:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301446;
	bh=HOK6VVPwQMZSA/gCzjs8rx3EJsSJSCglVu5VDB49tKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYrIy9XBjW7QHzxiwCpPx68H6kzGk3zAlu8IWhF7Ij9VReAfUcWUoZ6AxO2upbN6c
	 KCHRAR4vDvQCU+9P+4FFC42lSf5ZTSvf3IQUgmXcI2r30VGzKbDghyf6gvJWhdRXVL
	 OhJrcUbs35FHekwzuvil5Q0i6mGMLSZ+HeTpq5cjvLXnJvWATZR4IxHBRXesr/vNKm
	 WSM8SkoqX0dbFhvcJot9TA6M7yRPUsN9WiYZopMmSJwIEByUYvDA70Lg0vvYOBrbgl
	 WfwK7zYR120uGyXUqzgg/3LapKYmYhViVt91E0y8ciafvWlg3eVsl6BHXDSdRtVyVy
	 nFGYVCh96TWyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	David Spickett <david.spickett@arm.com>,
	stable@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 633/752] arm64: poe: fix stale POR_EL0 values for ptrace
Date: Sat, 28 Feb 2026 12:45:44 -0500
Message-ID: <20260228174750.1542406-633-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

[ Upstream commit 1f3b950492db411e6c30ee0076b61ef2694c100a ]

If a process wrote to POR_EL0 and then crashed before a context switch
happened, the coredump would contain an incorrect value for POR_EL0.

The value read in poe_get() would be a stale value left in thread.por_el0.  Fix
this by reading the value from the system register, if the target thread is the
current thread.

This matches what gcs/fpsimd do.

Fixes: 175198199262 ("arm64/ptrace: add support for FEAT_POE")
Reported-by: David Spickett <david.spickett@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ptrace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index fd1ba43f2005a..2e9ce5a45ed2d 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1458,6 +1458,9 @@ static int poe_get(struct task_struct *target,
 	if (!system_supports_poe())
 		return -EINVAL;
 
+	if (target == current)
+		current->thread.por_el0 = read_sysreg_s(SYS_POR_EL0);
+
 	return membuf_write(&to, &target->thread.por_el0,
 			    sizeof(target->thread.por_el0));
 }
-- 
2.51.0

