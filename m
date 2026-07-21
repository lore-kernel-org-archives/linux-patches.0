Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA34415F2B;
	Tue, 21 Jul 2026 18:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658342; cv=none; b=Yp+8a4S3zZzSAK6Hnh0Uhna2SSar4vz/v9/HTris14FpRitU8+yKA83Lt64Gjp4WJsDYG/DbLkhwFznA+sA7ON16Wfmg0v1ymIymf/eH3ROLL+OzcRDHqfl7wZtFNUzUXaVFCyZnHs1vTMGnUlpPJxd1P4zT6PhF5jovDEgbToY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658342; c=relaxed/simple;
	bh=zL7WZYgaT7hhBewjovshOhlBalWg2Wh9oBU14a/24Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7CZuqkJKLqGpIiKG2+ixFHi8PoQbaOUlX3TVG5Qsr2Lh5ExMnqaNjQEtB0rqbdHa6ZZOtK2mB3qQ7AyzGIiopJ2ObfFkpR1dZ1AgBRKShhDW2ixPNsxYVhubgbKdrTJmLZDnZ3D3943fGicD1uvHs9PX9EZ5DTUVitBfFB73ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sa+ZO6rc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sa+ZO6rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AF81F000E9;
	Tue, 21 Jul 2026 18:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658341;
	bh=q7W53kUqaSuu/vM/Ggtsl5vEQHPHuzGZ4K3T5KOBXus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sa+ZO6rcc1qpTYwG4iJ0KNNgoPIc8J2xg6u733gADdpyBvbhs+1eP8deDbDgzxyEU
	 u67VaEIXblPoilD93Zyk7//E6lSWVTk7/SlhyteDtfpRvU0HfBhGs3AMnhH3Hv5cP2
	 iadMCuf/1Z4ZZnURb3TtXF7t7kgqk4Imzw5ooXvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1105/1611] net: atm: reject out-of-range traffic classes in QoS validation
Date: Tue, 21 Jul 2026 17:20:21 +0200
Message-ID: <20260721152540.268863747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Zhengchuan Liang <zcliangcn@gmail.com>

commit cdf19f380e46192e7084be559638aab1f6ed86a2 upstream.

Reject ATM traffic classes above ATM_ANYCLASS in check_tp().
SO_ATMQOS stores the supplied QoS after check_qos() succeeds, so
accepting larger values leaves invalid traffic_class values in
vcc->qos.

That bad state later reaches pvc_info(), which indexes class_name[]
with vcc->qos.{rx,tp}.traffic_class. Values above ATM_ANYCLASS cause
an out-of-bounds read when /proc/net/atm/pvc is read.

Tighten the existing QoS validation so invalid traffic_class values
are rejected at the point where user supplied QoS is accepted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/58f02c6f73d9818fd5d2022e1116759fdde6116b.1780965530.git.zcliangcn@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/atm/common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -720,6 +720,8 @@ static int atm_change_qos(struct atm_vcc
 static int check_tp(const struct atm_trafprm *tp)
 {
 	/* @@@ Should be merged with adjust_tp */
+	if (tp->traffic_class > ATM_ANYCLASS)
+		return -EINVAL;
 	if (!tp->traffic_class || tp->traffic_class == ATM_ANYCLASS)
 		return 0;
 	if (tp->traffic_class != ATM_UBR && !tp->min_pcr && !tp->pcr &&


