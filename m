Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C94A20897E;
	Tue,  8 Apr 2025 11:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110922; cv=none; b=h8qo2iw9Jj82AZcOW7IwFs45bGpXAN0K1phoY+dezVyYswBRFs1SdTJ6f4W7JgwQkp5gUl0c94g8SvutMJ3MRa/pX5ZrvEedvUxi5ttI4H0rOFrG2CfJs17etgb4Xj5xEdN/n/XNo6+gO8BFTgEsfF0Aw1MSzDu98SwLvNc3Xfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110922; c=relaxed/simple;
	bh=nlV1p3BjKR7olL3ewd1m0NF+Nmpi7NJLmTamCSRS4TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8Gyhh/Wituy3ZT/6ngl/BjkYV/568bYP5KcqlyqlO2Omfui+PH9z8xs2lrkpzcZ7WZPs/dKW2/OggSDsxGlLqoCRQhXmtnFebRGGpof0be6HX5xd5X1/DCu9dA6ldrbGldSODMvM/mXY7pPcpmP9BL5LFB9+1COVWrhZrnS700=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVv7jmmD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVv7jmmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2147C4CEE5;
	Tue,  8 Apr 2025 11:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110922;
	bh=nlV1p3BjKR7olL3ewd1m0NF+Nmpi7NJLmTamCSRS4TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVv7jmmDaE3oHQ5O5K/g3f+cthn+RBA+pvKY9m0gjETxzerVqq3koQ1whBDitvFQd
	 //Ik+cR49b/y6hu82hULIK5S3cVa6uIjGEFeokoC6EEn0+6dwdrt7IWakcR6yFryE1
	 QkwNUqzh5HJDwXVfZMDG4nXWy9yajbeTB+RiBjX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 243/731] net: dsa: sja1105: fix displaced ethtool statistics counters
Date: Tue,  8 Apr 2025 12:42:20 +0200
Message-ID: <20250408104919.935129167@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 00eb88752f48615ae7b4c1df6f9271cdd62c1d95 ]

Port counters with no name (aka
sja1105_port_counters[__SJA1105_COUNTER_UNUSED]) are skipped when
reporting sja1105_get_sset_count(), but are not skipped during
sja1105_get_strings() and sja1105_get_ethtool_stats().

As a consequence, the first reported counter has an empty name and a
bogus value (reads from area 0, aka MAC, from offset 0, bits start:end
0:0). Also, the last counter (N_NOT_REACH on E/T, N_RX_BCAST on P/Q/R/S)
gets pushed out of the statistics counters that get shown.

Skip __SJA1105_COUNTER_UNUSED consistently, so that the bogus counter
with an empty name disappears, and in its place appears a valid counter.

Fixes: 039b167d68a3 ("net: dsa: sja1105: don't use burst SPI reads for port statistics")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250318115716.2124395-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_ethtool.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
index 2ea64b1d026d7..84d7d3f66bd03 100644
--- a/drivers/net/dsa/sja1105/sja1105_ethtool.c
+++ b/drivers/net/dsa/sja1105/sja1105_ethtool.c
@@ -571,6 +571,9 @@ void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
 		max_ctr = __MAX_SJA1105PQRS_PORT_COUNTER;
 
 	for (i = 0; i < max_ctr; i++) {
+		if (!strlen(sja1105_port_counters[i].name))
+			continue;
+
 		rc = sja1105_port_counter_read(priv, port, i, &data[k++]);
 		if (rc) {
 			dev_err(ds->dev,
@@ -596,8 +599,12 @@ void sja1105_get_strings(struct dsa_switch *ds, int port,
 	else
 		max_ctr = __MAX_SJA1105PQRS_PORT_COUNTER;
 
-	for (i = 0; i < max_ctr; i++)
+	for (i = 0; i < max_ctr; i++) {
+		if (!strlen(sja1105_port_counters[i].name))
+			continue;
+
 		ethtool_puts(&data, sja1105_port_counters[i].name);
+	}
 }
 
 int sja1105_get_sset_count(struct dsa_switch *ds, int port, int sset)
-- 
2.39.5



