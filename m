Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA08E2153C1;
	Thu, 12 Dec 2024 16:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021924; cv=none; b=d2DiughMqPbbqTvdq0PgGTUvJgooEHsSvaGcdPpTW8FJU+me0zDqeDnkSGRWiwba3nTmJRQ5sGw3y1MGB0qBFfXJzhkmS0Sr8KV6L1h0ca2AIMb/Yl/s293WPRoXfXt+zj63BLpU6ICUmSCWoNg9oAn43b+iJ/q3A9zno4oFzh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021924; c=relaxed/simple;
	bh=/+4iKP77/G542Wih85WTxa5p6zXObU9gFOahu22Q/70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTj4va2vWF/feMiRZlSPaEgD3v8Nj0GHWhR4TY2HVFMmg0nMK3gwdmgOKc9s7YghjGqj8U9UQYMip8Eo8l4hKyhXXsPdr9Jlh+0JBcOr/XKxIVP/a+Mgylzg3syl3evKHOVyEt4r3/vOrH7BvCJWIowjYbYRwD5nZGPQWbUPh5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORuhWEwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORuhWEwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168DAC4CECE;
	Thu, 12 Dec 2024 16:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021924;
	bh=/+4iKP77/G542Wih85WTxa5p6zXObU9gFOahu22Q/70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORuhWEwjntgr28//Xvzto93cWf8TnGjoFb2lu2RrDr3D6vu3E9QKRfGHsDKwtdVg7
	 u3A4uTTaOs8DJK5xSyDoPJK6dDKPsyMx9GUv5aiwzIK52PcR5Yb/5v6FuxoHtHLq/E
	 ok95v0r8qDpID4vFW219dDbkHORacz/hzOFYc6QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/565] ACPI: CPPC: Fix _CPC register setting issue
Date: Thu, 12 Dec 2024 15:54:55 +0100
Message-ID: <20241212144315.439031568@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0e9ccedb08dab..7ede4a504d272 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1067,7 +1067,6 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 			return -EFAULT;
 		}
 		val = MASK_VAL_WRITE(reg, prev_val, val);
-		val |= prev_val;
 	}
 
 	switch (size) {
-- 
2.43.0



