Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A302E1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FE4C433D2;
	Wed, 28 Dec 2022 15:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240401;
	bh=SBV3fhOxfYVj85du5pfVY+VQvTdVqOoix7ayqI5XTCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/zQ7qsXJDjCCJVkNXUfaOxrGiBlOIdRu4hRSG3wOUZQmppECUO7/r4B1zB8kiSp4
	 3FvQCi9T4HoptTd2guPrrfXTgoPPcLB11TfUPtxIHhJymlqhb+Pv/LOb8s/XKJdyI0
	 FFDKXBga8nropGaQ5W0A90DZhExs8l9Ws70iYYkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Auld <pauld@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0156/1073] cpu/hotplug: Make target_store() a nop when target == state
Date: Wed, 28 Dec 2022 15:29:04 +0100
Message-Id: <20221228144332.258162381@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index bbad5e375d3b..979de993f853 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2326,8 +2326,10 @@ static ssize_t target_store(struct device *dev, struct device_attribute *attr,
 
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



