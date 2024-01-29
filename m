Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA8815B98E;
	Mon, 29 Jan 2024 17:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548644; cv=none; b=BCxUzXgyIKVsfpToeKlq44vpXc7RDv9N6cQbZKnoJJ1XUS5xzdZLsfRWPVPsCBaE9B2ClYjIJyk3iQhvnvOq0j3mCfrqWv4DLHLmMcrmAWwufacjQVBa9AkZQiXljXQ4hkqw42zD+dbX2osP1GhDXFvumzZRlUD+ooLr+JUrUZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548644; c=relaxed/simple;
	bh=1TMyFn1WBlPMIjgzSHb3G3p576sL4UOM8o+iGF6uVLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTYEvI57qPoPM6TV4N0Q2jlYcpItt0Pu3lThoZ6wGQZfLRVeVF5jVaelb2RTK/ZuLMssPOtHkWxXgXLrOoIigk5JzLth2UfDlIV0Py7VYPKQSQPrvYWSu4Zb0DK5039PYVlxdsel8Oige6Z0+ZwJFC4rKKetXlzWueUA9uqbSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6+Qufjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6+Qufjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C8DC433F1;
	Mon, 29 Jan 2024 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548644;
	bh=1TMyFn1WBlPMIjgzSHb3G3p576sL4UOM8o+iGF6uVLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6+Qufjz4zFlIYFpBxNdWtweYsVxZaW+AhsD1mbASbDdTsGjGW2DANlwoViSM0P15
	 M6wMfpJWittYnkxwzkIQsRmQDglBHXK9wm3d2WJc0fUMcQSAJeoOUC9XCzGX7KPpSs
	 pjDxI6N3sHYHy8DTDEOdyK+VhCchkhQlaN1UkP5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 321/331] spi: fix finalize message on error return
Date: Mon, 29 Jan 2024 09:06:25 -0800
Message-ID: <20240129170024.272557504@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
index 399e81d37b3b..1e08cd571d21 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1624,6 +1624,10 @@ static int __spi_pump_transfer_message(struct spi_controller *ctlr,
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



