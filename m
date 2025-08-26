Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56F33431FE;
	Tue, 26 Aug 2025 13:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214387; cv=none; b=PKJ/d6jgnZ7Zc+M8O3bqeGv7dFzHNewh8Q7l4ROhkzYT1+elFl+TW3EjWl7xm7Wo0hVJIgDUUz48KDZKPfPFtYa1JbCZZf3Rgj2QTyr19TPJSOhymO+BC/8gcYy6EaJZZXsH7wtwv+RBBRSz8DCbCrpEBhZPXBvFaiSCZe+9mUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214387; c=relaxed/simple;
	bh=2D6QSr4o0o3rKeU/M/mvqghnBrnEklTrYCoxEr0vC/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyBhzZfl168WPOrzQ/C0lwbEfPA5+8dT2V5YodQ1eHNQUJG9qZdkcfFGqVQB5eWD+CAA881Cvj5ZNFuMPir3tco+BwPgl24MvG57d8KPmqDrY4oA+bivkiWmcIInmriz48nXApY/1Lfkqsht/70u9rNTCL9XZNPXo/8FzVkG208=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0TpE5in; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0TpE5in"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021C6C4CEF1;
	Tue, 26 Aug 2025 13:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214387;
	bh=2D6QSr4o0o3rKeU/M/mvqghnBrnEklTrYCoxEr0vC/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0TpE5inhwhvpKwYJeleEgKddIWw9QVl61biGTJ3V1zeE9amYhBwo2xZ4MKWavZni
	 Zc18VzPiWCTSGL26LPSWlxGyVkQ/4UQ6qPLILXcK+3KrqhmV9Gy8as1Pl9tlMWoV8+
	 ccA9m/oEODRWoedC/AzFJuyXvpZfRvKtwVQo8nDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/482] PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()
Date: Tue, 26 Aug 2025 13:05:40 +0200
Message-ID: <20250826110932.979871608@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 313ccb7e7764..61d8ebc2de59 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1753,6 +1753,11 @@ void pm_runtime_reinit(struct device *dev)
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



