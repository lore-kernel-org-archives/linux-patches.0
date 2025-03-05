Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36F31A5BB7;
	Wed,  5 Mar 2025 18:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198346; cv=none; b=PnT0fgmW0cQnfoRo6U4uhxdmZPZbtLzRo7hACm4AsfXcI7Q9SLIL0xHqlH7BAAc15FUEz++Byp6h4RF2lybsCS3lFp3lUbjx+/UTrmaPtOlPmgrF6hck8M4khDGzip0J5zw7fb/1Y5L5APrjCMOAyUmLFqYl9cuh6Eos/GiNK7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198346; c=relaxed/simple;
	bh=2IJsbip9uQxDckkuMe7i8KlAeVosVSYa8IC0/BCElGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyjaO0+fb5/U+QQCl9Mf80j//FcxF3MA5qfh1Yv6Op3QYkG+8OsaaCqjWDJSVHmw0pny2U1pXMLERHqyZHPBn4YBAn8MONmFW1chBfv9RYJkoqfSbqVxULkTO4vioTs94FR9QEaoUVF9yIrBAbzwFyV/qccIzSwcqcwyjjCm6S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAMjb6bL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAMjb6bL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA8FC4CED1;
	Wed,  5 Mar 2025 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198345;
	bh=2IJsbip9uQxDckkuMe7i8KlAeVosVSYa8IC0/BCElGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAMjb6bLQjnajF2jNE9AMwagJPjZJQXDImJM/bSBC92To51TGj+7iTEtkSv5oxk0W
	 bfHs1vOJDV2o53Rq/ob0riB3Aveq0gZfGvdzzyiZ3ai7AscCSElgeuKQSf2Eyg4SeL
	 JWv7RrsfcBmVnir7HA495O3+sTB10C3ExikTdn/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 116/150] net: enetc: fix the off-by-one issue in enetc_map_tx_tso_buffs()
Date: Wed,  5 Mar 2025 18:49:05 +0100
Message-ID: <20250305174508.479675468@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit 249df695c3ffe8c8d36d46c2580ce72410976f96 upstream.

There is an off-by-one issue for the err_chained_bd path, it will free
one more tx_swbd than expected. But there is no such issue for the
err_map_data path. To fix this off-by-one issue and make the two error
handling consistent, the increment of 'i' and 'count' remain in sync
and enetc_unwind_tx_frame() is called for error handling.

Fixes: fb8629e2cbfc ("net: enetc: add support for software TSO")
Cc: stable@vger.kernel.org
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://patch.msgid.link/20250224111251.1061098-9-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -590,8 +590,13 @@ static int enetc_map_tx_tso_buffs(struct
 			err = enetc_map_tx_tso_data(tx_ring, skb, tx_swbd, txbd,
 						    tso.data, size,
 						    size == data_len);
-			if (err)
+			if (err) {
+				if (i == 0)
+					i = tx_ring->bd_count;
+				i--;
+
 				goto err_map_data;
+			}
 
 			data_len -= size;
 			count++;
@@ -620,13 +625,7 @@ err_map_data:
 	dev_err(tx_ring->dev, "DMA map error");
 
 err_chained_bd:
-	do {
-		tx_swbd = &tx_ring->tx_swbd[i];
-		enetc_free_tx_frame(tx_ring, tx_swbd);
-		if (i == 0)
-			i = tx_ring->bd_count;
-		i--;
-	} while (count--);
+	enetc_unwind_tx_frame(tx_ring, count, i);
 
 	return 0;
 }


