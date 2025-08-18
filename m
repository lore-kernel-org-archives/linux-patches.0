Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D0F335BAA;
	Mon, 18 Aug 2025 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525123; cv=none; b=s4vM3nnGOtHXelEf8JszRc4+mMAaT6JMvRwhVtHz46wGUN4ZDwpyu4f43/pSVfwwoqTQqU4QDD413ZFkP03MyuVhgBD0rbBRIkYEy2EmUvDV4DYNOi+WjqjSs23cUU11sMdLlyNR03DDJPWmoEQh2BaVFgzJTf+X+QFc24zD2Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525123; c=relaxed/simple;
	bh=hsrwDM33Pcb2oqokXTlUOvrJBoK2tddqMSQNlCRwtdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzvvseDnw93tned6zOFW2bg5C8odERCd3CG8vn3l8AH4M+ffSQSKgiZXudLV3qSjvb8DxV2Ps0r4gGjd9UsmNT1CZQrADgaEbId96GGJ4fjjnCCDYNDze3Kx7Q1pbuxTk5dOYA25ns7g/dAAOuQYK/e0R5QH2CB8Yhmz/I6gYlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTC6/+tm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTC6/+tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBADCC4CEEB;
	Mon, 18 Aug 2025 13:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525123;
	bh=hsrwDM33Pcb2oqokXTlUOvrJBoK2tddqMSQNlCRwtdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTC6/+tmTcNc+NcxlB0VQ8/rHrFM/rGWejr1i+y46+j7NFfOYXyrF99HMxoOAigBo
	 piZGP3vySnnhTUa8ueUec0fKBzNT4nKoOVQ3N6+5+/HkgxBy3sLVRI1boyO2rf8ImT
	 OfGb0xB3QVtTW6UATrj2rPaMgCuzjQbozlmkb+xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 164/570] PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()
Date: Mon, 18 Aug 2025 14:42:31 +0200
Message-ID: <20250818124512.124180745@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



