Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29A311715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CE9C433C8;
	Mon, 11 Sep 2023 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444777;
	bh=HjEoMxfcPUrIQAsurL38wf9OCmfrWSkQP7Ay/X/2yWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4tZWMcrLiRabe6A9l6k8VQ+G9yGVfVOG3AHN8sZpTacASu8GABeW8bTZOYopXkV1
	 /cci7YaKsHiATyB42M77H/f5DBALyrHmjk6rtgcztN+EcVxBI0CY2CWKi6upi99K0d
	 6sLopSstMr6UM+FNv1eSatqJFXWXd25dIF80+h8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/600] OPP: Fix passing 0 to PTR_ERR in _opp_attach_genpd()
Date: Mon, 11 Sep 2023 15:42:24 +0200
Message-ID: <20230911134636.876686741@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit d920920f85a82c1c806a4143871a0e8f534732f2 ]

If dev_pm_domain_attach_by_name() returns NULL, then 0 will be passed to
PTR_ERR() as reported by the smatch warning below:

drivers/opp/core.c:2456 _opp_attach_genpd() warn: passing zero to 'PTR_ERR'

Fix it by checking for the non-NULL virt_dev pointer before passing it to
PTR_ERR. Otherwise return -ENODEV.

Fixes: 4ea9496cbc95 ("opp: Fix error check in dev_pm_opp_attach_genpd()")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index d707214069ca9..f0d70ecc0271b 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -2372,7 +2372,7 @@ static int _opp_attach_genpd(struct opp_table *opp_table, struct device *dev,
 
 		virt_dev = dev_pm_domain_attach_by_name(dev, *name);
 		if (IS_ERR_OR_NULL(virt_dev)) {
-			ret = PTR_ERR(virt_dev) ? : -ENODEV;
+			ret = virt_dev ? PTR_ERR(virt_dev) : -ENODEV;
 			dev_err(dev, "Couldn't attach to pm_domain: %d\n", ret);
 			goto err;
 		}
-- 
2.40.1



