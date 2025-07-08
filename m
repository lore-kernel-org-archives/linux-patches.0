Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1ED2E2F0D;
	Tue,  8 Jul 2025 16:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992624; cv=none; b=ragrsQoA4RCUWJamiujFpZsWvEDoWP0uXH/bPKqqD3m7KsPtAaZxSGeuMPPNCuV42liEIhKiAVH5ppUvs8fcGKBtK5NpBxHFzV8CyO35i3vmkPDTMuRWAahbb7b3HDsitoNR13i1iRB43HM86FeR6uu2WQU6efPW38vbWWtZu7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992624; c=relaxed/simple;
	bh=GThcxEVqMberr2yJTvB/OY5luypqNGVL1I4R8qQtGMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUEztjDrx5bsOQ2hIq7NDm4KBQsr9JcQvdOUh6/o1tOvrzAg+K9iIu+T8yf2MjEsxkWDUgnhBs2TWNIDFHdH3AEVVeks//FbFYwmzjEE4TzT2rl5GGMcX2Mtg6Imr3rViw875hG6napa5MJ0IIfkz8b+qMk8QQYTgfNBA6/q73o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xt5q3BOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xt5q3BOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F68C4CEED;
	Tue,  8 Jul 2025 16:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992624;
	bh=GThcxEVqMberr2yJTvB/OY5luypqNGVL1I4R8qQtGMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xt5q3BOWGuC3gjD/BVBbR+ALYfix9EHBuLtyPuaS5jO4QdrC3AwiKFarHdWoBzBbF
	 Y/OL3amApr1QvLBmfl6HlxzJ08Vo6JSDfZtet6JHJ4FFKHz4ZgiJMBjlHMUkg+8btD
	 sVis+pZdy057oNurqKfwPEYvIpaxVJoXSbMMXUxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 024/232] mtk-sd: reset host->mrq on prepare_data() error
Date: Tue,  8 Jul 2025 18:20:20 +0200
Message-ID: <20250708162242.063657547@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1354,6 +1354,7 @@ static void msdc_ops_request(struct mmc_
 	if (mrq->data) {
 		msdc_prepare_data(host, mrq->data);
 		if (!msdc_data_prepared(mrq->data)) {
+			host->mrq = NULL;
 			/*
 			 * Failed to prepare DMA area, fail fast before
 			 * starting any commands.


