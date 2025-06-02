Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BEB22D4CE;
	Mon,  2 Jun 2025 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876881; cv=none; b=jkg6iuumHkxhaZTmPCfU+zPt868tGU3iHb1Jzy2OuTPFQCrXmxc+rbjKrV2JJHOKBcNUD/XZ/bumbzUxXlRpHZ8Sh/3mzb9kIWwW8IbAj7ej7iRHoZF6Wr3qW152mQkSAFx+p3lb2QhIRfatjQhA2tJG2AaM4PK7qsb5+C4xfW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876881; c=relaxed/simple;
	bh=PRCOsLPmR7zN2RA5qsxbLJfCxOd+2hE962vfiSMx/Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gn+UpCnnyz50SqB1FecV5y7c65v6agUWk1XujqRAaUEFntcCDMHipJjUbgRxv985D1B3lqPKNxwMYdtlBoRrmo50OvkShdZh6g4DrMQeMvGBefdG1G+uHVJOkfsldn5PBfCAZV+Eddu3C7vIOVZqkX5pwQcNxS8VYFMXB2GIJNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJMc/zpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJMc/zpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE59C4CEEB;
	Mon,  2 Jun 2025 15:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876880;
	bh=PRCOsLPmR7zN2RA5qsxbLJfCxOd+2hE962vfiSMx/Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJMc/zpdHk3uDQ9YNIyiAB7B6iEi5nHJCGVvugXQv3GGDpP1yF2AExxfzoy4MNIdo
	 TWFjttBMmtnGHuAJyB1JBcDiI89jX6aP1YXG7GolQNiXmyBvxIllC5SA/EyXuCayXF
	 fhXbwOJ9jOW5Sv4XQgG1rXiaEXJN1UYZSNEoo40s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/325] media: c8sectpfe: Call of_node_put(i2c_bus) only once in c8sectpfe_probe()
Date: Mon,  2 Jun 2025 15:46:18 +0200
Message-ID: <20250602134323.925056457@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit b773530a34df0687020520015057075f8b7b4ac4 ]

An of_node_put(i2c_bus) call was immediately used after a pointer check
for an of_find_i2c_adapter_by_node() call in this function implementation.
Thus call such a function only once instead directly before the check.

This issue was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-core.c
index 1dbb89f0ddb8c..b2a977f1ec18a 100644
--- a/drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-core.c
@@ -802,13 +802,12 @@ static int c8sectpfe_probe(struct platform_device *pdev)
 		}
 		tsin->i2c_adapter =
 			of_find_i2c_adapter_by_node(i2c_bus);
+		of_node_put(i2c_bus);
 		if (!tsin->i2c_adapter) {
 			dev_err(&pdev->dev, "No i2c adapter found\n");
-			of_node_put(i2c_bus);
 			ret = -ENODEV;
 			goto err_node_put;
 		}
-		of_node_put(i2c_bus);
 
 		tsin->rst_gpio = of_get_named_gpio(child, "reset-gpios", 0);
 
-- 
2.39.5



