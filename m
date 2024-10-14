Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068F719E802;
	Mon, 14 Oct 2024 14:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917014; cv=none; b=GBib7kK/snXGp/MNZvcTLxBcH1MrK/lfX0jtVYXgN7Hs4/yyANgsVS08h+Qz1VLOtcWgLamg0Z8beQ0p6KpK9j3U6bV2qNYfEMw/+3e1UzYAX7TFWUhPAAJvDnVdD/unjJzD98A41U2tAk+NVZVu4oE+Ao2BOcqWs1cTJt9Ka+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917014; c=relaxed/simple;
	bh=SZFmlSObVdEdNqnsqcXbCO5Y6VY+vOIFnEGb761Qnd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgWkUXpgsjOACReRsmh473qeT9wVd3hZo75RiQSo4zFpxD9oHIuJzzN2xXn4aGPRiN0cC7WqyICnLJZZprE3fv4CsoizFOWfdrb1O3CBTARZwvalxj/0YQh6cjScfGL63i3izmdOcS6/U+w5jfW4o1DH8/+tHxM4PfPIoz3Xl3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykHVRfRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykHVRfRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D68C4CEC3;
	Mon, 14 Oct 2024 14:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917013;
	bh=SZFmlSObVdEdNqnsqcXbCO5Y6VY+vOIFnEGb761Qnd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykHVRfRHrq941+d9AbnPA7WXzQOK7R8pZ1DSm3mu+YNau1wflgd5k0DoH5zFzB9tn
	 WTOS73FRCmURlc2W21TAtNcn6ebiyJI93PRnsh15aAgnOda3lcNggwMqTlRb7q3NRP
	 XT7jJY3k9xcvmwj2IvyvOjniiY9cdRMntfY1u/5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/213] net: ethernet: adi: adin1110: Fix some error handling path in adin1110_read_fifo()
Date: Mon, 14 Oct 2024 16:20:33 +0200
Message-ID: <20241014141047.927597885@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 83211ae1640516accae645de82f5a0a142676897 ]

If 'frame_size' is too small or if 'round_len' is an error code, it is
likely that an error code should be returned to the caller.

Actually, 'ret' is likely to be 0, so if one of these sanity checks fails,
'success' is returned.

Return -EINVAL instead.

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/8ff73b40f50d8fa994a454911b66adebce8da266.1727981562.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/adi/adin1110.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index d7c274af6d4da..3c26176316a38 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -318,11 +318,11 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 	 * from the  ADIN1110 frame header.
 	 */
 	if (frame_size < ADIN1110_FRAME_HEADER_LEN + ADIN1110_FEC_LEN)
-		return ret;
+		return -EINVAL;
 
 	round_len = adin1110_round_len(frame_size);
 	if (round_len < 0)
-		return ret;
+		return -EINVAL;
 
 	frame_size_no_fcs = frame_size - ADIN1110_FRAME_HEADER_LEN - ADIN1110_FEC_LEN;
 	memset(priv->data, 0, ADIN1110_RD_HEADER_LEN);
-- 
2.43.0



