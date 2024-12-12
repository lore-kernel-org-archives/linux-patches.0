Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6343222D43;
	Thu, 12 Dec 2024 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018332; cv=none; b=aTaa/myKNjaq/EcCpbjlH6+ngFTWeeF0SGg4OtaiU8Xx+HiCb/+6lOZ9dAPdW/f+lW8y9s3oki9/cfnmlYzO3pwxqDEp3k8PcR2KVjiEPAoKMPxbTMNgH9xkdPlTdNnoeiGek13MDWXFc9VvKCp2dTbexUmVslVHw0yoEnl3Wmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018332; c=relaxed/simple;
	bh=HvZt3RR+yXEjHY2u0HkPC6KUYQuQ7CojawpjC26SgHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ag8+k6Qu9GW5yhdkcKIRPHAJtUuylwT+xMwruo6XFXBM5ZtIU6+NIWyrHRLSClPHVwuLtGgbYGapbdUf0wJylZVzwnqVyWLkYrFoKnrx4wE8NV4h+RHQJK8YYLDIUlZAi8RE3HQ/vVcyLp24B3Cy8TLJ3yk5bDm7TA183Vr+JJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yw6EapBf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yw6EapBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BF0C4CECE;
	Thu, 12 Dec 2024 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018332;
	bh=HvZt3RR+yXEjHY2u0HkPC6KUYQuQ7CojawpjC26SgHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yw6EapBfHCVu0I5ksT9qtSnx6GCx8tTGSDlH8oOq5vcfINiZX6FQa+4UxutXWo1uk
	 975MUOZ5e2oGhGi8WZTo9mSVn0fY7cI2RdRx5Y/nWicoiaWHtHoEBuPqcbVAQqDZUQ
	 BSIhS+amVQo6r/Qr7RLecn8kt7esQm2ZsDPbjfWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elena Salomatkina <esalomatkina@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 223/356] net/sched: cbs: Fix integer overflow in cbs_set_port_rate()
Date: Thu, 12 Dec 2024 15:59:02 +0100
Message-ID: <20241212144253.426488088@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Elena Salomatkina <esalomatkina@ispras.ru>

[ Upstream commit 397006ba5d918f9b74e734867e8fddbc36dc2282 ]

The subsequent calculation of port_rate = speed * 1000 * BYTES_PER_KBIT,
where the BYTES_PER_KBIT is of type LL, may cause an overflow.
At least when speed = SPEED_20000, the expression to the left of port_rate
will be greater than INT_MAX.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Elena Salomatkina <esalomatkina@ispras.ru>
Link: https://patch.msgid.link/20241013124529.1043-1-esalomatkina@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index cac870eb78973..0567a15d0f850 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -310,7 +310,7 @@ static void cbs_set_port_rate(struct net_device *dev, struct cbs_sched_data *q)
 {
 	struct ethtool_link_ksettings ecmd;
 	int speed = SPEED_10;
-	int port_rate;
+	s64 port_rate;
 	int err;
 
 	err = __ethtool_get_link_ksettings(dev, &ecmd);
-- 
2.43.0



