Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E3E1C1F0F;
	Wed, 19 Mar 2025 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394918; cv=none; b=BwJetQSaCUUgq8JVUJ/4eLq1oJfNSVd4OgjVpG6bZ5kuAoG1QwZ9nAkiw/V+lq5dU7j3TAWDBO3LBU+AlVnVXDHljxK3hDAvQG9vaV5LPZGYI6DqE56rfBJa8pDGZtRGHIyGjca1BtX4pbZAD9scVliURcKj2/qGOL9MU5ktoVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394918; c=relaxed/simple;
	bh=AgoBRlxZlA0XrjrlNS6TJRLTpyEcrnLDZ+GyEMED8TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsRsAiUIPpaiIbLMjDP/z2wgUxOifUrfnk3rLpsEns1yo8y++TelvNkchgAFalKK99Aw7Yr4aRGSjqVVClhlHvhr9Qu75//GxfaGTrbj31JhW0/l6DHwFWMCi9ib+fzLcb8HHHtnGn+1fIR2YShybkvnS4Pm99AQVd83ZhC6lxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVzrTtIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVzrTtIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CDAC4CEE4;
	Wed, 19 Mar 2025 14:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394918;
	bh=AgoBRlxZlA0XrjrlNS6TJRLTpyEcrnLDZ+GyEMED8TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVzrTtIj+3QhS0V+cDWU2IsZKUHhSFpegQ51HzWvnmjsSKonH7vWXZMc7uY8UlpYy
	 8jx0wwlXbEqGs9+Cr6xhLAGUcAG0GbZNa15CSVSb2xbi89MC9wcnmpZd59V/tvH8PU
	 ixXFH5MmL1WTaXZlWLFFpNJaARZIF9Cf2s9TkIxA=
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
Subject: [PATCH 6.13 127/241] apple-nvme: Release power domains when probe fails
Date: Wed, 19 Mar 2025 07:29:57 -0700
Message-ID: <20250319143030.867111764@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 4319ab50c10d1..0bca33dc48cc9 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1518,6 +1518,7 @@ static struct apple_nvme *apple_nvme_alloc(struct platform_device *pdev)
 
 	return anv;
 put_dev:
+	apple_nvme_detach_genpd(anv);
 	put_device(anv->dev);
 	return ERR_PTR(ret);
 }
@@ -1551,6 +1552,7 @@ static int apple_nvme_probe(struct platform_device *pdev)
 	nvme_uninit_ctrl(&anv->ctrl);
 out_put_ctrl:
 	nvme_put_ctrl(&anv->ctrl);
+	apple_nvme_detach_genpd(anv);
 	return ret;
 }
 
-- 
2.39.5



