Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E21211705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B80C433C7;
	Mon, 11 Sep 2023 14:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443114;
	bh=hY3WG94tWaF6YwoziJw0I/DbzFHeZsaS66mIND79Pfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRPfRUiyqotDPnB0VbC7I6s6OLjhjMwj8Isa0V4LMYWBg8YRs9xpmB6E24mE1EYl5
	 /m6ax6gmv8bySFqQZeT6vB/cOIsXUsH2nQE8Q0lCp9YotqBq7hSFjZ07nAsmLO455R
	 1atuNOlwneypIuAdHvPo+/1Lb2IAoLzzmdm7J2So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 262/737] pds_core: no health reporter in VF
Date: Mon, 11 Sep 2023 15:42:01 +0200
Message-ID: <20230911134657.907688666@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit e48b894a1db7f6ce66bff0402ab21ff9f0e56034 ]

Make sure the health reporter is set up before we use it in
our devlink health updates, especially since the VF doesn't
set up the health reporter.

Fixes: 25b450c05a49 ("pds_core: add devlink health facilities")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230824161754.34264-3-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 483a070d96fa9..2a315f2da37d7 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -524,7 +524,8 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 	}
 
 	/* Notify clients of fw_down */
-	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
+	if (pdsc->fw_reporter)
+		devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
 	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	pdsc_stop(pdsc);
@@ -554,8 +555,9 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 
 	/* Notify clients of fw_up */
 	pdsc->fw_recoveries++;
-	devlink_health_reporter_state_update(pdsc->fw_reporter,
-					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+	if (pdsc->fw_reporter)
+		devlink_health_reporter_state_update(pdsc->fw_reporter,
+						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
 	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	return;
-- 
2.40.1



