Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D641F2E5B17;
	Tue, 15 Jul 2025 13:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586483; cv=none; b=ZIvxk/ROwN7+uOcmRKLQ4JhPjhQP9I1DGnp2s2eNCfhDt8ht88UUFm4IonIjb/g2cDnRcv2aBDBgFKsPYxJfUfkANA0IbYLcQka0K6RwPnv3dTHz9ft2bKgjp9XmLc0IoU+9nX40rAe7WG8HJ8SIaW5Vm5cggvjMLxZG8x2hc0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586483; c=relaxed/simple;
	bh=hxItP9P4mlP08UcCHGQjoV69i8KHt4oleoUPIApiRnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMiy3khbtmZbYx4uTYRg5fwCyVGUs0SUjwEEU7osJPtJsCYNCKmnlHiu8CL/FNts14Cdm+qQ7Qh7RsFNZit/lxPvHU+B6RIgxfd8bqz7n+sCKYg+YMOKJtifgeB4w9U78ztlB9zja57fhLI0O2qejM63MIQz+bxlnNoPq7C6E0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQHjCeNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQHjCeNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA2AC4CEE3;
	Tue, 15 Jul 2025 13:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586483;
	bh=hxItP9P4mlP08UcCHGQjoV69i8KHt4oleoUPIApiRnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQHjCeNNtx4z/u2s7ylGlJTeI12xhESeZLb6mfE55vRT1QE/qo2V5XmGHgQ0aB6Q8
	 pezccsOpPVfGTaYuPSgByPhn6lhAzXTMYzIWBU4NmPZmTmlVxpducNVIewPRMDbZ9a
	 UVLm2y+RNapo9nh624R0inli4fvdzSnT/w4PUG6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/148] mtk-sd: reset host->mrq on prepare_data() error
Date: Tue, 15 Jul 2025 15:13:25 +0200
Message-ID: <20250715130803.644070255@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit ec54c0a20709ed6e56f40a8d59eee725c31a916b ]

Do not leave host with dangling ->mrq pointer if we hit
the msdc_prepare_data() error out path.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Fixes: f5de469990f1 ("mtk-sd: Prevent memory corruption from DMA map failure")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250625052106.584905-1-senozhatsky@chromium.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index dbe3478cc2308..c374cf40d9558 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1206,6 +1206,7 @@ static void msdc_ops_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	if (mrq->data) {
 		msdc_prepare_data(host, mrq->data);
 		if (!msdc_data_prepared(mrq->data)) {
+			host->mrq = NULL;
 			/*
 			 * Failed to prepare DMA area, fail fast before
 			 * starting any commands.
-- 
2.39.5



