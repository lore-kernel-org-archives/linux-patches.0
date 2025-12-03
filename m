Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D82327C03;
	Wed,  3 Dec 2025 15:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777564; cv=none; b=P8F7zENnoc0UdzwxnWX5x4YPF3rC+c34ajSElh2AajQYl0W5HyYeJz/uqCA1y1aLdtbPPEfmU5iwC+nyPuDQLBFL0SGL4ic5SFrOtklhMT2xMldWXVlziJn7le1bZroBRbA0NAYNBNfsfEGEhJ59I/cQ4aJgeFIkGxkkHAZbtUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777564; c=relaxed/simple;
	bh=UI4GVS/wYL2myiWPBEogXyWF/7a3NEBXW/ERz1sq6IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJo35V7wTN5lYEWaJXqoOHXZVBqG1vt/7LRfg046F8AdjSEoNnMhEfKDJ+Sf6vldOm/U8BRC0PhmnePs+piVcZsZpG879frcKKPRpdBRRmVCmr+EeLorOyXGIeaOa8Bn0io+7glJxdAkqojsNH3ULe/C2bmiC1Xrn6ea3LEw9c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMwFnZU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMwFnZU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993E7C116B1;
	Wed,  3 Dec 2025 15:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777564;
	bh=UI4GVS/wYL2myiWPBEogXyWF/7a3NEBXW/ERz1sq6IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMwFnZU6Ms9RFGh8IYapHM18ssyE7Mlvg9emFyqcsq42+5OHWenbDxqQAGuej0a/F
	 LtHXifhqGgYwamR659lLXzbI41DU8eFUspDGoe8VF1FxFRr9Qe3tYTT5BylHhyyvfJ
	 hHkl4tLQ9nIpwsfwcTUYHHb1HWUTNeYTE/ZU0wfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/392] cpuidle: Fail cpuidle device registration if there is one already
Date: Wed,  3 Dec 2025 16:23:48 +0100
Message-ID: <20251203152416.974983473@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ef2ea1b12cd84..e371d6972f8d9 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -597,8 +597,14 @@ static void __cpuidle_device_init(struct cpuidle_device *dev)
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
 
@@ -610,7 +616,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 			dev->states_usage[i].disable |= CPUIDLE_STATE_DISABLED_BY_USER;
 	}
 
-	per_cpu(cpuidle_devices, dev->cpu) = dev;
+	per_cpu(cpuidle_devices, cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
 
 	ret = cpuidle_coupled_register_device(dev);
-- 
2.51.0



