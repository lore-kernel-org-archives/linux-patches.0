Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A377D145347;
	Thu, 13 Jun 2024 11:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279366; cv=none; b=OecY34DyRfvrmrIHqoOjg5JT8+eRTyqt/qLrhrs3ZrYFGbgeHD4q0UpBXI7E/+zdD1e8CnaUp1/gwY5613hV451NxThpRGl6VKKzozg5voKJa2ib702FdJkjbl6Ls4kbQkXDsVJrBtnRSvzHjg2o9leCqRaZbod+A72PqnHH7rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279366; c=relaxed/simple;
	bh=8XQq7OxZHTCdkqHQmSo6/pGvrZJzPD1NPo9B02phUnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hz1ibY6HKhs4swlHn5cMoNQUIH727iOvSlZQXLYnPktccFwRL8S5q7tW0mlrMagEYF2U+TGZBXYnup3tsnowY4z4Z5S9CqP7dHasa/kDRngpEZUQDXHdW2xBPQ9/IBMgeXjhQivxS8ZP204uzAsDbAyJBHQsTaTf6Am+DM7tHGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZbwUK6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZbwUK6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE90C2BBFC;
	Thu, 13 Jun 2024 11:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279366;
	bh=8XQq7OxZHTCdkqHQmSo6/pGvrZJzPD1NPo9B02phUnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZbwUK6NGs3bvbRIJAv6UGE9jBaqB+92Fy2e+76WoURQwHoFGSvgtGXOf8/IuemE1
	 +PaknrdlOrH16Z4zZrMtRPqiDqsiFOaSBCGJhFJCuRR3uWf7sZMqLf3wALyqedDL36
	 sF6p9wSoL/pOT5A1XqgFtk8mUfpivxijleR/muZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.9 051/157] fbdev: savage: Handle err return when savagefb_check_var failed
Date: Thu, 13 Jun 2024 13:32:56 +0200
Message-ID: <20240613113229.399601045@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cai Xinchen <caixinchen1@huawei.com>

commit 6ad959b6703e2c4c5d7af03b4cfd5ff608036339 upstream.

The commit 04e5eac8f3ab("fbdev: savage: Error out if pixclock equals zero")
checks the value of pixclock to avoid divide-by-zero error. However
the function savagefb_probe doesn't handle the error return of
savagefb_check_var. When pixclock is 0, it will cause divide-by-zero error.

Fixes: 04e5eac8f3ab ("fbdev: savage: Error out if pixclock equals zero")
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/savage/savagefb_driver.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/savage/savagefb_driver.c
+++ b/drivers/video/fbdev/savage/savagefb_driver.c
@@ -2276,7 +2276,10 @@ static int savagefb_probe(struct pci_dev
 	if (info->var.xres_virtual > 0x1000)
 		info->var.xres_virtual = 0x1000;
 #endif
-	savagefb_check_var(&info->var, info);
+	err = savagefb_check_var(&info->var, info);
+	if (err)
+		goto failed;
+
 	savagefb_set_fix(info);
 
 	/*


