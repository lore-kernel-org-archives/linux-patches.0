Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6B51F6664;
	Tue,  3 Dec 2024 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237972; cv=none; b=e96nJdEDuapNtgH1q39LuR66Sx+ANLdDvI0AcLyd5Dsb/mNC5a/VDhRjz/1kqavlYMC0iJ+Mnjjqlj39ir/GB0kUJKkU32YbXu8MXEsaabQlXA6PXktMOK/koz2z2lT4xpcEnxG61HMHRubkATom8wtsLgA16cc0zDq6zqWgBN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237972; c=relaxed/simple;
	bh=XmP3FVFzXfflqLYtn4SOjzzeDbmTZPy/23omssj4y+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9lUQzE7cYv8+10p8v7WqgIwn3LCh4tDHvUH6BbgAcoZ0mcxu+B0oRxVf4dZp1XczbzW67DehmgE4qiC86LIbtcMWSbbTdfPq0zdSSZiroKSVQIkV/HO/qvUqYWjA7NjSIyUOsbGfVBwS+3AZ1F0Ba6C8o6URmVG58kwxBbz34k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=en2WJ3AL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="en2WJ3AL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DD3C4CECF;
	Tue,  3 Dec 2024 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237972;
	bh=XmP3FVFzXfflqLYtn4SOjzzeDbmTZPy/23omssj4y+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=en2WJ3ALMuBoC2W3npZCQTMEJf+18SuEya6F5j7pBXAep047CbeZtTwdNALPU1FML
	 CaYSQ9hUGewg+lS/Abyf5Sg92J+lMg36QbvkfIsvCVuhvFceCGTmj0MLR6CxvvuET/
	 NWnleOyrJqGwZ7Qrhfa+HQIhrFpBqJ50kD//LsiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 121/817] ACPI: CPPC: Fix _CPC register setting issue
Date: Tue,  3 Dec 2024 15:34:53 +0100
Message-ID: <20241203144000.438150800@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 544f53ae9cc0c..3a39c0a04163c 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1146,7 +1146,6 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 			return -EFAULT;
 		}
 		val = MASK_VAL_WRITE(reg, prev_val, val);
-		val |= prev_val;
 	}
 
 	switch (size) {
-- 
2.43.0



