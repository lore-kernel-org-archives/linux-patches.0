Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D631773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDFBC433C7;
	Wed,  9 Aug 2023 11:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579960;
	bh=2uQL/F6/hJ52Pd3GlZgRHGNkwwdzsw1fMacJfJA+ayM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnv/CpD+Y8sp5flJSjahoNZh4C5qvAKEcDCKx/jLK5/7d/JDBef2CPQyCfxCmnffW
	 BrV5gcsV80uNqCwwY+BCblHHQpCVVZKcyajqIZSJb3eN31HOrH3TM4vavNtCyS62aU
	 /UBF7RFv2NxFfqXIbTXqgjGbUgnKG5/DPS8S6GeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 4.19 178/323] tty: serial: samsung_tty: Fix a memory leak in s3c24xx_serial_getclk() when iterating clk
Date: Wed,  9 Aug 2023 12:40:16 +0200
Message-ID: <20230809103706.285254030@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 832e231cff476102e8204a9e7bddfe5c6154a375 upstream.

When the best clk is searched, we iterate over all possible clk.

If we find a better match, the previous one, if any, needs to be freed.
If a better match has already been found, we still need to free the new
one, otherwise it leaks.

Cc: <stable@vger.kernel.org> # v3.3+
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Fixes: 5f5a7a5578c5 ("serial: samsung: switch to clkdev based clock lookup")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Message-ID: <cf3e0053d2fc7391b2d906a86cd01a5ef15fb9dc.1686412569.git.christophe.jaillet@wanadoo.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1230,10 +1230,18 @@ static unsigned int s3c24xx_serial_getcl
 			calc_deviation = -calc_deviation;
 
 		if (calc_deviation < deviation) {
+			/*
+			 * If we find a better clk, release the previous one, if
+			 * any.
+			 */
+			if (!IS_ERR(*best_clk))
+				clk_put(*best_clk);
 			*best_clk = clk;
 			best_quot = quot;
 			*clk_num = cnt;
 			deviation = calc_deviation;
+		} else {
+			clk_put(clk);
 		}
 	}
 


