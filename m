Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4198E8BE8;
	Tue, 30 Jul 2024 16:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355394; cv=none; b=ejT2G9PvTREFmMqkYe/m0SeYqNLDh0JQhXmVxlKnftf5/mXqR/ARKg8qPbiScpSH/mvbDVd0brWUDRlm35Nt1EvlJlklzjesADkxKVVddEqiTEwTSO8NzyKQ2MM1rb2KHyHZyVXKouHsygHKT2n1umT+y7Yim/p0VTMtEYA6Id0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355394; c=relaxed/simple;
	bh=QAEzm+tKrm7Ih6fVZg1RdspvRh2uNXmWAk8XKmt/g8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQ3DQiu+rcyNUzixl1ayir4Ap3pjOWmHjB/qRXcW9R/dM57Fp+dJadozffMkC0cgNdUAFWLTbeGUOMdqgcaogLCQdR1YWTUBii0x7STUIm5edkAaVR1rzi9sey6xb63AhGiPzZn98R5It8J0eS0qdxQosIlTf56+NZNRA/wdGqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCun9iVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCun9iVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44914C32782;
	Tue, 30 Jul 2024 16:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355394;
	bh=QAEzm+tKrm7Ih6fVZg1RdspvRh2uNXmWAk8XKmt/g8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCun9iVeZApJgHcndpLt+kssIAKWAJqb3zoXTPBFO0m/AwaW7fziu2L81fkZSOn9O
	 1rw3vTb7QuSVb3IO3c0YgVrZktjIv/8Yo50hZOX7eMuRVPWyFQV7uh/rIu4SodFL2l
	 WolETpM4kGtR7lolG1pBmpJGJPkHOnKFyaw5uUqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/568] OPP: ti: Fix ti_opp_supply_probe wrong return values
Date: Tue, 30 Jul 2024 17:42:41 +0200
Message-ID: <20240730151641.951812575@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Primoz Fiser <primoz.fiser@norik.com>

[ Upstream commit 3a1ac6b8f603a9310274990a0ad563a5fb709f59 ]

Function ti_opp_supply_probe() since commit 6baee034cb55 ("OPP: ti:
Migrate to dev_pm_opp_set_config_regulators()") returns wrong values
when all goes well and hence driver probing eventually fails.

Fixes: 6baee034cb55 ("OPP: ti: Migrate to dev_pm_opp_set_config_regulators()")
Signed-off-by: Primoz Fiser <primoz.fiser@norik.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/ti-opp-supply.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/opp/ti-opp-supply.c b/drivers/opp/ti-opp-supply.c
index 8f3f13fbbb25a..a8a696d2e03ab 100644
--- a/drivers/opp/ti-opp-supply.c
+++ b/drivers/opp/ti-opp-supply.c
@@ -400,10 +400,12 @@ static int ti_opp_supply_probe(struct platform_device *pdev)
 	}
 
 	ret = dev_pm_opp_set_config_regulators(cpu_dev, ti_opp_config_regulators);
-	if (ret < 0)
+	if (ret < 0) {
 		_free_optimized_voltages(dev, &opp_data);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static struct platform_driver ti_opp_supply_driver = {
-- 
2.43.0



