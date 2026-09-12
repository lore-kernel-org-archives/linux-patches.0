Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0472192D8A;
	Sat, 12 Sep 2026 07:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197983; cv=none; b=Um9H6u+pOiVBwakCyERQTUYOfrYs17y9rGJB08gb80B5KUrXfM+I/tPHo0aNkDQWC9rSHc+gkI/PAi99iz2A+iBszxKxntrOjqTIQGwy8IJi5AvPnBPUWU6KvpuxqyDE17zDWszDBNEXSTlM24SXr9/1gkX24BY4hiUzgtBjo4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197983; c=relaxed/simple;
	bh=NRSTJgXIc3XjwbnvELYHaLzAg/MZhuVfBpn8MZ5NlCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOB9hu3CtdpUq2prc5kgUpLun9uW00HsAK0y9B1RvIqjCnsqp2FQK66kXSTh5WMlBYAMihsyiqegC0ajtbRrN/Desil0dDyCSGepo3TOKP43Qo7rGVB7ScKtVtJwcWQ+s8D/E9zl3Fve7gXb7V5fKnMTP/bGZKmwUQou2xCMGuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1MiUBsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1MiUBsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5F81F000FF;
	Sat, 12 Sep 2026 07:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197982;
	bh=hSgnDp9vpmUovMI4U3J4UKUIYaMvUtAwa1ZnScHG50Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1MiUBsjQyJKCzSHQDTnV8RXs7tagxhlTxF0/0xRZh/mW0TjPgxhPt617yUxeW0LH
	 m6SICGSTJAzA6Iwohm9OlEpx+iNhnM10m2cWETi7x2qwTIP8x/pwcmYWk8RkjcxtR7
	 9viExwuSq/TrW/h2Sp44YxP2EA94WkPIG07B2Po8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>,
	Yongwei Xu <xuyongwei@open-hieco.net>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0288/1815] iommu/amd: Prevent SB IOAPIC from overriding IVRS validation errors
Date: Sat, 12 Sep 2026 08:33:58 +0200
Message-ID: <20260912065655.720036158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e7d7b4cb9337f..44749ab83566a 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3098,7 +3098,7 @@ static bool __init check_ioapic_information(void)
 	int idx;
 
 	has_sb_ioapic = false;
-	ret           = false;
+	ret           = true;
 
 	/*
 	 * If we have map overrides on the kernel command line the
@@ -3123,7 +3123,6 @@ static bool __init check_ioapic_information(void)
 			    boot_cpu_data.x86_model <= 0xf &&
 			    devid == IOAPIC_SB_DEVID_FAM18H_M4H)) {
 			has_sb_ioapic = true;
-			ret           = true;
 		}
 	}
 
@@ -3137,6 +3136,7 @@ static bool __init check_ioapic_information(void)
 		 * device id for the IOAPIC in the system.
 		 */
 		pr_err("%s: No southbridge IOAPIC found\n", fw_bug);
+		ret = false;
 	}
 
 	if (!ret)
-- 
2.53.0



