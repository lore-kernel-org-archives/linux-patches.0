Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E0D326938;
	Sat, 12 Sep 2026 14:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222964; cv=none; b=ZpSjUgesUImw9BKT4mBUre/TzMeBzXO8nJN/2QxFB95U3gNIrdb6byEeTYjHEwyhptk0n0LW1fLtD+G6aPBgn92no6oLGX1oO4EPxV8u8BPjzYFeAa+Anc2gD1Fnpc+HDz6a+aaXcS07mxw+X3pjWtYpWbcjADxuZvZnZhIxKCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222964; c=relaxed/simple;
	bh=EFhE+tu5oWBO2v+0RdVYHRcIwDkTMkZ3qsVSXhyJTo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKWbXhQl4UtIwl9eXbpeLaQH4eVgxzchlxx1nl/1wYexqJzsgFa6sMjgCJHNv/3C3EZHgwcR0HJiZXMWN9yediaavr5aoKrx/pkQUmVEHkGoZ0sy+7X+8wPje9KFPIk8Lrxm0Ouuo1vO7/AExaAAcY+4HITZiFKtf1IOkeeBcTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJSXB9EO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJSXB9EO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4898D1F00893;
	Sat, 12 Sep 2026 14:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222959;
	bh=AsJKRn0tVLtFIQff5Z9uiWcj+bu5k76JfOnzqCWroxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJSXB9EOSkx/tXp74Nt+uVmwUdlQNtk4J1qtgTvOLdA479HqwARQ3BYHjmrpvDPGJ
	 a41ZVZYz018JNb99dVYXFGhomFYuWdiTpKsb/M2PwSSi/UiV8SDeBiS+lBdlHsivch
	 zDaqh8ovZGq8+60+0NHz2RVog7lZ1l7Qh70+WSTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>,
	Yongwei Xu <xuyongwei@open-hieco.net>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0693/1424] iommu/amd: Prevent SB IOAPIC from overriding IVRS validation errors
Date: Sat, 12 Sep 2026 08:52:05 +0200
Message-ID: <20260912065622.818670379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Wang <wei.w.wang@hotmail.com>

[ Upstream commit 854056480f9217568e3ab5edd81a9347a173ea79 ]

The check_ioapic_information() function validates IOAPICs against the
IVRS table to safely disable Interrupt Remapping (IR) if the BIOS provides
a broken topology.

Currently, the validation loop contains a bug: If an unmapped secondary
IOAPIC is encountered, 'ret' is set to false. But if the Southbridge (SB)
IOAPIC is enumerated after it in the MADT, the loop overwrites 'ret' to
true.

This bypasses the validation failure and leaves IR enabled. When devices
attached to the unmapped secondary IOAPIC fire interrupts, the IOMMU drops
them due to the missing Requestor ID, leading to localized device hangs.

Fix this by initializing 'ret' to true and only toggling it to false
upon encountering a validation error, ensuring failures are never erased.

Fixes: c2ff5cf5294b ("iommu/amd: Work around wrong IOAPIC device-id in IVRS table")
Signed-off-by: Wei Wang <wei.w.wang@hotmail.com>
Tested-by: Yongwei Xu <xuyongwei@open-hieco.net>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index d3dc03fa93c65..908500ff2d814 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3029,7 +3029,7 @@ static bool __init check_ioapic_information(void)
 	int idx;
 
 	has_sb_ioapic = false;
-	ret           = false;
+	ret           = true;
 
 	/*
 	 * If we have map overrides on the kernel command line the
@@ -3049,7 +3049,6 @@ static bool __init check_ioapic_information(void)
 			ret = false;
 		} else if (devid == IOAPIC_SB_DEVID) {
 			has_sb_ioapic = true;
-			ret           = true;
 		}
 	}
 
@@ -3063,6 +3062,7 @@ static bool __init check_ioapic_information(void)
 		 * device id for the IOAPIC in the system.
 		 */
 		pr_err("%s: No southbridge IOAPIC found\n", fw_bug);
+		ret = false;
 	}
 
 	if (!ret)
-- 
2.53.0



