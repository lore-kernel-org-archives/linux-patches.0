Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AA02206BB;
	Mon, 23 Jun 2025 21:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714138; cv=none; b=UVWpKGPDTSFNNOqQ6d+iLcffnNwaUgKATcSL/jS7v25rFHkIGdShLkU/vm71ca5bNhvzhDRRQJQ2ZgwV2/iMY7MS0FLkO4uXVW7HaZGAdjTTKpHC8KPo9mJYkYaIsN0+Z4tCcXgSQlXlY8bAk4+uNCM5Ja/rHcArEUGJUtyUc+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714138; c=relaxed/simple;
	bh=xkYvq/0vzUk9lLnTR7nvpFLO2CUPFuA5QBQPioT4fTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6cN9vGPjId92YORR34sIlDaumwPzm0AFcgjL76PlnkomgO4uIZgzOKDTUt4pOZOsf/aqw87jQYLa4lkRGjlSYURAuwL0tF38tsY0B+q9LqlUk7KcRXKiesec3VyyUruAMNRHEqa36frPp3zZGYraqAF3wLwjbE/FwQrCwm71+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZR9HEySi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZR9HEySi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56BFC4CEEA;
	Mon, 23 Jun 2025 21:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714138;
	bh=xkYvq/0vzUk9lLnTR7nvpFLO2CUPFuA5QBQPioT4fTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZR9HEySiqnfLGsR68HDvs5y3vOHKFXUHt+RNgY6oU4+VQyq7un1t2AuiHnJ9hSIth
	 I3fDMHuFWk8sHjRTCF6NrdGHNn4v8VRFylEME4Nz6VRKHZFVdu+782UKBhrZabPHjL
	 VUFWHxO35q3kfJKZtmeq5uSzrhU5bzoMocjG35iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/508] serial: Fix potential null-ptr-deref in mlb_usio_probe()
Date: Mon, 23 Jun 2025 15:03:22 +0200
Message-ID: <20250623130649.142561268@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 86bcae88c9209e334b2f8c252f4cc66beb261886 ]

devm_ioremap() can return NULL on error. Currently, mlb_usio_probe()
does not check for this case, which could result in a NULL pointer
dereference.

Add NULL check after devm_ioremap() to prevent this issue.

Fixes: ba44dc043004 ("serial: Add Milbeaut serial control")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://lore.kernel.org/r/20250403070339.64990-1-bsdhenrymartin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/milbeaut_usio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/milbeaut_usio.c b/drivers/tty/serial/milbeaut_usio.c
index c15e0d84dc7e3..c604c21e7fa33 100644
--- a/drivers/tty/serial/milbeaut_usio.c
+++ b/drivers/tty/serial/milbeaut_usio.c
@@ -524,7 +524,10 @@ static int mlb_usio_probe(struct platform_device *pdev)
 	}
 	port->membase = devm_ioremap(&pdev->dev, res->start,
 				resource_size(res));
-
+	if (!port->membase) {
+		ret = -ENOMEM;
+		goto failed;
+	}
 	ret = platform_get_irq_byname(pdev, "rx");
 	mlb_usio_irq[index][RX] = ret;
 
-- 
2.39.5



