Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E029315D5C1;
	Mon, 29 Jan 2024 17:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548401; cv=none; b=mJTMkGZ3KmKnD1hbJ8KeE1eshYdEshs8soN7071DYtPwgDuGg9tI3WjVN7WZ9PRfGEmLE4reWSFBss1QPdZbX1ZG8WPMxwBCfhVJBAuhqP+Rg06/MNwcnx8R2UUN4yTxarkWYe+VqAN7DVNWlC7zJQwWYsc8pGG6NHnRBV5/p2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548401; c=relaxed/simple;
	bh=v1WQJkUf+O+sJ525P+we064tSRGyNWwBzmi44FHJyjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoYUGAZCABW67Wzus352g7jLB/8mdHvkfVlWlR3SZH38IsTuDju8kU/EA3LOvzqkLm4aeJC91Y4eQyu1gpITpqRiJR4gzU5xOaHBfVN6J/HNJ8GffFySCPsvJeRrI6C3i636qU53S9zWWIh4ZpaET+sT9yFYIjxpLXHiNNg3+N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IA5luMPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IA5luMPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB0AC43390;
	Mon, 29 Jan 2024 17:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548400;
	bh=v1WQJkUf+O+sJ525P+we064tSRGyNWwBzmi44FHJyjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IA5luMPfyJ4yri/Yc9uXsnCkXA9ry0S76DvSdRbkS6hHnrijmnjNGJO5SIDD4mlsD
	 zduIAD7V7GFrXZ/kU478AF8lgJSxJGvdNN7BVRH9l0eBwt+T16eUXcmOB9Oq9O7YQI
	 zGjDiukPJ2YJ28BC7/s+q/uIP2mT0FNpLuicG1OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/185] spi: fix finalize message on error return
Date: Mon, 29 Jan 2024 09:06:19 -0800
Message-ID: <20240129170004.343415047@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 8c2ae772fe08e33f3d7a83849e85539320701abd ]

In __spi_pump_transfer_message(), the message was not finalized in the
first error return as it is in the other error return paths. Not
finalizing the message could cause anything waiting on the message to
complete to hang forever.

This adds the missing call to spi_finalize_current_message().

Fixes: ae7d2346dc89 ("spi: Don't use the message queue if possible in spi_sync")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://msgid.link/r/20240125205312.3458541-2-dlechner@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 22d227878bc4..19688f333e0b 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1636,6 +1636,10 @@ static int __spi_pump_transfer_message(struct spi_controller *ctlr,
 			pm_runtime_put_noidle(ctlr->dev.parent);
 			dev_err(&ctlr->dev, "Failed to power device: %d\n",
 				ret);
+
+			msg->status = ret;
+			spi_finalize_current_message(ctlr);
+
 			return ret;
 		}
 	}
-- 
2.43.0



