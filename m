Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F52382F29;
	Tue, 10 Mar 2026 11:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140779; cv=none; b=EBU31WDkq1/JNZPRStxls/+WCFRmxP76gx2bgmsSUlyAFvxG0WGjrj9nlb0MyI+2l+z2zhuPn3mduSjT2AbjhxmE4H0cgAPv4MIhlHuwtcqsVrvU2ORdtBv3p2yi9MeqhEqbtgoXfGH+CetB9Jl24h6hstRlytxQtZJNaV8tFfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140779; c=relaxed/simple;
	bh=bh9ZdilRHo6+PBviIBRixa3lKe90KmQ4wen3sNLdz5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAnzK6ZqFsiu/+9KtUB+qSUu8LzYAFhUjk0d+p6GwRH8XZwjRtrQkS12Iz2R+DUQjpqzaVgu3JlhSOEoEJUC3fcWuEiOCTuxtjUe76PlBlPEOlbqtE3unlEt5t2o9eHbqM063I/nQRftkeT3V1kEZFPQKAMXCLogcRCDGm1e9YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qpZAQGft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qpZAQGft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A43C2BC9E;
	Tue, 10 Mar 2026 11:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140779;
	bh=bh9ZdilRHo6+PBviIBRixa3lKe90KmQ4wen3sNLdz5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpZAQGftSHAgKbPJRqtYxabcJqfW4zpr7+b6NE16N0Z/Ar1nSaAkPssuul6ISbyKb
	 51QLZuf30AZVbJaJKq4+/4URBRZ8oMUteZ5RxPr4RcupD+VGoINyp3eDFDRYAuMx1h
	 TF+7DvMl6AaW6Sxp1hzQKQ1oJ841+sQq/nWIUsncet5QRGS0H9sTYxjWKfxBniNd5L
	 wLSg9wF0yPmbtrrO9vIu8cswxNOeFj+NOWBiCkypxfhpVJO/jcvVAV5AZfmaANbnRT
	 tEnSE1k1AlDDiApjYQXNhCli7i8D/gfkLt/4wxsFTBf5z1sm81oofQ+Wndlfohef1h
	 AyqKgiVtjR02Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 013/311] accel: ethosu: Fix shift overflow in cmd_to_addr()
Date: Tue, 10 Mar 2026 07:01:00 -0400
Message-ID: <da66160de93d4533994a9400d390a5541f68be1e.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7be41fb00e2c2a823f271a8318b453ca11812f1e ]

The "((cmd[0] & 0xff0000) << 16)" shift is zero.  This was intended
to be (((u64)cmd[0] & 0xff0000) << 16).  Move the cast to the correct
location.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aQGmY64tWcwOGFP4@stanley.mountain
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ethosu/ethosu_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/ethosu/ethosu_gem.c b/drivers/accel/ethosu/ethosu_gem.c
index 473b5f5d75144..7b073116314ba 100644
--- a/drivers/accel/ethosu/ethosu_gem.c
+++ b/drivers/accel/ethosu/ethosu_gem.c
@@ -154,7 +154,7 @@ static void cmd_state_init(struct cmd_state *st)
 
 static u64 cmd_to_addr(u32 *cmd)
 {
-	return ((u64)((cmd[0] & 0xff0000) << 16)) | cmd[1];
+	return (((u64)cmd[0] & 0xff0000) << 16) | cmd[1];
 }
 
 static u64 dma_length(struct ethosu_validated_cmdstream_info *info,
-- 
2.51.0

