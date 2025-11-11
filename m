Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E18260566;
	Tue, 11 Nov 2025 01:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825367; cv=none; b=MrMeod9JJFPpu9MEvEP5OXtsJnuE7ci4E7+Nf+MWkhiHXwfzzlzNRpSYJKc9aGOrxvt7YD7M4ASHTjTEvL6Fa02C4rPgX6bry78ddGMZMbiZ3frVgQBG6fCY4NAF/hLTsjwjuWlZarEjon0CUWXK2F326frzdiVI50TeiK3WO/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825367; c=relaxed/simple;
	bh=2DQ8DDqFz8qDReWnHjovJAXI3fF3/mNKZTIdMSyxg1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVMriGDwQX4n3WziEk/cz8WTdJ5GX4J62irocFmGERQErzoCgRFBI3PeFaEB51mE95reSCR0U0Z+J0++vGz7NZ5oNGOKmeex1up/2dgfdRCnDv5koI3DCXEMSfrogQurEJJHRDhkh2TOdYVOOS+LmcGW8kwexDVnffUWETkevc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Df+0RyIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Df+0RyIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B7AC19421;
	Tue, 11 Nov 2025 01:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825366;
	bh=2DQ8DDqFz8qDReWnHjovJAXI3fF3/mNKZTIdMSyxg1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Df+0RyIb8B+/0VRjZhxfFo0xQ/Wj/wpKwNY1ypdCbA5JkDTB78teLzpnGgH9pC1AH
	 3ILlKSLvawWS6xLraERYhyXJ+GpQymhdWe3nt3Sz6OLUEA3URPzpHok+GbevTgNIOx
	 Vmc54MdwrkI4E+6y6RxG7lM9oZKgGbmUeTbmG1mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 773/849] net: dsa: b53: properly bound ARL searches for < 4 ARL bin chips
Date: Tue, 11 Nov 2025 09:45:43 +0900
Message-ID: <20251111004555.118549182@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit e57723fe536f040cc2635ec1545dd0a7919a321e ]

When iterating over the ARL table we stop at max ARL entries / 2, but
this is only valid if the chip actually returns 2 results at once. For
chips with only one result register we will stop before reaching the end
of the table if it is more than half full.

Fix this by only dividing the maximum results by two if we have a chip
with more than one result register (i.e. those with 4 ARL bins).

Fixes: cd169d799bee ("net: dsa: b53: Bound check ARL searches")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251102100758.28352-4-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index b467500699c70..eb767edc4c135 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2087,13 +2087,16 @@ static int b53_fdb_copy(int port, const struct b53_arl_entry *ent,
 int b53_fdb_dump(struct dsa_switch *ds, int port,
 		 dsa_fdb_dump_cb_t *cb, void *data)
 {
+	unsigned int count = 0, results_per_hit = 1;
 	struct b53_device *priv = ds->priv;
 	struct b53_arl_entry results[2];
-	unsigned int count = 0;
 	u8 offset;
 	int ret;
 	u8 reg;
 
+	if (priv->num_arl_bins > 2)
+		results_per_hit = 2;
+
 	mutex_lock(&priv->arl_mutex);
 
 	if (is5325(priv) || is5365(priv))
@@ -2115,7 +2118,7 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 		if (ret)
 			break;
 
-		if (priv->num_arl_bins > 2) {
+		if (results_per_hit == 2) {
 			b53_arl_search_rd(priv, 1, &results[1]);
 			ret = b53_fdb_copy(port, &results[1], cb, data);
 			if (ret)
@@ -2125,7 +2128,7 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 				break;
 		}
 
-	} while (count++ < b53_max_arl_entries(priv) / 2);
+	} while (count++ < b53_max_arl_entries(priv) / results_per_hit);
 
 	mutex_unlock(&priv->arl_mutex);
 
-- 
2.51.0



