Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9281C6BE;
	Tue, 26 Aug 2025 12:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212806; cv=none; b=Qo7MqQHIDCDY/NUomrChG1/sfZiCF2WsuvU+Kd+7h3fi3j2PFnmnWBoROkS1b2SriGNw04CNkhlVi0GXvCjnYkPE8Pn1DSMH3Pt9AE18M/Pes824jua4TRK7Xs0PjYJRNbHBjHkLforYhvj/BpcYO++HsbIvHtsNKu9TXTxDOno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212806; c=relaxed/simple;
	bh=Xw9qEJyJ8eESyhJgLQQxxpRX/kNu2ytkDHW6iLClr1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XN7MbzEJpPYBktfsQg2USyc7DxJRpnLe1NqlHQsjFy2khza1elYT5JJAj5g+eJ/KO4iQK2u94eWeaNzRTDnTa6T5W3pLe3OqAFZSc31akzNbIiRAl7EmDgibDEdxsVCNTQ/4g9b9dV+mrba+3s5F2wawZY8T6CEcHuRZr9sKkMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxzVBA8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxzVBA8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E134C4CEF1;
	Tue, 26 Aug 2025 12:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212806;
	bh=Xw9qEJyJ8eESyhJgLQQxxpRX/kNu2ytkDHW6iLClr1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxzVBA8un+F3PuNC8UFZs8GZeBmtBb2O8J6nUSUskI5qIXDvSTBMCtjY+yg1UDb7q
	 +1e6RQ0rOcUOEnWq89oW4vUUTvbQ4PqFMkX2fOJ9kwZh4FjOw9yCsbEmB2TTM9Zd/t
	 +aiOzGj4YYnkf3OHNlMpBzO57tXKHw1mP1wzN7yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/587] PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()
Date: Tue, 26 Aug 2025 13:04:18 +0200
Message-ID: <20250826110955.711993247@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0d43bf5b6cec..d89439e3605a 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1754,6 +1754,11 @@ void pm_runtime_reinit(struct device *dev)
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



