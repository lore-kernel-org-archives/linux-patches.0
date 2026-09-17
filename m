Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29EE4DDB2B;
	Thu, 17 Sep 2026 16:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661330; cv=none; b=bnCzFTMSaAkQVDkgBcUGe0AuYCG5twtsn01VCqgWquhCouZXKXFs8at2Jo8hbUi82EvEpyyZER2LTGG6XzM3pZmGn37431MDwH3GDSrKWfrdIbw1j3hhVze93mCQAc7c5nb47GBp4mJq/HvqbzcKZ/A1Iu/RI2NE8M/AgVrl+ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661330; c=relaxed/simple;
	bh=+hbN5cv4KOJilsioOqfTLdC66jPUCdHSSecsjZ1JsEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjY5QWPYIT3q9DNxiVgijpscrSEtrT3RFbgvwZdVy7fZdiNYLVGypmH0sGz6XimkZEQKLYDofC3mz+rCVqN/cwSfTaehDWVsUnh0/QZcX1Li17leTcQ2KYwRroVgrrFeSNo8FdJSkV1qMREYhLwsU9g2fF6w5SbA6MG+ezudjTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xzbm8WZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xzbm8WZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320031F000FF;
	Thu, 17 Sep 2026 16:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661329;
	bh=JcTS6/zctChR/nUjn2xptPkhemqTsW76TI0D0AlPYv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xzbm8WZBzVK6mAzKrNNYuQYjBxoUh2TC1tfYSRPux72LsbFWAy0Gfnaqtl2WbGsHE
	 WAe6hridmWffbDtmo0GKV5DjHnHd1qT7Dj2f15gXgDQkAp8bm5a5UcxMHuvNJJIibt
	 4gJJiDNUeQUMR89jq+GsNRP6Lb0XL3Go2b4jb9yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0158/1250] thunderbolt: Improve multi-display DisplayPort tunnel allocation
Date: Thu, 17 Sep 2026 15:59:13 +0100
Message-ID: <20260917151556.363491915@linuxfoundation.org>
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

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit afe9021d63b46233f5c87d52b820fa26e7f562cd ]

When 3 monitors are connected through Thunderbolt dock to the system at
once, one of the monitors might fail to establish DisplayPort tunnel.
This happens during DP bandwidth negotiation - each monitor takes
maximum bandwidth that is supported and there might not be enough for
3rd display. In this case Thunderbolt driver drops DP tunnel and
'forgets' about it but with DP bandwidth allocation mode, that comes in
later, some bandwidth might be freed.

Make Thunderbolt driver check again if DP tunnel can be established
after DP bandwidth consumption changed.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 75367c060695f..205985eb197ec 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -2847,6 +2847,9 @@ static void tb_handle_dp_bandwidth_request(struct work_struct *work)
 
 		/* Update other clients about the allocation change */
 		tb_recalc_estimated_bandwidth(tb);
+
+		tb_dbg(tb, "checking if more DP tunnels can be established now\n");
+		tb_tunnel_dp(tb);
 	}
 
 put_sw:
-- 
2.53.0



