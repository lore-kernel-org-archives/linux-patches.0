Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A6F1AB522;
	Mon, 14 Oct 2024 14:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917027; cv=none; b=Qh2tm+4TvRgrlDzTJlJzCwmIxgTfpJqrWGyaLKpbJvPr0S15uT/JeRBqPB9ltg1Pr330sGuLZ2KqBXKpNTVXZd0NwpUZrjSEaK3du1gMwp1Y2y4XdM3C+t9XJsrxu3TZygxH/BWREUMarlUZ/VclASpCJX4EXdJUGfNjHa8ep8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917027; c=relaxed/simple;
	bh=q2//NrV2AicymKqkQm9KKWgpMXt7WoyIONNPIq4Vz9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPr8hB8bVQDMGvpy6FDAziReVn0GoiMM3xqXp9G2BsEc1ljKnAEYQOfG8/u3qIp8pKde1+HCTmb2E1mkE12lmG1WCnMhQZUMf/OS9VH3tdcWBuH22xSYCtMdkJlWifllIL/INOMNPC5To22012x12BufC5ZhjwPoPIQIY5AM8/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOdon2cs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOdon2cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D5EC4CEC7;
	Mon, 14 Oct 2024 14:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917027;
	bh=q2//NrV2AicymKqkQm9KKWgpMXt7WoyIONNPIq4Vz9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOdon2csFHZ/UWzfHAMmcswJ6lyQGTFSIRN1Sg0/xoTPyb885a8xLfbwQoXyN6+Gr
	 Dj+DUYuFxI2C3DHZ0v1o9QU+BXajLm3PsRbiYAGMyVimNDQoJxEpybGRKVMBFzxTKW
	 KpuUgVrMXz8A0sqAn9dKVeeYObwfEuLMziTokdVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/213] net: dsa: b53: allow lower MTUs on BCM5325/5365
Date: Mon, 14 Oct 2024 16:20:37 +0200
Message-ID: <20241014141048.082739918@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit e4b294f88a32438baf31762441f3dd1c996778be ]

While BCM5325/5365 do not support jumbo frames, they do support slightly
oversized frames, so do not error out if requesting a supported MTU for
them.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index b43b414b26969..51b41eb660134 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2267,7 +2267,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	bool allow_10_100;
 
 	if (is5325(dev) || is5365(dev))
-		return -EOPNOTSUPP;
+		return 0;
 
 	if (!dsa_is_cpu_port(ds, port))
 		return 0;
-- 
2.43.0



