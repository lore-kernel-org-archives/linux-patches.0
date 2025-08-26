Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B921662E7;
	Tue, 26 Aug 2025 14:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217758; cv=none; b=ivXXvemCE1ntro7a6SQHrwfWWzkt9rNC4eRUER1pJ3NBbQ9Y/Vo4ORnz0mjtgtcT+ttUMl8UBmyAQA9Vmj9FJ8bEt6v5zUfktVP459U7vGKQyM7cu6Z30j1PJYk4AQ90yZoMQiuyj4qXWZXibjI4HYlKOKXKi30cDefhJg4lnxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217758; c=relaxed/simple;
	bh=Q8BZyhrTQWgHj5eMlZIqidad/ejmu1rKQ3qiolb7Eec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohiz5pOC+uqcQDjfostw7JB1vEVEFrAXtt8gS2245mYrgbvJ9vzsLfi6LFpntF27AFHtkQ6AXyjtBxrijp0IiP6w02wksySlaNjq7Yue6O2lYyjy7gmf07NKu2UiDOMaVr03+8mJTp6jwzLSCUSiONiMCPY4xA4SzTpRE2G3DPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCcsNutK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCcsNutK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D689C4CEF1;
	Tue, 26 Aug 2025 14:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217758;
	bh=Q8BZyhrTQWgHj5eMlZIqidad/ejmu1rKQ3qiolb7Eec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCcsNutKe/xJ5yVeKWmRGd0b4gabIFNc9HcZXDNi38mCOXrN6B3XwNC5D/c0Pg5yZ
	 mFX+sm2jc6kX+COV0xfDjEZWB96bBCj84s6PLVVPDiLsofRwX1Oxbly1voYUS8VIm5
	 QstmTnfSqTJvha+aKBL2dA2p43x0WoFZFdhhns+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/523] PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()
Date: Tue, 26 Aug 2025 13:07:26 +0200
Message-ID: <20250826110930.268163968@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 58d376b1cd68..7e912d2ed427 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1716,6 +1716,11 @@ void pm_runtime_reinit(struct device *dev)
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



