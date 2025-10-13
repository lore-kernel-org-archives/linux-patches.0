Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BB117F4F6;
	Mon, 13 Oct 2025 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369041; cv=none; b=qLxF6XY57sPYfDlW5NUQILy5z7VJrSQX/O9hJB92DiOf7yWlIPU6r5Vqg1ugpJ5CqvteSPI1NdP1vFdbguusIVqgLhgkMzgUL62QZELWYAWs/yNfTiv6oD2ufHt5kzzmMXU5xOJ/HSx6kRO8T+rbtAtUT0WChmWxcOwh5NT1Zvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369041; c=relaxed/simple;
	bh=3AiykI2SAQfdfvnhNx/9KUeRlZAmK/dmnkcnAinrZ4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoB0AubnsK7ATFqbO7LpxdWmQJzJfpFt5b3HyxB3kt/UFNJD4MxYuCQY8qHcSMRc+tvEe/enBJ6tLrXZu+jtXL7C1q+NNWIASeE5tB32GhTn4u2Mqg7UoEg2pdH5ShHaDrYvEBZdF+Vd5fPlCoh0qR9GR2jwHpOsyV1/2y2vq/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFxRmqee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFxRmqee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A8DC4CEE7;
	Mon, 13 Oct 2025 15:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369041;
	bh=3AiykI2SAQfdfvnhNx/9KUeRlZAmK/dmnkcnAinrZ4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFxRmqee96oulU0fop1WJ/D0I5J0tpBbspzid5uZDsw7Aiel0yYohDwQeBSJY1w0i
	 V5Ct3RHpoqlURxW4KwbBgh+nwCMinRw56SEvUw1CpmT+RKkLAjvBGfGN5XcEpnvMt3
	 A7LgfArgAsf8PekogCZp2QfKj4BHQwlFK43hVCZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Brian Norris <briannorris@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Gow <davidgow@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 090/563] genirq/test: Ensure CPU 1 is online for hotplug test
Date: Mon, 13 Oct 2025 16:39:11 +0200
Message-ID: <20251013144414.558646608@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 8ad25ebfa70e86860559b306bbc923c7db4fcac6 ]

It's possible to run these tests on platforms that think they have a
hotpluggable CPU1, but for whatever reason, CPU1 is not online and can't be
brought online:

    # irq_cpuhotplug_test: EXPECTATION FAILED at kernel/irq/irq_test.c:210
    Expected remove_cpu(1) == 0, but
        remove_cpu(1) == 1 (0x1)
CPU1: failed to boot: -38
    # irq_cpuhotplug_test: EXPECTATION FAILED at kernel/irq/irq_test.c:214
    Expected add_cpu(1) == 0, but
        add_cpu(1) == -38 (0xffffffffffffffda)

Check that CPU1 is actually online before trying to run the test.

Fixes: 66067c3c8a1e ("genirq: Add kunit tests for depth counts")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/all/20250822190140.2154646-7-briannorris@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irq_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/irq_test.c b/kernel/irq/irq_test.c
index 37568ec714b51..f71f46fdcfd5e 100644
--- a/kernel/irq/irq_test.c
+++ b/kernel/irq/irq_test.c
@@ -178,6 +178,8 @@ static void irq_cpuhotplug_test(struct kunit *test)
 		kunit_skip(test, "requires more than 1 CPU for CPU hotplug");
 	if (!cpu_is_hotpluggable(1))
 		kunit_skip(test, "CPU 1 must be hotpluggable");
+	if (!cpu_online(1))
+		kunit_skip(test, "CPU 1 must be online");
 
 	cpumask_copy(&affinity.mask, cpumask_of(1));
 
-- 
2.51.0



