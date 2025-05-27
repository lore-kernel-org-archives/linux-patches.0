Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CD0194A45;
	Tue, 27 May 2025 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366896; cv=none; b=EOdMw0sxaJt/O2n6suQDEW44k3BhdwNNbYXjLK4n8x7v6M1kInNrcGweDEb3+qLGFdWo24Yjucf1QOJbckdKc7dA0c+s/nUBZ4RXrzopvABvFTnftaQAsGvnK1rzNYv8J+/5tkrEt2I/Fwc4tU5rrmSdaIMzB8o1Ioq0jPVMMMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366896; c=relaxed/simple;
	bh=rBOVoGu66xi9B4oi4slbocc7O133LAsLMbxX7sxJivk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRKFpK8AEetTzEHCfxOT3G+FumoFvyS9wdWAo53rUwNvW8ERYD/mjH9MNLsBWF6FU1YitTrx38kLQpSn4f/tAT6UZ0ZnlbyTTNa7a0VqnuMVGOXpQQ5NBmqvu3CSRg/wH3PhwL/nyoTF5OAXKm39AhjUj3cIgGFyqboLMrm/Oxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayMBVfc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayMBVfc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011F6C4CEE9;
	Tue, 27 May 2025 17:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366895;
	bh=rBOVoGu66xi9B4oi4slbocc7O133LAsLMbxX7sxJivk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayMBVfc5vVGkNYXIjJ3tbcgh31fAhUaJ45tgVAlRibIAiQAtk2qsgxAKCDQrPCISx
	 KkyOC6zegtaJxitdc2mBFOFYjaPxTDaRwGbjEpL5tnQxz/rsZyvRJ+RUGr1+m0dbZC
	 9Aya9xoV2dkVf9AxAh8VIvH76kOfk8zUlMmUgyuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Langsdorf <mlangsdo@redhat.com>,
	Eder Zulian <ezulian@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 184/783] mfd: syscon: Add check for invalid resource size
Date: Tue, 27 May 2025 18:19:41 +0200
Message-ID: <20250527162520.645213216@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eder Zulian <ezulian@redhat.com>

[ Upstream commit ba09916efb29f80e438a54e634970209ce12750f ]

Add a consistency check to avoid assigning an invalid value to
max_register due to a possible DT misconfiguration.

Suggested-by: Mark Langsdorf <mlangsdo@redhat.com>
Signed-off-by: Eder Zulian <ezulian@redhat.com>
Link: https://lore.kernel.org/r/20250212184524.585882-1-ezulian@redhat.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/syscon.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index aa4a9940b569a..ae71a2710bed8 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -47,6 +47,7 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_res)
 	struct regmap_config syscon_config = syscon_regmap_config;
 	struct resource res;
 	struct reset_control *reset;
+	resource_size_t res_size;
 
 	WARN_ON(!mutex_is_locked(&syscon_list_lock));
 
@@ -96,6 +97,12 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_res)
 		}
 	}
 
+	res_size = resource_size(&res);
+	if (res_size < reg_io_width) {
+		ret = -EFAULT;
+		goto err_regmap;
+	}
+
 	syscon_config.name = kasprintf(GFP_KERNEL, "%pOFn@%pa", np, &res.start);
 	if (!syscon_config.name) {
 		ret = -ENOMEM;
@@ -103,7 +110,7 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_res)
 	}
 	syscon_config.reg_stride = reg_io_width;
 	syscon_config.val_bits = reg_io_width * 8;
-	syscon_config.max_register = resource_size(&res) - reg_io_width;
+	syscon_config.max_register = res_size - reg_io_width;
 	if (!syscon_config.max_register)
 		syscon_config.max_register_is_0 = true;
 
-- 
2.39.5



