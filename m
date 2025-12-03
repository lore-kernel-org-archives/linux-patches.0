Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF0534F49A;
	Wed,  3 Dec 2025 16:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778968; cv=none; b=tGl+v6ibRGucllmTTPFoUAjjDVZ1gHf93vysNdRsBq2dzxb/TM+5RjbSLpscZZN9ekOyNcrswBo7whpINs9TQ/tiSQoVFkOcgCe4EJ1KFGSnKKPjJp67hNoh74pRkQ1In9yB4hheAcC75zWMARV194nxbcDOWwbbrUtZYjVKzoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778968; c=relaxed/simple;
	bh=HUF1DpuwoZN/vyKY6wOYkw9qni6Hoqkfb11b7DEeGmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRM36EdsQi+YK/be9vsUuavmH//lYAsurTYQnABQ84/wm/7yCHm9JOLLWatUPOTQHUEL/0xvBfZqC/uz2yTPmKUY3y+5D3mYBcGXBg9AbCSAV/2l2nkTxfDJQcaGPeH8GKpTfDh/4I3FNvrON8WOGUVnV6F8BEewRbAw03D608c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4VpDKEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4VpDKEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F76DC116C6;
	Wed,  3 Dec 2025 16:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778968;
	bh=HUF1DpuwoZN/vyKY6wOYkw9qni6Hoqkfb11b7DEeGmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4VpDKEHBUANTghkUkCm4TZaoVBVdE/sqnm+RKR+a0lx9myvurCXcxEJHBcY4k090
	 OwG71kxfVV5J1XiLrksMUVgMsBi4JR+t47plPm5uwfbKqv9SiPq2/ThRD6/fWf5LGT
	 iNQwyxTVBqzFf6Cwa4iN51E0sDEO1lvKcEp6H2b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/568] cpuidle: Fail cpuidle device registration if there is one already
Date: Wed,  3 Dec 2025 16:21:58 +0100
Message-ID: <20251203152444.984003058@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 7b1b7961170e4fcad488755e5ffaaaf9bd527e8f ]

Refuse to register a cpuidle device if the given CPU has a cpuidle
device already and print a message regarding it.

Without this, an attempt to register a new cpuidle device without
unregistering the existing one leads to the removal of the existing
cpuidle device without removing its sysfs interface.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 6eceb19882430..fdd25271106a3 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -602,8 +602,14 @@ static void __cpuidle_device_init(struct cpuidle_device *dev)
 static int __cpuidle_register_device(struct cpuidle_device *dev)
 {
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+	unsigned int cpu = dev->cpu;
 	int i, ret;
 
+	if (per_cpu(cpuidle_devices, cpu)) {
+		pr_info("CPU%d: cpuidle device already registered\n", cpu);
+		return -EEXIST;
+	}
+
 	if (!try_module_get(drv->owner))
 		return -EINVAL;
 
@@ -615,7 +621,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 			dev->states_usage[i].disable |= CPUIDLE_STATE_DISABLED_BY_USER;
 	}
 
-	per_cpu(cpuidle_devices, dev->cpu) = dev;
+	per_cpu(cpuidle_devices, cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
 
 	ret = cpuidle_coupled_register_device(dev);
-- 
2.51.0



