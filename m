Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3272DC34C;
	Tue,  8 Jul 2025 17:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994128; cv=none; b=e+8+TwMmz0Jv9G6vQ1Em+OwzuvmD37GBvIQtM0n5kiMAFFzLCgraBSXTyexDUZ4zwtK+y+O6QW7Bstdh/fDtpP2gt8sI5mkdSb7mhqBz405gYpuf1KMqbK2TtEWrcQ1zumfnJ36AOO3qA3nqN2FSWdmftbWTQZJj8OiCnocqiGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994128; c=relaxed/simple;
	bh=dMPyQpBMiJcFI1ARTL+h+Ouxp7+1s9Ba8bV4qUfk3ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUxZHo5jU16QLj2Sf5IxFjVyeqwaMrNkwtLBTRvXhRNIOASTMZM15F/w0r6b2NdvbkFZUo1TnBnAgDpl089yi7/UFhxCC7alWtbb8NRWyvG6J0MuneEZllkcPTyuYsfyiP87PpgKkuuaPNpYwu8VXcbkGY3fPGC3sG01frCr3Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lS8IpZjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lS8IpZjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F5DC4CEED;
	Tue,  8 Jul 2025 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994128;
	bh=dMPyQpBMiJcFI1ARTL+h+Ouxp7+1s9Ba8bV4qUfk3ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lS8IpZjEfherdZdDRmmuA7I8QDfAJG4I7aeaaxrhpN7jLr5nCpO2VE4nHb4zMLRy8
	 jNc6y7Md9ZQXTtk680/74yg3zk723iy0hQmqeIqnYmpP917Iey/HXM8sTJpyq4gJe4
	 tRbSjv8TxjR3vN+CPRm4V2iykQoxlv+maRE1FMBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 104/160] mtk-sd: reset host->mrq on prepare_data() error
Date: Tue,  8 Jul 2025 18:22:21 +0200
Message-ID: <20250708162234.366409216@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit ec54c0a20709ed6e56f40a8d59eee725c31a916b upstream.

Do not leave host with dangling ->mrq pointer if we hit
the msdc_prepare_data() error out path.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Fixes: f5de469990f1 ("mtk-sd: Prevent memory corruption from DMA map failure")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250625052106.584905-1-senozhatsky@chromium.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1314,6 +1314,7 @@ static void msdc_ops_request(struct mmc_
 	if (mrq->data) {
 		msdc_prepare_data(host, mrq->data);
 		if (!msdc_data_prepared(mrq->data)) {
+			host->mrq = NULL;
 			/*
 			 * Failed to prepare DMA area, fail fast before
 			 * starting any commands.


