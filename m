Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7841F350834;
	Tue, 26 Aug 2025 13:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216274; cv=none; b=a/vE/psXTgKcab1BosqQtzY5v8uVXKWqbPzVERwmvRuL0UrGE+KLId6d11YCkQsa3wlVniuKpve+BIDvL+w0YSMHH+NfDk2Fwfxk+Adt45wgJHNGbMPe2zeKXIBMxuBCI4CLvSk0Z5DLK97grfOaVHmKDHSZTXX38RsjWkgUGyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216274; c=relaxed/simple;
	bh=7qP+MvxNnSSb1l1O0r+i2qJOVeLk7STfOVMrQzu2XFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdRJtIs+KbzmSK6DZKXnsx4gJMD23t+ChttfSdEpmsTtB2Pz/0gLC70KmwmN76DFruVPi/+L9Ng6/I3ETmLOGney4Gd7Z83LSRvFlWp2OxFN7vsRsaKmG5HjwxCgMgWHYAaRo8YtxBjKb88F/Prwn2qOM/3YWpT4AanvdINSf68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxrztIPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxrztIPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA73C4CEF1;
	Tue, 26 Aug 2025 13:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216274;
	bh=7qP+MvxNnSSb1l1O0r+i2qJOVeLk7STfOVMrQzu2XFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxrztIPt3LfzZffDXI77+iKA97tCZYIdDVvNh5vOMhKtjTIIdBL4jPFT+pecyv2Bx
	 t0ihPK4HEx2h4n9ggnwSRzU8dcZy0E90ENyPVo5IJZxIk+QKEcBZ4yZeRXhKFDnAST
	 axxlszkRwFuTf67dGaloxZwmZy0CE/0OA82cvhFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 303/644] cpufreq: Exit governor when failed to start old governor
Date: Tue, 26 Aug 2025 13:06:34 +0200
Message-ID: <20250826110953.892967317@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 0ae204405095abfbc2d694ee0fbb49bcbbe55c57 ]

Detect the result of starting old governor in cpufreq_set_policy(). If it
fails, exit the governor and clear policy->governor.

Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/20250709104145.2348017-5-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 33c080e08623..addd20bf6be0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2606,10 +2606,12 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	pr_debug("starting governor %s failed\n", policy->governor->name);
 	if (old_gov) {
 		policy->governor = old_gov;
-		if (cpufreq_init_governor(policy))
+		if (cpufreq_init_governor(policy)) {
 			policy->governor = NULL;
-		else
-			cpufreq_start_governor(policy);
+		} else if (cpufreq_start_governor(policy)) {
+			cpufreq_exit_governor(policy);
+			policy->governor = NULL;
+		}
 	}
 
 	return ret;
-- 
2.39.5



