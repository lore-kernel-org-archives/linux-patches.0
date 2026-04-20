Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640293431F2;
	Mon, 20 Apr 2026 16:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701460; cv=none; b=sGe1diXtWBR7kgwIawvB8iMm1PkwOETbkaxT4XffoaTd4G0WL7NqS29W1JBPCLMTaR5KD8I4JqBvxayfYHoV32GbrtOnxVuKUHdbT+K86Hulr9Cr9fOmd0HKtDcvjOXtdmtwq3tnbSCZhkxO3ruIdVkFCk5Oqb4YHrwEMQdSKPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701460; c=relaxed/simple;
	bh=qtPYfxIvCPv/PfN7GGq17wbsp+Ls/19+PL8CBKs3ENQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIwK2dSjlQxCpObBsLZ0d6u7jYQKqUj4/f0GV/sz9zs4l9ajRhI9w7QugjOVddGgdST3CEX9hp0rKctKjXvt1Y5SLxm4dNbX3z8469qAGCB+3ttQaSBlTemRc9aiS31qhEhjRf5XnXMcZKwOjCmb23/8mj+LgBQKQNzvYSdYCto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOoChAdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOoChAdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FFBC2BCB7;
	Mon, 20 Apr 2026 16:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701460;
	bh=qtPYfxIvCPv/PfN7GGq17wbsp+Ls/19+PL8CBKs3ENQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOoChAdbfQ3x6VXCTjWVJYGE76CYq6SL+MOhIY8lZXnwbgCly1MH17riZLsjMIVyS
	 QCHhINy+cLr9bsbpR4bJqcGYtHHm1Avg19p97HEI4ev71qIRX7tfHKOnwP8DolJ5eF
	 3fD11la6zrULDlyanbS04pLwiucXeTRCpFKQA42I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/162] thermal: core: Mark thermal zones as exiting before unregistration
Date: Mon, 20 Apr 2026 17:42:01 +0200
Message-ID: <20260420153930.258484682@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 1dae3e70b473adc32f81ca1be926440f9b1de9dc ]

In analogy with a previous change in the thermal zone registration code
path, to ensure that __thermal_zone_device_update() will return early
for thermal zones that are going away, introduce a thermal zone state
flag representing the "exit" state and set it while deleting the thermal
zone from thermal_tz_list.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/4394176.ejJDZkT8p0@rjwysocki.net
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
[ mfo: this commit is a dependency/helper for backporting next commit. ]
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 3 +++
 drivers/thermal/thermal_core.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index aa302ac62b2e2..4663ca7a587c5 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1614,7 +1614,10 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 	}
 
 	mutex_lock(&tz->lock);
+
+	tz->state |= TZ_STATE_FLAG_EXIT;
 	list_del(&tz->node);
+
 	mutex_unlock(&tz->lock);
 
 	/* Unbind all cdevs associated with 'this' thermal zone */
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index 163871699a602..007990ce139d3 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -65,6 +65,7 @@ struct thermal_governor {
 #define	TZ_STATE_FLAG_SUSPENDED	BIT(0)
 #define	TZ_STATE_FLAG_RESUMING	BIT(1)
 #define	TZ_STATE_FLAG_INIT	BIT(2)
+#define	TZ_STATE_FLAG_EXIT	BIT(3)
 
 #define TZ_STATE_READY		0
 
-- 
2.53.0



