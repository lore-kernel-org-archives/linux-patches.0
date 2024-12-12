Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B77222D73;
	Thu, 12 Dec 2024 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018964; cv=none; b=n4u4ofJCNajhyFt7RAi+QYqWm2N5xwMvrfPy1mj9o8qD8o77vUahOpqkuq9zxSTHJrnjej4PA+WBsqpcrg9ygqR3IK/UYOxPr7pXL9y0ohNrz8Pv0rg2etI6gLRe0nov0zTJaS1MCzJLp9fr8iL+AiFKftbEtaF6df/QQDMx5Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018964; c=relaxed/simple;
	bh=MyzI+tQ3Oj3+Ou5YqAIQA/x3H8pA91l4PdNhXebS0ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxN31Nx1bwkSiyUDR+yG7bOiDc0ElYCw31lSTC69qTVqdSLBy1b0HFREhhSKna3GjGmf4Y85NqEG0DejvDj+PDCB9Oq5P+LIA17qbV2g01tQeOub2Pv2B0vAizcZT0r/BLmv5diGa38vMVUCbHU78QqyhcG6ZSHKEkk8UTnred4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URcjiG9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URcjiG9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238A5C4CECE;
	Thu, 12 Dec 2024 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018963;
	bh=MyzI+tQ3Oj3+Ou5YqAIQA/x3H8pA91l4PdNhXebS0ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URcjiG9upI0CFsAQwPPesYJFSclSXEX19MCVZ8njgNBQHLB7yQzTyakPT0Y0eCtpk
	 ly6bmsFHvBExndhd4aNzjzj9TpmwpYWl1oeOYHPrN58CY8sxBkqt8vFziyYFvebZgK
	 f1y4AEd0Y0jb69oY/VC2EJ/bpCPDukBIcaF/xM9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/772] ACPI: CPPC: Fix _CPC register setting issue
Date: Thu, 12 Dec 2024 15:50:25 +0100
Message-ID: <20241212144353.237340438@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 2388b266c9fcc7c9169ba85c7f9ebe325b7622d7 ]

Since commit 60949b7b8054 ("ACPI: CPPC: Fix MASK_VAL() usage"), _CPC
registers cannot be changed from 1 to 0.

It turns out that there is an extra OR after MASK_VAL_WRITE(), which
has already ORed prev_val with the register mask.

Remove the extra OR to fix the problem.

Fixes: 60949b7b8054 ("ACPI: CPPC: Fix MASK_VAL() usage")
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/20241113103309.761031-1-zhenglifeng1@huawei.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 31ea76b6fa045..0e1fb97d5d763 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1136,7 +1136,6 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 			return -EFAULT;
 		}
 		val = MASK_VAL_WRITE(reg, prev_val, val);
-		val |= prev_val;
 	}
 
 	switch (size) {
-- 
2.43.0



