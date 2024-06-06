Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4260E1B3F32;
	Thu,  6 Jun 2024 14:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683434; cv=none; b=EFG1XgwAqtAgMP1IDCCc9LdsH4kT0FwV5Fj2VRX3COj0PBTdX5O1lki60YHlFXqrdAu1O+/R1i229pXFNnU0QjmgLTBckWO5lMfrKgEJhSfSfqQC8EcdkGrYztbGUJeAqQ51tTcT98UivzE1g8RZys2ABvROIDCUTRKqLHmXJk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683434; c=relaxed/simple;
	bh=sExuCXoCSxixjQo/Q0jLJAjZZZ+X6r4JCnD+IRHKjCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbEGqUkAriqOqPdAWRez/7khiUqWgNMyHWFwJ1IbazwTOQHoPyoBpeIshLSwZH2gqmGNlBnNkFup9WjlLoz4wieTjYX3veA5p7iYkYiptqI5YGMGW1vI/WlfqI5aalI1+oShAoCC0Ba+UDgPn4B1oOJqyIr0RtSTSqRgtYw1lRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/d/8/v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/d/8/v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19002C32781;
	Thu,  6 Jun 2024 14:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683434;
	bh=sExuCXoCSxixjQo/Q0jLJAjZZZ+X6r4JCnD+IRHKjCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/d/8/v39QylCVngaMByFtbNxR37NkYTrfSe1uweNjYbOSaCAROVjqgkNFj1CtvGn
	 HZ583RHIWhFxWdAL5IEy7sJmMnSZ0GD6kW+uQIuIz/J1Kv1EDUb0m9kdVAyrKsrYoX
	 gG2lp2rxcPgr5mAp0aZmdA52w+lodIDwiUDJCQec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 319/473] coresight: etm4x: Fix access to resource selector registers
Date: Thu,  6 Jun 2024 16:04:08 +0200
Message-ID: <20240606131710.477139507@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit d6fc00d0f640d6010b51054aa8b0fd191177dbc9 ]

Resource selector pair 0 is always implemented and reserved. We must not
touch it, even during save/restore for CPU Idle. Rest of the driver is
well behaved. Fix the offending ones.

Reported-by: Yabin Cui <yabinc@google.com>
Fixes: f188b5e76aae ("coresight: etm4x: Save/restore state across CPU low power states")
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Tested-by: Yabin Cui <yabinc@google.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Link: https://lore.kernel.org/r/20240412142702.2882478-5-suzuki.poulose@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index e2e5b1422cdb7..354267edcb45f 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1641,7 +1641,8 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 		state->trccntvr[i] = etm4x_read32(csa, TRCCNTVRn(i));
 	}
 
-	for (i = 0; i < drvdata->nr_resource * 2; i++)
+	/* Resource selector pair 0 is reserved */
+	for (i = 2; i < drvdata->nr_resource * 2; i++)
 		state->trcrsctlr[i] = etm4x_read32(csa, TRCRSCTLRn(i));
 
 	for (i = 0; i < drvdata->nr_ss_cmp; i++) {
@@ -1772,7 +1773,8 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 		etm4x_relaxed_write32(csa, state->trccntvr[i], TRCCNTVRn(i));
 	}
 
-	for (i = 0; i < drvdata->nr_resource * 2; i++)
+	/* Resource selector pair 0 is reserved */
+	for (i = 2; i < drvdata->nr_resource * 2; i++)
 		etm4x_relaxed_write32(csa, state->trcrsctlr[i], TRCRSCTLRn(i));
 
 	for (i = 0; i < drvdata->nr_ss_cmp; i++) {
-- 
2.43.0



