Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE10551B16D;
	Wed, 30 Sep 2026 18:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791287; cv=none; b=YZix5HMjP+nlrxalVnYJ5iMw5xCpz6dCyK8qQL2m0Vo+OYnTE6YE361RRcbBnneHU/ymPAtKhSdOwSN3nnfwrovmPQM3cWwInbGFy6j21dlJvcZvTe2k1OHv51A3V1LV5R+U+rM0SVkEzsc9AM9rAnXC71TAQifJ+gkVKXzSVEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791287; c=relaxed/simple;
	bh=g6S1kCRnnl35phRRMOoE8psEqjHE0nYixqJ4zDgl778=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFhKrsAC7J02Y+GJSE6zJD6uPO4NNkiBfqsgAsQTp4mYlq620cDgOL1tlY9kkEVrAFWEcaeLJAG+wFy1kkq6QYe9+lbb48jqnbubQjYEMcVT0ryeLqAAzSkOXYIoSkRCijvtBk03AdQtmblrbB6WUc6xg67zU5ecSCiF7aRieOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWWoMFkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWWoMFkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245B31F000FF;
	Wed, 30 Sep 2026 18:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791286;
	bh=OU2nhTvMhS4vmDCyZJU/5q7KeNz+C/8vS4nPkq+UmQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWWoMFkESnMDdpDWO+HaHdB1AeAw13+d9oa5YALhi9TNKD/Pfybg7t6L8rF3+UDQM
	 c327KuBQYw8iLFWmxAbw26YBU0K9LgfaAphh0OnGmeZtsNPsm+thpa/w07JUkwYdXj
	 mNRn1ooDmk643djnfrFGkURvR0t9jH/OlzdC1LcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/752] OPP: of: Fix potential multiplication overflow when calculating freq
Date: Wed, 30 Sep 2026 17:21:59 +0200
Message-ID: <20260930152403.665874840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3028353afece3..83c2e62e92142 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1021,7 +1021,7 @@ static int _of_add_opp_table_v1(struct device *dev, struct opp_table *opp_table)
 
 	val = prop->value;
 	while (nr) {
-		unsigned long freq = be32_to_cpup(val++) * 1000;
+		unsigned long freq = (unsigned long)be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 
 		ret = _opp_add_v1(opp_table, dev, freq, volt, false);
-- 
2.53.0



