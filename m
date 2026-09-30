Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4F151B188;
	Wed, 30 Sep 2026 16:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784977; cv=none; b=ejWyKUeo3OubQaE7AOfFR2HOhWqRDCA6Pgz9+kyFYdXuOE4df0Hd7arQ5twCIQHxByh8pIa8U8/Dv9mRHDgWQm62hmSRgDohHNeJkWg4xZ+Ei7ui0l45SI5xZnDOw9OSPVvNi7PVKxZ1aaqiNGwHvE+Qaf8VWp2DC/9cKEkBU2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784977; c=relaxed/simple;
	bh=vAUgNu0S3A4MWSf0/M58gBwIYBRG6+2Wm6elL9DxUfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsExjCn8L5XOLtQA1N8RHtNrymgUxne4DUH7D8hquPvQJEgTrhFReZ9PNWNdwzObT+0U0FbCfO9HYcbQar/g5RfypWnfxIEe3HTI6UoO/1Ssx11dEmOpaP60FiP9xI2R3R5KFqbLfUQQ0feV+TvHsp65lKAJJphlxm1ipVzl6wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoVZ7n50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoVZ7n50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290C41F000FF;
	Wed, 30 Sep 2026 16:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784974;
	bh=crotQ1yHnaxjf0FtSyOFGj8ySBJTDnc6fEhaof5FkTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qoVZ7n50i4syaF60SLJLsvJ/tZK5avfWJx7LlBUM8U6nZoF+Z6oLxqX/GvwusilA0
	 if54FRQnMzymhipVd9NM7Zi9PBiD1wtUjQN5G3D7ybrezJ0pgicceS+re5arEGASz1
	 pPh11K86HuPoWA4xRimKQnd8G8kKYhNuVU5LVZx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 343/982] OPP: of: Fix potential multiplication overflow when calculating freq
Date: Wed, 30 Sep 2026 17:17:59 +0200
Message-ID: <20260930152424.184045728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c1b2d8927845c..c09e05c5a5711 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1108,7 +1108,7 @@ static int _of_add_opp_table_v1(struct device *dev, struct opp_table *opp_table)
 
 	val = prop->value;
 	while (nr) {
-		unsigned long freq = be32_to_cpup(val++) * 1000;
+		unsigned long freq = (unsigned long)be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 
 		ret = _opp_add_v1(opp_table, dev, freq, volt, false);
-- 
2.53.0



