Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6571DFD91;
	Tue,  3 Dec 2024 15:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240336; cv=none; b=cULMgCGWto3U7yiGnbK8LNYEFHwYB6uUX0J+Fi++9zQnoZoVBMlwW+VFa0/ekgVNiAnZ4zUJkgZa6UO6AkM0Rv8QjDYNPzVbXhbr1ZdHBLV+Rsr2Eo14zOrT5gjvSjU48Ks8wPrPAfZplNWJ4KBhf+sFTifJiyvKb1QrEN7jPN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240336; c=relaxed/simple;
	bh=6IxqcU7PImgr6pfKPQyUxvixc9/HNwRbNzh7mRbDJcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWAt9YN1Kp6CtZkRJxkgkllbrEZdy38TgBeiQg6Ka8gO1daCELYzr2ijxAJ0QA2Mftrd4x4VAJQ4vpgJ41pZ2kLWtnpy4APC3yq/z+pe7VQ0Nnyccj/tU15dsknikyWqDN4BHPwIa83cL3UgBXpz7x0xuJ7pKYtEACpn3rSmOt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIcVBe5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIcVBe5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51153C4CECF;
	Tue,  3 Dec 2024 15:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240335;
	bh=6IxqcU7PImgr6pfKPQyUxvixc9/HNwRbNzh7mRbDJcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIcVBe5PfiFNzluVBsc8yg40ikSbDcAvXzhseKz2xsHsF2vfXYaDt05wj0YEESGzR
	 ykukCH4drbRw7u3AuI5pEPL75y9n6dwXkKEA/EO29MypKbSnvrL23mK7Efs906QHc4
	 CcFRzrODYDw7m5ftZZ4sSb/uy1nzY2BYCZ2No3ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/826] ACPI: CPPC: Fix _CPC register setting issue
Date: Tue,  3 Dec 2024 15:36:40 +0100
Message-ID: <20241203144746.319601276@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5c0cc7aae8726..e78e3754d99e1 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1140,7 +1140,6 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 			return -EFAULT;
 		}
 		val = MASK_VAL_WRITE(reg, prev_val, val);
-		val |= prev_val;
 	}
 
 	switch (size) {
-- 
2.43.0



