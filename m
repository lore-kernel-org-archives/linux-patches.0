Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E11F18BC36;
	Wed, 19 Mar 2025 14:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395243; cv=none; b=n3B+DBUzDLge9wkHxFsx8bYY8HEfKQAYl6FgkADKvp/aaR/F3wGDbrw7SwZfxtkaiByi06yWCOMS6lbw8BqdDPt9a8hI5v/xGyp4MkPqW8CdH9PdzTOKQmRzsWeFxUI9MctYmkKmHm1nvWl5d284G4U1pd+daMMJ4MmQd7gYXbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395243; c=relaxed/simple;
	bh=eU6rEUojFd8dafTgWssh2WkizMsGAho8GNoS+24IBuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6MvwxxOM4m2m8LCnbPnzPLI+A7ktrpIs2kZNK7sPqABxT1mbohIjwpJdgoJjCt5Onra0P6JdGhPfUbl84emn8z3qzDUlyevF8xxre4k+umF3FZFlsoyD41N29E/erTPTbmK6rXiGn6jh8jgC9jfyjk10izNwhqykvaESi4gkgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPy6BT9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPy6BT9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8681AC4CEE8;
	Wed, 19 Mar 2025 14:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395242;
	bh=eU6rEUojFd8dafTgWssh2WkizMsGAho8GNoS+24IBuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPy6BT9i+fEI1PxlXOXB/E5GpGSwY61E+wgfh8npujD92vj8nEDYmBdz0gpWJnOko
	 IfGBzPdfHNP5x0nV6QAOntZbIOCj6GVweQOIXoWsRVX5lrw6ODRRfDJprDtyPtUdP2
	 EnJndOuV2n8xudahL59Gm80ROLjF1ncil6DoGEmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@svenpeter.dev>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/166] apple-nvme: Release power domains when probe fails
Date: Wed, 19 Mar 2025 07:30:50 -0700
Message-ID: <20250319143022.150368791@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit eefa72a15ea03fd009333aaa9f0e360b2578e434 ]

Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 396eb94376597..9b1019ee74789 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1517,6 +1517,7 @@ static struct apple_nvme *apple_nvme_alloc(struct platform_device *pdev)
 
 	return anv;
 put_dev:
+	apple_nvme_detach_genpd(anv);
 	put_device(anv->dev);
 	return ERR_PTR(ret);
 }
@@ -1545,6 +1546,7 @@ static int apple_nvme_probe(struct platform_device *pdev)
 out_uninit_ctrl:
 	nvme_uninit_ctrl(&anv->ctrl);
 	nvme_put_ctrl(&anv->ctrl);
+	apple_nvme_detach_genpd(anv);
 	return ret;
 }
 
-- 
2.39.5



