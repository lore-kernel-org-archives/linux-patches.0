Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE62D4C10C4;
	Thu, 17 Sep 2026 17:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665246; cv=none; b=c3fokfCkUsMDs+40fatgqr1hvFHjmcGYsFXcKNgmkaIr2Zk8t9PxaxFzes9TcWz0ZBAvvQn9cK6dlYVJ2omm3lpgI/oe339l2rntWCfDgzRuvRlrtFsVvqZCGZO+LNzWiJD0jLDzJy0iKZmaF2tIyI0HSJJQdbrz+RKsoAfFkgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665246; c=relaxed/simple;
	bh=g13mNmI5bhZbIAAFe6mQ59gpp9GVplkCf9+jAlg9k6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8CfgRGI4eQj95IqZQD+1wuIhFtjtEax0ZwbxdB3e3AwD8miBXaxeAa2EmYBM6JGC1dfgyWV+DZnmBqo7hAUg1Qd6ZhV50Dyu7PASaqG/VvGVj4pJOtA7bOgg4IEukuiFyroFO5JoGWKf7YYeXUjC5uVrzHLUyZpN6zITzWwexQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3or3rog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3or3rog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9A91F000FF;
	Thu, 17 Sep 2026 17:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665245;
	bh=kCNxwuppdkBcyN9iDNYGHBVqq+9HuZ+D3+0f+5tZ4Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3or3rogBWKojd0Umb5AzBvIgGmaLQ7MGiretMhe1eRKFy6yc+mpApfUu2awaHBda
	 Xdeol5oc1FqG2uRghiJo6FDx53G98EGVN+ZS6lglrk5YuJGGwgaVhcy2D3gvHK8Gg1
	 j6Hrxl5CEPnXtCcrX7pPJq5KMXFbN/9sIub8rxKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0640/1250] OPP: of: Fix potential multiplication overflow when calculating freq
Date: Thu, 17 Sep 2026 16:07:15 +0100
Message-ID: <20260917151609.235549006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit e11811a552252740bd396ec38378e9570ee16578 ]

The multiplication be32_to_cpup(val++) * 1000 is performed using 32 bit
unsigned integers and hence uses a 32 bit multiplication; this will
overflow if be32_to_cpup(val++) is greater than 4294967 (which is
very unlikely at present). The result is assigned to an unsigned long
(which is a 64 bit value on 64 bit systems), so fix this potential
overflow by casting the first operand of the multiplication to
an unsigned int.

Fixes: b496dfbc94ab ("PM / OPP: Initialize OPP table from device tree")

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 7b4b7deb5ac6f..e2f4d89bfad33 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1037,7 +1037,7 @@ static int _of_add_opp_table_v1(struct device *dev, struct opp_table *opp_table)
 
 	val = prop->value;
 	while (nr) {
-		unsigned long freq = be32_to_cpup(val++) * 1000;
+		unsigned long freq = (unsigned long)be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 		struct dev_pm_opp_data data = {
 			.freq = freq,
-- 
2.53.0



