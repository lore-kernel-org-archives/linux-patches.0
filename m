Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7164629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02ABEC433D6;
	Wed,  2 Nov 2022 03:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359830;
	bh=2wmwYwVfhI8cA8+mg7+tGbyhNEomvYPMRzUJTtUEHuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPR8YztZVUKrxG/6aSZ6lwRBVvK5AAwOlS8ktiWgtayjbDBiqQrkwNNpjXNFgp2gJ
	 x8azdyARPXwjJrgcWbPAavIUIqbJTvRgWNOvwoQVhMINRlLsrFd6XQdroMYDOi+V8Y
	 xqT1gYkpcg9laOj+mK0zKy1i4w/IjtYNq8TufBfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Ma <mahongwei@zeku.com>,
	Weizhao Ouyang <ouyangweizhao@zeku.com>,
	John Wang <wangdayu@zeku.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 41/78] mmc: core: Fix kernel panic when remove non-standard SDIO card
Date: Wed,  2 Nov 2022 03:34:26 +0100
Message-Id: <20221102022054.196853363@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Ma <mahongwei@zeku.com>

commit 9972e6b404884adae9eec7463e30d9b3c9a70b18 upstream.

SDIO tuple is only allocated for standard SDIO card, especially it causes
memory corruption issues when the non-standard SDIO card has removed, which
is because the card device's reference counter does not increase for it at
sdio_init_func(), but all SDIO card device reference counter gets decreased
at sdio_release_func().

Fixes: 6f51be3d37df ("sdio: allow non-standard SDIO cards")
Signed-off-by: Matthew Ma <mahongwei@zeku.com>
Reviewed-by: Weizhao Ouyang <ouyangweizhao@zeku.com>
Reviewed-by: John Wang <wangdayu@zeku.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221014034951.2300386-1-ouyangweizhao@zeku.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sdio_bus.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -264,7 +264,8 @@ static void sdio_release_func(struct dev
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 
-	sdio_free_func_cis(func);
+	if (!(func->card->quirks & MMC_QUIRK_NONSTD_SDIO))
+		sdio_free_func_cis(func);
 
 	kfree(func->info);
 	kfree(func->tmpbuf);


