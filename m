Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD12149E0E;
	Fri,  6 Dec 2024 14:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496770; cv=none; b=Fb04l2o9YraLDY/XuCvpB5oLWu1ox9+JMaIPF5bwrK0ZZHQiOKrtd7CH73/kLFbzqE4aE87V6KahNFavLi9J9RMiMR4t/nJUJemlc9CUjHFaomBLyDKh8pYQkNnwvujKD9EdoP8MmsIXAx6OSAJTNCF0GZLYcLu4+Tj7Xe+vd5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496770; c=relaxed/simple;
	bh=6s65xQPSsPt3LtUBxXBeA9G/TpxckVgkki9Ci5DLmTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wtabuzq6uOQLrols5ZTdp8Kz8LmNB/jW3KcDVEuuN77RqXBdTgRKaqcQsvtLfGiH9/oTCoXW579CpPStCnjfcSFiIhp8ZjJeEmaHDXA8tVSEIx2DEVwYZyYOJys/EartMsEfqyT+ngD0VCeYD30Re2nY0vcvPpuIpebOHS/fPLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1u9FiUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1u9FiUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2608C4CEDC;
	Fri,  6 Dec 2024 14:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496770;
	bh=6s65xQPSsPt3LtUBxXBeA9G/TpxckVgkki9Ci5DLmTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1u9FiUY2TdbxxO6d8W20BoXbyHcl99EHIfkrGE487mzCsJjeQhUx4sLZpnVsbvHU
	 T1mFYzHN1u6Cw+AUGfsa3BPxFrYw9e7dcdc0+lfblXzDv8/vxZfl5vKGkL3XTxav2D
	 PAAkqcnEl7GJFanyKLEDZ7JSoA1b3YdixSVgcQrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/676] ACPI: CPPC: Fix _CPC register setting issue
Date: Fri,  6 Dec 2024 15:28:37 +0100
Message-ID: <20241206143657.186486358@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 26d1beec99137..ed02a2a9970aa 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1142,7 +1142,6 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 			return -EFAULT;
 		}
 		val = MASK_VAL_WRITE(reg, prev_val, val);
-		val |= prev_val;
 	}
 
 	switch (size) {
-- 
2.43.0



