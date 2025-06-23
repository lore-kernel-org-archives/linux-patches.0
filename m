Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A63347DD;
	Mon, 23 Jun 2025 13:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686124; cv=none; b=t2qCpXczTJWgT9Z059fF5HIGgr67rdASf1cu9BhQQeNMvTrFjpKMtvSuqfEyL7CxNdkv077uSfzVEN/MxfJS+UMZ1bz9bEOcNJOcfax0069N5V7jVsdGasBB6yhkFCzv/lLdigFm+vFQdMb74T/tGSsxtCYM8VZkH/uY7fkR4qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686124; c=relaxed/simple;
	bh=zX7ANpt+7iz/jJ9r8K8EfHfzZff/JgC5sS9XWV9NSo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmIcBggll65nTDEe+jzpBEUbXxtsmyL6a/N/Wci/z82hcPiKM4FGN+qDhRYVt4ocqRIDL33WqeW8+lOt3ReoXViUNoFDAx8ww0XF1qQt9nA4dMikyBPy259graJ06fg4EMTG6DX+fUG5quyK0eW/Q+PUZ0OV7UeLkefi1FBOiQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMmUBkbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMmUBkbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4536CC4CEEA;
	Mon, 23 Jun 2025 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686124;
	bh=zX7ANpt+7iz/jJ9r8K8EfHfzZff/JgC5sS9XWV9NSo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMmUBkbcNhkmLaVsIjfodmfpQrfku+GIZ9/r3T2Oe1HVk4iTZr0JRgkVwvXjJQ116
	 8vC5MzEu8Pv3f3Jui+TDxc8iBZCSU932cA6pc6nYo6GKJWaQfP1nYMFK7AlZ0m6FlC
	 ERYeWczbDDheybG39C16XBDmx/zMTxiLosCzTSnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/355] serial: Fix potential null-ptr-deref in mlb_usio_probe()
Date: Mon, 23 Jun 2025 15:04:52 +0200
Message-ID: <20250623130629.534919917@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8f2cab7f66ad3..d9f094514945b 100644
--- a/drivers/tty/serial/milbeaut_usio.c
+++ b/drivers/tty/serial/milbeaut_usio.c
@@ -523,7 +523,10 @@ static int mlb_usio_probe(struct platform_device *pdev)
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



