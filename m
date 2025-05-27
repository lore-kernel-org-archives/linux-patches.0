Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967CE28001F;
	Tue, 27 May 2025 17:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368128; cv=none; b=EkKqOL8zRFqe3FtZAJi10E/5k4l8iBfAeYS5tKdjT6YZpIIQlDEnq0D115NpXBamf97nWmRNS20ymLo+tK0ApGxaSNZEOoX0R239JDvM1Oki0/zZWqvoN/jkIhAIi7/NwYFkkVZj8/DEx09tlnfwy5V/3xZqmmFO9pxhinaKL2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368128; c=relaxed/simple;
	bh=6Dw0HwBT3Hd/zQloUDPB9ZrBveit6mt2DqL+zS2cwxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptxJL9mPQIeMC706ok0sDcCCVgtHW+B8U3p8yuldQ/hQOPXnV+eWAz1eehjgVZn+9974z1F2VXeBx2qh2olzDRrdYacDgVt7krJJsUPiyHlJbkMSAOxbXoyjc8hCo6IclNJO/jgrQE4eocFhwIw0ceBN9TPKtCz8g0dPI945bPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICw3XLKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICw3XLKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06829C4CEE9;
	Tue, 27 May 2025 17:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368128;
	bh=6Dw0HwBT3Hd/zQloUDPB9ZrBveit6mt2DqL+zS2cwxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICw3XLKQt/OfV92UaMEYAuPjOX6wmdm/qpKtbi3+VJhEqAj6OcchepWAvnU5dVTog
	 oMh1FP3IZh+6YiF08JdQ0caKNHHXolwycoDDsqGw0TGyQKbR88bchoN9+Q6LtgwntQ
	 4K4eprVQVbQgNZWXvjZkloz0v0OmDqxcNKkVXpIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 606/783] wifi: ath9k: return by of_get_mac_address
Date: Tue, 27 May 2025 18:26:43 +0200
Message-ID: <20250527162537.833127201@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit dfffb317519f88534bb82797f055f0a2fd867e7b ]

When using nvmem, ath9k could potentially be loaded before nvmem, which
loads after mtd. This is an issue if DT contains an nvmem mac address.

If nvmem is not ready in time for ath9k, -EPROBE_DEFER is returned. Pass
it to _probe so that ath9k can properly grab a potentially present MAC
address.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20241105222326.194417-1-rosenp@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f9e77c4624d99..01e0dffbf57ed 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -647,7 +647,9 @@ static int ath9k_of_init(struct ath_softc *sc)
 		ah->ah_flags |= AH_NO_EEP_SWAP;
 	}
 
-	of_get_mac_address(np, common->macaddr);
+	ret = of_get_mac_address(np, common->macaddr);
+	if (ret == -EPROBE_DEFER)
+		return ret;
 
 	return 0;
 }
-- 
2.39.5



