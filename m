Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E181E18F2D4;
	Mon, 28 Oct 2024 06:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097392; cv=none; b=SR0yEoavHCY+GwHFOXXLdWuCVRZHezimMSvb3oPmcbalx6W0T9lVnXP+ULU2a+d1m+1kUzPlzP4rZVuMvcRl6FLsrjB/3B80ddwKHAbhTSnmkOEqc5UWz6+XZREsZFVN1vL/J4pJwQTg1lmIMzTS6X8ix5iH0+ZL+O7nQ5428G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097392; c=relaxed/simple;
	bh=YANqrXjMmhNnNZDFPJ1FW3tWmUZefA9khz18sydkQmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfENhYkf2YSU/yYAua6bnH+Uj+bZNRwKbw5HK1KnGETJs+MdLsdQ8PHV4BRux+llAOMiEaYWCM/QusiW2C2uFvsqxvJpJaEDWeUHH6IZJaO+yi29GRz2SR56qYlvjLK8Txh3f8g+kuQ/cmpHTEXek9yCbVEIDtXxZo+8BJduEuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrrEvVDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrrEvVDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789F7C4CEC3;
	Mon, 28 Oct 2024 06:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097391;
	bh=YANqrXjMmhNnNZDFPJ1FW3tWmUZefA9khz18sydkQmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrrEvVDzkrirjdAjHqgqtifCSaks8VrV93Bvv8iwp3/7brmsSI7havpNimS7sPLSD
	 AgIJgZ5xvP5qEkGHUMMma23tfWFgj9v3MIMFJNaEkw1Pwdmhm3jasoTS0D4WYJu8MP
	 Nr+CBms8badPXirOE1A8NMbO6Gwi4uEnTvDjmyLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/137] powercap: dtpm_devfreq: Fix error check against dev_pm_qos_add_request()
Date: Mon, 28 Oct 2024 07:25:48 +0100
Message-ID: <20241028062301.815280229@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 5209d1b654f1db80509040cc694c7814a1b547e3 ]

The caller of the function dev_pm_qos_add_request() checks again a non
zero value but dev_pm_qos_add_request() can return '1' if the request
already exists. Therefore, the setup function fails while the QoS
request actually did not failed.

Fix that by changing the check against a negative value like all the
other callers of the function.

Fixes: e44655617317 ("powercap/drivers/dtpm: Add dtpm devfreq with energy model support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20241018021205.46460-1-yuancan@huawei.com
[ rjw: Subject edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/dtpm_devfreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/powercap/dtpm_devfreq.c b/drivers/powercap/dtpm_devfreq.c
index 612c3b59dd5be..0ca53db7a90eb 100644
--- a/drivers/powercap/dtpm_devfreq.c
+++ b/drivers/powercap/dtpm_devfreq.c
@@ -166,7 +166,7 @@ static int __dtpm_devfreq_setup(struct devfreq *devfreq, struct dtpm *parent)
 	ret = dev_pm_qos_add_request(dev, &dtpm_devfreq->qos_req,
 				     DEV_PM_QOS_MAX_FREQUENCY,
 				     PM_QOS_MAX_FREQUENCY_DEFAULT_VALUE);
-	if (ret) {
+	if (ret < 0) {
 		pr_err("Failed to add QoS request: %d\n", ret);
 		goto out_dtpm_unregister;
 	}
-- 
2.43.0



