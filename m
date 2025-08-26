Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA212341AA6;
	Tue, 26 Aug 2025 14:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218938; cv=none; b=d7G+Nr4YUEIXjr7ato2MMyVtBF3Tq9YvB4wQtXAI9R1PbKE2GsMKUE44Wch6yH2F0/LKvzmNdiOCEcu8GJdn8t8mPWZwoaK/417s4IPscmS4dBwFlFIhTK4RLxFu83Pe/nN6aLjqDzxhjpALjrPzsP8I89zR038lotj9JG/Fn9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218938; c=relaxed/simple;
	bh=EQoVCQwyIm9XG/8OdKQNC/0PgJ+8UWQ+yVa8NwE7/zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0M8v0MSOIU0wPr5weoWi62PM7VcGP1IMqmPcyCA9PBegDCIXCiktThfxv49z9p+HxQIeXbnNhkXc6ZIw2M0vSdU30dqbIHzZsIqMTzLxxS2RN/Wqfp4/eatVchq2CAcZuRhosRoYLtSnmnr6H+d8mOpgYiBJO8AvnyQWlAyH0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9TeLCrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9TeLCrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33929C113CF;
	Tue, 26 Aug 2025 14:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218938;
	bh=EQoVCQwyIm9XG/8OdKQNC/0PgJ+8UWQ+yVa8NwE7/zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9TeLCrU6vqnNZlJQAED9rMs9cvl4FepHWy0lu+Q0FQlX41qCQb7zIBRMtsMkYW5p
	 7OO6V8M85lyZlAqaEjnZz3oraOFgarLENCG8a3z6An8psnrC+aXXgXQceVAd8WstJR
	 hm3vakAS1SI8cUyB9MC+MFIWJUvuQ0aNiEHCg5gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 192/403] PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()
Date: Tue, 26 Aug 2025 13:08:38 +0200
Message-ID: <20250826110912.175633386@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 89d9cec3b1e9c49bae9375a2db6dc49bc7468af0 ]

Clear power.needs_force_resume in pm_runtime_reinit() in case it has
been set by pm_runtime_force_suspend() invoked from a driver remove
callback.

Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://patch.msgid.link/9495163.CDJkKcVGEf@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 7fa231076ad5..7d362b38f2e8 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1698,6 +1698,11 @@ void pm_runtime_reinit(struct device *dev)
 				pm_runtime_put(dev->parent);
 		}
 	}
+	/*
+	 * Clear power.needs_force_resume in case it has been set by
+	 * pm_runtime_force_suspend() invoked from a driver remove callback.
+	 */
+	dev->power.needs_force_resume = false;
 }
 
 /**
-- 
2.39.5



