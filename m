Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3038D70831;
	Tue, 27 May 2025 17:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365700; cv=none; b=eq6y8iqEWSzMFNu9rB3jVJvXcMQwu4LKg5guXqBIp9+02FWUK14n2bChSx7sURpX938DI5bg2W/kSUqh1bdXDm6qHePELNmj2qqjwOqWgiVb/itomHf0XUAcqFDNI5VO+D9wRGNSmj7rymdNKK2Gyf3CrD3aPPEgdqI4t8n0G+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365700; c=relaxed/simple;
	bh=9Mc96PRYPo2AzB796shrUMDYh+ffozfeS+luC7xMoG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrpHb/oAAHtcBQho3Li00shRSjQP6gU2T7cgjzgnQlWDGBJcfdQhuasONyNzfwYMTCs8Tbp07DIykP3ZAW1BBnv7TRjsC2G5+DSKvy1b4wkC3Cpszgpc/5BGtY6vDwOHPgB+ePnAw1uAD+2Q8Y/+vBkhhVRE+zQ6bhvW22n0bjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOWWN87q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOWWN87q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B74C4CEE9;
	Tue, 27 May 2025 17:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365699;
	bh=9Mc96PRYPo2AzB796shrUMDYh+ffozfeS+luC7xMoG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOWWN87qk08t/zmco3iHZC9LmygWpM0LLN4yrhvDIPw8ZVQ2h1bmr+3A5ox5YcFEW
	 VsQvMD2xz9d1lH/2kAZTGr7UVkRZ3EseJXg7P1u80z56f60EW+3qkmWqxXcKJ9nnVl
	 Vc1GUes09hP/y7NP1v3Ac+DbV0ZzqYOVvCuL8afg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 461/626] net/mana: fix warning in the writer of client oob
Date: Tue, 27 May 2025 18:25:54 +0200
Message-ID: <20250527162503.725647312@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 5ec7e1c86c441c46a374577bccd9488abea30037 ]

Do not warn on missing pad_data when oob is in sgl.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://patch.msgid.link/1737394039-28772-9-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 36802e0a8b570..9bac4083d8a09 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1044,7 +1044,7 @@ static u32 mana_gd_write_client_oob(const struct gdma_wqe_request *wqe_req,
 	header->inline_oob_size_div4 = client_oob_size / sizeof(u32);
 
 	if (oob_in_sgl) {
-		WARN_ON_ONCE(!pad_data || wqe_req->num_sge < 2);
+		WARN_ON_ONCE(wqe_req->num_sge < 2);
 
 		header->client_oob_in_sgl = 1;
 
-- 
2.39.5



