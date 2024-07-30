Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9626D1A6166;
	Tue, 30 Jul 2024 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356789; cv=none; b=mJyPwFGkgMudP6zTSKYA6FUFg/L8PT7TakY1ufMQBsVRip2mJynHxYLVwNY+5lv7Q5Q3K2/hPvJh5AJfgOHQcfg94fzihLYHM44lMZGxeDc2hxyslCOXR2KRmqj9kuE5NzC3gCzw+urF22aRiO1zJNpzHivDVH09UNA9FC+MUus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356789; c=relaxed/simple;
	bh=IGlmEEAKO3lPQLEj5G5KEzC0qInXf2YLKpVyCPfCvmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/78We+2137KsKCLMz493typ2ZhCZc+ItoSWJKqKkAAvMIG90j1uqxx33L1qguN5hPeg/tI88Vlf9jXHxvAZrrxtaI63z/BFa8S1+mRCDIHerdkhWZuCymrPg08UZt7Ur0UOmbmie2TRcrOfh2BxNzsgy+t70rpbXZi/6lr+vBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4OGxS/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4OGxS/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6F1C32782;
	Tue, 30 Jul 2024 16:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356789;
	bh=IGlmEEAKO3lPQLEj5G5KEzC0qInXf2YLKpVyCPfCvmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4OGxS/GEG+ni2/Dg+FWXAKIiPz2X9nDLTr3EBvHtz34n9EkElsQlBilq+oAmvgoG
	 ItjI238HxHxya4tk5YOKxcxurJCzKxgT8DGuR1oNfqv9C3yK7Fe8aRTNKp/ZVnSj1i
	 1TmGwltYSJfWuUZ/atONzILNEEuEz+KKXvIdfqXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Sun <samsun1006219@gmail.com>,
	Xingwei Lee <xrivendell7@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 187/809] perf/x86: Serialize set_attr_rdpmc()
Date: Tue, 30 Jul 2024 17:41:03 +0200
Message-ID: <20240730151731.996967820@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5b0dd07b1ef19..acd367c453341 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2547,6 +2547,7 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 			      struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
+	static DEFINE_MUTEX(rdpmc_mutex);
 	unsigned long val;
 	ssize_t ret;
 
@@ -2560,6 +2561,8 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 	if (x86_pmu.attr_rdpmc_broken)
 		return -ENOTSUPP;
 
+	guard(mutex)(&rdpmc_mutex);
+
 	if (val != x86_pmu.attr_rdpmc) {
 		/*
 		 * Changing into or out of never available or always available,
-- 
2.43.0



