Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F36A187FF2;
	Tue, 30 Jul 2024 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355455; cv=none; b=TBqE4D+k9mkDPZBmYE3i9RF8iDhcy6V6pJ2xpZ00/Vjj56CVGlkflFu5zrUKB30RQSgSRLYI1Sz6Dpf5OSX7WjpjdJnd2lAhbUFRxkDSBKf7c6KqrsKQH2ilCBYbvGit5TaiTYsDmcg2WCLosZ/Lku062yoCry/69pDKvJlEPOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355455; c=relaxed/simple;
	bh=95ROEakC+WFYBkY5BAs8jue2KH+EyEA9FvMbEVrnVY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=es7uKbQfSG0TaroRHD231J5YbDVr62bRVXjnjGIfLVWNSU/bogJA1ZF7tQeDMyqsMvD+geyreCMcYUUbLtdD+0ri2KybMvTu4wD0V/g48UplTSLXPpHtEmBkdGCkkdvDX5eUvszH95iIj34CWkYRu7ZOi/74e2CyufuvwaahfuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfxhLZFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfxhLZFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F07C4AF0C;
	Tue, 30 Jul 2024 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355455;
	bh=95ROEakC+WFYBkY5BAs8jue2KH+EyEA9FvMbEVrnVY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfxhLZFmg8lBsaejKz3hW1bbRV8gG7Ssv+xn2JXiHKW6jxNGaYKQniSpw2+B5deVu
	 0ZarnHgbWj27h9V0A3K0ViDUUN4rizVBfdSxuJZtLeNzDL5oIbBHk9u9VWmey8qVG6
	 HACcwnPBSZl8+LzM6Zp8MSGwtJ5MBLfYG5PIOpoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Sun <samsun1006219@gmail.com>,
	Xingwei Lee <xrivendell7@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/440] perf/x86: Serialize set_attr_rdpmc()
Date: Tue, 30 Jul 2024 17:45:29 +0200
Message-ID: <20240730151619.631290100@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit bb9bb45f746b0f9457de9c3fc4da143a6351bdc9 ]

Yue and Xingwei reported a jump label failure. It's caused by the lack of
serialization in set_attr_rdpmc():

CPU0                           CPU1

Assume: x86_pmu.attr_rdpmc == 0

if (val != x86_pmu.attr_rdpmc) {
  if (val == 0)
    ...
  else if (x86_pmu.attr_rdpmc == 0)
    static_branch_dec(&rdpmc_never_available_key);

				if (val != x86_pmu.attr_rdpmc) {
				   if (val == 0)
				      ...
				   else if (x86_pmu.attr_rdpmc == 0)
     FAIL, due to imbalance --->      static_branch_dec(&rdpmc_never_available_key);

The reported BUG() is a consequence of the above and of another bug in the
jump label core code. The core code needs a separate fix, but that cannot
prevent the imbalance problem caused by set_attr_rdpmc().

Prevent this by serializing set_attr_rdpmc() locally.

Fixes: a66734297f78 ("perf/x86: Add /sys/devices/cpu/rdpmc=2 to allow rdpmc for all tasks")
Closes: https://lore.kernel.org/r/CAEkJfYNzfW1vG=ZTMdz_Weoo=RXY1NDunbxnDaLyj8R4kEoE_w@mail.gmail.com
Reported-by: Yue Sun <samsun1006219@gmail.com>
Reported-by: Xingwei Lee <xrivendell7@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20240610124406.359476013@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 1394312b732a3..2b2c9fd74ef90 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2573,6 +2573,7 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 			      struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
+	static DEFINE_MUTEX(rdpmc_mutex);
 	unsigned long val;
 	ssize_t ret;
 
@@ -2586,6 +2587,8 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 	if (x86_pmu.attr_rdpmc_broken)
 		return -ENOTSUPP;
 
+	guard(mutex)(&rdpmc_mutex);
+
 	if (val != x86_pmu.attr_rdpmc) {
 		/*
 		 * Changing into or out of never available or always available,
-- 
2.43.0



