Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D7229BD9A;
	Thu, 17 Sep 2026 18:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668780; cv=none; b=HHpcp1scynKhZ6VLLcBiiEAFSbpWlbahpe/lOUE6yhIxsqVGC920tzhbrrFAeHQa44Ugwljxk0nixm13KWQtY/R2LCPxk4BGWHb511cpUfOCEwa7w4i0VKdr8PRUzPGt5Ln9+5EQC6n60AMbb8lq35C6gNqW5isD4QgqpgcU/54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668780; c=relaxed/simple;
	bh=sson63qFrqGbV/WGJjQp/gOwrkliJ62ZPCRbBDpOfJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyHLQonFpIGWLnpeTVSqIBmzkQdO1DdH2q0U0tdOsWxJSBPNxJVKxqZIKA8P1qdh38h17yAZ+mXDTGlHInf0jAqDdW4uSLlXgoMIdwPvSbtVpq8tSiPQ3Mnad8bwKDCk5qQXFHiN1j43xU8txtR2RU4yPDjYLevybux9+C9Jt8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u64vperD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u64vperD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146541F000FF;
	Thu, 17 Sep 2026 18:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668779;
	bh=1kjgM9ChlN7DDOnUo8vcbAC7ft8NKSGgzjDGfPvnq7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u64vperD2PQEEdzaf3vyC3rxHxYMepYcfec2qqUL0F4Gb2hwPhhsp4wjF8nNkQ6rL
	 4y6u3BByQyyCU6lgltKmugrjg+2d1y1VT9Fe5M+S3eF+pYr7lLyl7Qy1oqzfVGvSe8
	 8q+0pGtHxXMTR3ahUBbPfDt1E1yMb1iQRynhfqg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0538/1102] OPP: of: Fix potential multiplication overflow when calculating freq
Date: Thu, 17 Sep 2026 16:08:01 +0100
Message-ID: <20260917151553.321862018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e2956077e924b..286036abf4ca4 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1107,7 +1107,7 @@ static int _of_add_opp_table_v1(struct device *dev, struct opp_table *opp_table)
 
 	val = prop->value;
 	while (nr) {
-		unsigned long freq = be32_to_cpup(val++) * 1000;
+		unsigned long freq = (unsigned long)be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 		struct dev_pm_opp_data data = {
 			.freq = freq,
-- 
2.53.0



