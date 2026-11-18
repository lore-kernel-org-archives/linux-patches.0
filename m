Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020968;
	b=lslffbLy9hc1ZjVqbs/0VqikmckqpUjkJw13+n+1jQRg+D3fHc51d7gERbIgItSPOgAx
	 4ggAQA2jiYM+aImqQyJpqds3En/Y7lSc9ES//krOsc1i+pavaS6tWaEM2H3aW0gDQKUwr
	 QlwSgbuQuZa/jo2WX7Sg+zVJL7LEsxum72WtOZC2SCFdBw4KRHGy3jX8F9AgB0Rv6TX0/
	 A4ZEnfJR4aiLh4D19FsqXhWYYRMStin4FtKuUmsa1r2hZYmCMG3F0qQVibw9cK645pTBL
	 gP1zq1kan4KvfLfoaw8N3HvuGZoYbpjyYguFfaIT0DXTel2wUt3YWYEnrQcbH2H18mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=okVf6Y3ToCA14W20zGLQyF7sm16rIZUA78C1Ive2iY8=;
	b=4DPDzjpvkLyfSeIZ8avhUAPhPz5W1jsTeXcc3FDrTRpQsIsESUidOhD8zcMmCiLSMAgw
	 qqvTk51SAWq5B3+RX0sLorld8+Akg99ZmeO+FOP5bpgSauCchW5mQE4y94aI6GhncwC8M
	 SvBw5l4l5GhIfAytI3NZskoz6QAh8UUA7kx8P5W155/Zl1vqOc+25Xfk0YX0VKU1gwKGz
	 hYX1uW4jn+cVzXOi5ySlZBkA1zzeIkZqs0FOElcRjYIRavKxxRVxKI44T66/3pdIndP60
	 LmPChrLEYh9V2lHc8s28jCJGSp1Bg+WvaXlUceFJSnp1bd7zStDK/u2vMWskqbxwvGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzS+xeOc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119AB606A320;
	Wed, 18 Nov 2026 16:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzS+xeOc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF191F000C4;
	Wed, 18 Nov 2026 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020967;
	bh=okVf6Y3ToCA14W20zGLQyF7sm16rIZUA78C1Ive2iY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzS+xeOcKwRw+qpNIE4ZkyX6GnkydnpeN5iDpXgTnz/DBvFF3+pKgUwyv/BqYbSwc
	 wHlSP6JrZes1UNDz2oVbLdO/mUZJg4wC6wSQCcTHth2+CJiGFN9gF71gtfkHFT8t/Z
	 dX28m+VX+1GwKLF8WU5TgertD0PM3wjrlnuVAa14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2138/2651] RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() failure
Date: Wed, 18 Nov 2026 15:56:18 +0100
Message-ID: <20261118150402.844400157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit 4b8f20dc8d25f575e8b8bb5abb09ab803a7e1a3f ]

srp_parse_in() returns -ENOMEM without initializing *has_port if
kstrdup() fails. Only check has_port when srp_parse_in() succeeds.

Fixes: bcef5b721568 ("RDMA/srp: Accept again source addresses that do not have a port number")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261016211509.12973-1-serhatkumral1@gmail.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 955f36efeebd3..5811f02df9805 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3499,7 +3499,7 @@ static int srp_parse_options(struct net *net, const char *buf,
 			}
 			ret = srp_parse_in(net, &target->rdma_cm.dst.ss, p,
 					   &has_port);
-			if (!has_port)
+			if (ret == 0 && !has_port)
 				ret = -EINVAL;
 			if (ret < 0) {
 				pr_warn("bad dest parameter '%s'\n", p);
-- 
2.53.0



