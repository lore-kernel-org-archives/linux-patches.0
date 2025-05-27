Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1297A28031C;
	Tue, 27 May 2025 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365951; cv=none; b=Clum5NRbFxPKuIlzR1Hu6QiPzScmcdiPElm63uWDNZikRK6ebUNNaj6palIeOGJdpKc/walU0TfiI2O6TN+s19AG8tXpx+O2dMbjYRqpZE+frEP4lqM3RZ8cCzVOku8Grh+SzWpYkqSeAA132pjb53bqTNsRAY6k8Sn6qCnnBYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365951; c=relaxed/simple;
	bh=PDji31/pXWBwyf2E4yCth3Xi1lfOtHT3ZCZ6crq/T9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8J7ZSmkvcEq0U2INhAfAMqDkE7K7XflxUWrYRVTSwFf3M9Moxu95DvhGf3ykwh63NoLTGpwWXeG4j+5YMhnk9WsHprnxbkh+5Uqq2EM/uOXZ416AeOjwaIIwc0TddK9EFwhomhHDjBMcuLYljmL5AH5I9nIbcuGNF6bEVqKN+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrGJcbSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrGJcbSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CF2C4CEE9;
	Tue, 27 May 2025 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365950;
	bh=PDji31/pXWBwyf2E4yCth3Xi1lfOtHT3ZCZ6crq/T9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrGJcbSAOr49Qk/AeER8BWjylp9a4UmdAxFb8rP1U8tz7nCWShhiqWU9NvpgcxzOK
	 UaHjWDxJvSyYKDv0nhg59VJOixpiquphgScimchpBUbBHKuWYXcYlTHrHkwtLgD0mP
	 mjvyN9r+PwmFK6ZrSQMeDCxh3hdjens/hpSQG6f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Matti=20Lehtim=C3=A4ki?= <matti.lehtimaki@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 6.12 541/626] remoteproc: qcom_wcnss: Fix on platforms without fallback regulators
Date: Tue, 27 May 2025 18:27:14 +0200
Message-ID: <20250527162506.973963596@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Lehtimäki <matti.lehtimaki@gmail.com>

[ Upstream commit 4ca45af0a56d00b86285d6fdd720dca3215059a7 ]

Recent change to handle platforms with only single power domain broke
pronto-v3 which requires power domains and doesn't have fallback voltage
regulators in case power domains are missing. Add a check to verify
the number of fallback voltage regulators before using the code which
handles single power domain situation.

Fixes: 65991ea8a6d1 ("remoteproc: qcom_wcnss: Handle platforms with only single power domain")
Signed-off-by: Matti Lehtimäki <matti.lehtimaki@gmail.com>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sdm632-fairphone-fp3
Link: https://lore.kernel.org/r/20250511234026.94735-1-matti.lehtimaki@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index 735d373a9f636..a2ae6adf0053a 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -456,7 +456,8 @@ static int wcnss_init_regulators(struct qcom_wcnss *wcnss,
 	if (wcnss->num_pds) {
 		info += wcnss->num_pds;
 		/* Handle single power domain case */
-		num_vregs += num_pd_vregs - wcnss->num_pds;
+		if (wcnss->num_pds < num_pd_vregs)
+			num_vregs += num_pd_vregs - wcnss->num_pds;
 	} else {
 		num_vregs += num_pd_vregs;
 	}
-- 
2.39.5



