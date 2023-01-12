Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C458A746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFD8C433EF;
	Thu, 12 Jan 2023 14:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532201;
	bh=X1jEoKlEuN1HMnmds3YmDePDpDM3RRYLTf26AB9bl7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHcWiwoPcoE9WFoqUA1gfSH12TXyaosg0s0rUFM4d4PJ5gCfHdr4s/SKKCSp95cGK
	 x+xFck/Pk8N1ngL17IqaVcJhSsQzLhwwYcdca/wJN/jNCajwXDXLwnQHaitIl0STKh
	 E72VQcyLqHH5vVwc4kIWcIlUGHjOqdWtK3zCtK48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Auld <pauld@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/783] cpu/hotplug: Make target_store() a nop when target == state
Date: Thu, 12 Jan 2023 14:46:40 +0100
Message-Id: <20230112135528.061657316@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Phil Auld <pauld@redhat.com>

[ Upstream commit 64ea6e44f85b9b75925ebe1ba0e6e8430cc4e06f ]

Writing the current state back in hotplug/target calls cpu_down()
which will set cpu dying even when it isn't and then nothing will
ever clear it. A stress test that reads values and writes them back
for all cpu device files in sysfs will trigger the BUG() in
select_fallback_rq once all cpus are marked as dying.

kernel/cpu.c::target_store()
	...
        if (st->state < target)
                ret = cpu_up(dev->id, target);
        else
                ret = cpu_down(dev->id, target);

cpu_down() -> cpu_set_state()
	 bool bringup = st->state < target;
	 ...
	 if (cpu_dying(cpu) != !bringup)
		set_cpu_dying(cpu, !bringup);

Fix this by letting state==target fall through in the target_store()
conditional. Also make sure st->target == target in that case.

Fixes: 757c989b9994 ("cpu/hotplug: Make target state writeable")
Signed-off-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Link: https://lore.kernel.org/r/20221117162329.3164999-2-pauld@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 3c9ee966c56a..008b50da2224 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2231,8 +2231,10 @@ static ssize_t write_cpuhp_target(struct device *dev,
 
 	if (st->state < target)
 		ret = cpu_up(dev->id, target);
-	else
+	else if (st->state > target)
 		ret = cpu_down(dev->id, target);
+	else if (WARN_ON(st->target != target))
+		st->target = target;
 out:
 	unlock_device_hotplug();
 	return ret ? ret : count;
-- 
2.35.1



