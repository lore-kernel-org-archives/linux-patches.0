Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7EC226D0F;
	Mon, 18 Aug 2025 13:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523396; cv=none; b=qIBDK4qPC4C2MJtNMdY70FjsuyBJdPyagcrjYagr7bpfjPFwpfOhpd3GWf5mF9343kAxG4+7IcxwJMSPc+ax/D+D6+j9CWChMpL7yPqlKdpBWXZIZA2ZzlZqQ1eFu/EILr0DV1XSRRWhw2q4YoF9+Va7RJcfHG2rHI9uCN/nN6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523396; c=relaxed/simple;
	bh=J0s7S5PMdVRwUqdIANh7Mkcpto93xR2ipKV/ERwemrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0SArupKOOF63mrgSJyikG9BJfDpWRIxyJET2H8hNvMofpiRR3VKUeAoeM1LX0UtXWoC4T8MToxmiEA2tKMeR4Nrx7jGkNPwND/7jPonPu+6eLif1DkXB7zvNUj0eb2D1Jz5h9nndisbDMmA5vQouOc+QvGTPtAVx63qtvAE2zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETGDkEgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETGDkEgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D61DC4CEEB;
	Mon, 18 Aug 2025 13:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523395;
	bh=J0s7S5PMdVRwUqdIANh7Mkcpto93xR2ipKV/ERwemrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETGDkEgV1SWC5RMAUsB03hmKyJb7Eexeye1v+pL3zs0yJuZUbq1isnRSPbn6oBl1r
	 THBL98ZOABJTBLkkP1tv2AGi92ljUvJ2tPMOtEwF/0fkUSs/8HBIbGz3kmLzNWqomy
	 4ZQ+vQbaL0px0CtOnjM1kMFeLtDzx04r5XNXRcmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 151/515] PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()
Date: Mon, 18 Aug 2025 14:42:17 +0200
Message-ID: <20250818124504.192858996@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c55a7c70bc1a..1ef26216f971 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1854,6 +1854,11 @@ void pm_runtime_reinit(struct device *dev)
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



