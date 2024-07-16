Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDF61DA4D;
	Tue, 16 Jul 2024 15:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145582; cv=none; b=U3XNEAQOA60ISbuDBF3sp6yTpWYP+5qxAgUaOfii4QjdQtWZFdBEFlVE63hw4BqtlyOKV6z70AQ24jpRz0p41qJpCABbOqjMblF6WNJPoXUhFMsfEb3gU0N3cahDkRQz8LWw0UNwYVaLZtw9eWG+4Adta2/JA/RTk0MclO+Y+/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145582; c=relaxed/simple;
	bh=2gAf7rzH+OycaytKLM/t1e0Kp6rOppWFvfR+n95FHMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qjm9n4fymf/yA7zyn3yZSi4cMxORdN0DmSMku6fRfZhTIT828XQC9CffmfWkMsLV2SMJAQZNO4CqFJJnMFNPvaKDFZJj5m8sJieCzOX5JqweG1QUWyPmdOW+W7McUdFWlzHfp2lQ6zsLkPzU4RH5VXf4qLzC4vimUYLdbOazSj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnpiAi+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnpiAi+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E35C116B1;
	Tue, 16 Jul 2024 15:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145582;
	bh=2gAf7rzH+OycaytKLM/t1e0Kp6rOppWFvfR+n95FHMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnpiAi+IPlCLjjMputrgkzAnqNZk5I/9joe2PW000DZ5+A+6hlu9OfrA5HqD67U8B
	 2Bz5i5yTh7ZU1qOwDMRHOdyyB1ue8rSkl1GZrVpTcQ317oCXhDFc5FuwYz0j5o/FG8
	 +UsEU6nTghxKaFKXmqPhzvZs9Nh+xjxpmqDcTVQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Justin Chen <justin.chen@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/121] net: bcmasp: Fix error code in probe()
Date: Tue, 16 Jul 2024 17:31:19 +0200
Message-ID: <20240716152751.983844032@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 0c754d9d86ffdf2f86b4272b25d759843fb62fd8 ]

Return an error code if bcmasp_interface_create() fails.  Don't return
success.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Link: https://patch.msgid.link/ZoWKBkHH9D1fqV4r@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
index 4b6bf2764bef7..d9e9ec2e8945d 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -1306,6 +1306,7 @@ static int bcmasp_probe(struct platform_device *pdev)
 			dev_err(dev, "Cannot create eth interface %d\n", i);
 			bcmasp_remove_intfs(priv);
 			of_node_put(intf_node);
+			ret = -ENOMEM;
 			goto of_put_exit;
 		}
 		list_add_tail(&intf->list, &priv->intfs);
-- 
2.43.0



