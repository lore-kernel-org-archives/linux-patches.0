Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB3244C7C;
	Mon,  6 Jan 2025 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178129; cv=none; b=kjfOqTtKL8a7LPrIfC/nTWo5sk7wEZKP93uXNMeUebNqOvI0SLb7YGvIN523r0jzjDRaepXqU45IrB2cCXCyVmxJTMCEhapFPM6couTlsOcx00vIs5y1Zn0cmsgWW1XEaPfRn4uMGwnKEIkdFzGx4sFOPnH0+hbKX0WH5rxCBBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178129; c=relaxed/simple;
	bh=+72KK3Utb6aG5nJ5YMpE5XEhMupheB1cNpKm2/UKj8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvsS5n83aUIdqj7oLlatZEM+FHa7eEp1hCrtovbuSJuNZUboqwcoblLWlZZGLhXxk1XtmHua882kxu+RqtmLpY6ezE+1cc5+dfye8fiUhXJR4JdjY1ETc/77EfIjSZb+8TpGmcbaYR3tMrmcE9cZROxY/UKW2+5jGsIIYHxE71c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TezrGk6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TezrGk6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35177C4CED2;
	Mon,  6 Jan 2025 15:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178129;
	bh=+72KK3Utb6aG5nJ5YMpE5XEhMupheB1cNpKm2/UKj8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TezrGk6McYxfkzCoHQ4FkIj0tDecyc6atIWXksy7i+bBDCb75xF8GuL5kJZCide23
	 zSS1qKeuJZb4H+TfOjchcY0qHIUoWaofBYMG84djczWnx3JjyTf819adBSG4BirLN7
	 +x/665kPRdQHbJgCo/YE2GYCT3DumIEjLGLI/f9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/138] netdevsim: switch to memdup_user_nul()
Date: Mon,  6 Jan 2025 16:15:39 +0100
Message-ID: <20250106151133.796385887@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 20fd4f421cf4c21ab37a8bf31db50c69f1b49355 ]

Use memdup_user_nul() helper instead of open-coding to
simplify the code.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ee76746387f6 ("netdevsim: prevent bad user input in nsim_dev_health_break_write()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/health.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index 21e2974660e7..04aebdf85747 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -235,15 +235,10 @@ static ssize_t nsim_dev_health_break_write(struct file *file,
 	char *break_msg;
 	int err;
 
-	break_msg = kmalloc(count + 1, GFP_KERNEL);
-	if (!break_msg)
-		return -ENOMEM;
+	break_msg = memdup_user_nul(data, count);
+	if (IS_ERR(break_msg))
+		return PTR_ERR(break_msg);
 
-	if (copy_from_user(break_msg, data, count)) {
-		err = -EFAULT;
-		goto out;
-	}
-	break_msg[count] = '\0';
 	if (break_msg[count - 1] == '\n')
 		break_msg[count - 1] = '\0';
 
-- 
2.39.5



