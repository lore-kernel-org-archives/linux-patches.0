Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FA619D074;
	Thu, 25 Jul 2024 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919103; cv=none; b=jHkgptbgt/xhMjAiguTStlZho92ALMGOpsFYcFHGdtJ1sHh0OM91TtU3ygW/WCMteVEusTktTWSjMsEtEHegNuH7rCXQvpNItnqbjvg+9S1BM2u/9JDBSF/qp2J2knWhFBBh7W4uSNSTwwz4fxcIJTITEV40u6GYyF856wVnefw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919103; c=relaxed/simple;
	bh=2F95Z+6lxs9jiIUKF3BCKTzxZPVzsbJzfWeSDp4bGfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEdyk2NcTLdkH5T2SACQpKsGJxFfzX5JMtTMCUu4AIjR5stEvD4hYQqxsFhF18goxs58cYJU265J29614AbynTh6PiuuwhiV58WC73oF6ak2+G3eBIFp8xOl5j3s8Ulecy66AUeTFydTShjIKwLuKsave30iV83YTls0+8CTH1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsJ0+tGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsJ0+tGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D5EC32782;
	Thu, 25 Jul 2024 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919103;
	bh=2F95Z+6lxs9jiIUKF3BCKTzxZPVzsbJzfWeSDp4bGfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsJ0+tGdMD0IEQgKZwo3KP9EHnmuuQyYoicPkgBn0+rLxg05y2KHSF3HaUrT5AnrD
	 TPwYArAwbbzijEQZvtj0OEs+oU9W2CGPDu6w9IhBcqwuOABxo9KHviC6lsLM34SHzN
	 lL/Vdgt90NqP1qrRgao/78IJ75SKoCiKr9SAHurg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Li <liwei391@huawei.com>,
	Huisong Li <lihuisong@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/87] arm64: armv8_deprecated: Fix warning in isndep cpuhp starting process
Date: Thu, 25 Jul 2024 16:36:57 +0200
Message-ID: <20240725142739.346725276@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

From: Wei Li <liwei391@huawei.com>

[ Upstream commit 14951beaec93696b092a906baa0f29322cf34004 ]

The function run_all_insn_set_hw_mode() is registered as startup callback
of 'CPUHP_AP_ARM64_ISNDEP_STARTING', it invokes set_hw_mode() methods of
all emulated instructions.

As the STARTING callbacks are not expected to fail, if one of the
set_hw_mode() fails, e.g. due to el0 mixed-endian is not supported for
'setend', it will report a warning:

```
CPU[2] cannot support the emulation of setend
CPU 2 UP state arm64/isndep:starting (136) failed (-22)
CPU2: Booted secondary processor 0x0000000002 [0x414fd0c1]
```

To fix it, add a check for INSN_UNAVAILABLE status and skip the process.

Signed-off-by: Wei Li <liwei391@huawei.com>
Tested-by: Huisong Li <lihuisong@huawei.com>
Link: https://lore.kernel.org/r/20240423093501.3460764-1-liwei391@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/armv8_deprecated.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index 91eabe56093d6..91c29979aea79 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -471,6 +471,9 @@ static int run_all_insn_set_hw_mode(unsigned int cpu)
 	for (i = 0; i < ARRAY_SIZE(insn_emulations); i++) {
 		struct insn_emulation *insn = insn_emulations[i];
 		bool enable = READ_ONCE(insn->current_mode) == INSN_HW;
+		if (insn->status == INSN_UNAVAILABLE)
+			continue;
+
 		if (insn->set_hw_mode && insn->set_hw_mode(enable)) {
 			pr_warn("CPU[%u] cannot support the emulation of %s",
 				cpu, insn->name);
-- 
2.43.0



