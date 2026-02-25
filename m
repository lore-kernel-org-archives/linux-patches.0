Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0388124A05D;
	Wed, 25 Feb 2026 01:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983434; cv=none; b=pzGAbDK09yI/65eMlaFTdKidw9GueD8SBV4pIDI1RGdTrVU8RExAn9s/aFd4Dmr2kqzN/LeLEiMdLgUR3jjGOKCTNRy7Fx1ItOoNmdZfysvA2AeWxXcnraW82OrN5gw9dwglhx5H+rLG1n6lsiEahpGSxuzuIFl2nDO0IXmQS1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983434; c=relaxed/simple;
	bh=jwn0fuXTG5Ajyo41D6Wmdc17ZEmZIyPjd43Q0CmYpII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFqVq0s9g6gzJCQXjoacAyvepd2gpj/eO1jhZiYrUVq6wcSQgZ/1XoMlZGXS3WIMU66H5WSIzZhkIP7r0CYCiICBdpTkxta5kip9Lj4Zl3YGOxB65YC8G++sgPfZA5s/v5/L95IKRXHN3W+Q0Dzru78BEzRTH4XruT7SA5z95mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8OtxxCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8OtxxCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B005FC116D0;
	Wed, 25 Feb 2026 01:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983433;
	bh=jwn0fuXTG5Ajyo41D6Wmdc17ZEmZIyPjd43Q0CmYpII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8OtxxCyU/5NCEktEksqR4I1aK8OhINbJbNoyjO2Fq/lZdDTY29BY0+9cVzMi6jDb
	 b3E/NrwvhhiDagYTiV8DctyPvGehM8tzXQU0a9M1BRxMn8v/7P/CNXNktgjoKCWD4z
	 E4sK0F5BcCc+oLnm5JRgfrEcmOleIwoXyZXNFeMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 552/781] clk: x86: cgu: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:21:01 -0800
Message-ID: <20260225012413.342449781@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit bb1b0e63dbbd7150324cb4d6aef7854dbe26a617 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: f7a6bed91a19 ("clk: x86: cgu: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/clk-cgu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/x86/clk-cgu.c b/drivers/clk/x86/clk-cgu.c
index d099667355f8d..92ee05d75af2b 100644
--- a/drivers/clk/x86/clk-cgu.c
+++ b/drivers/clk/x86/clk-cgu.c
@@ -137,10 +137,8 @@ static int lgm_clk_divider_determine_rate(struct clk_hw *hw,
 {
 	struct lgm_clk_divider *divider = to_lgm_clk_divider(hw);
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate, divider->table,
-				       divider->width, divider->flags);
-
-	return 0;
+	return divider_determine_rate(hw, req, divider->table, divider->width,
+				      divider->flags);
 }
 
 static int
-- 
2.51.0



