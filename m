Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E904226CFE;
	Mon, 13 Oct 2025 14:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367195; cv=none; b=MZ3bP+xKedJICLlh3l7gf3OaKKHvuLboJS46/qmTywEMSQpUxTsTeMHaCk/+GX2cuLF8e/KWpBAV1t39Edt8R96rpUq0TN4iMBjyxZjMmFGLnHR1WklNpYj0/yGDlGeKeCvzpr98HSfARGY2kskqMO2zvOpMlVLHR7VU+Ez0bEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367195; c=relaxed/simple;
	bh=0Kr8/VEq7Ts61TeSjkqzdNMncoIhNA0IXS7Xx4BDsMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvxLVlmFw5s5EvgleF2+26kkHNsY7OzWob0Lx+HUegsfX6iEYZQGpWkDlSPHYANkA7hhsWcV1ZWNyklUHNdnjOQt7V2XGw4iF/pjxNDC1jPZnmJqOfwxOuRqcpk0UDQqWR1BcGFNMR7fiIBukTR/ZhM8s9rcWJ1oEobXjezJenQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rjwafhl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rjwafhl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89CFC4CEE7;
	Mon, 13 Oct 2025 14:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367195;
	bh=0Kr8/VEq7Ts61TeSjkqzdNMncoIhNA0IXS7Xx4BDsMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rjwafhl3NFxi1Z/aTByoajKY2yaF0QM4BDvVtWLhOJCC3s4CvL5Gc/rB/b91m5Ugu
	 S9WBEDxtHJIFU0nIFNFLDOZQeIgqRTcxZim9DVa8qSYMGRzU63WUmD0aHuAqubrqDf
	 Yy7UzA2fbE9HCccTtnfcT9MFkNolVy5QmRv2F38Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/196] usb: host: max3421-hcd: Fix error pointer dereference in probe cleanup
Date: Mon, 13 Oct 2025 16:44:25 +0200
Message-ID: <20251013144318.028852569@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 186e8f2bdba551f3ae23396caccd452d985c23e3 ]

The kthread_run() function returns error pointers so the
max3421_hcd->spi_thread pointer can be either error pointers or NULL.
Check for both before dereferencing it.

Fixes: 05dfa5c9bc37 ("usb: host: max3421-hcd: fix "spi_rd8" uses dynamic stack allocation warning")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/aJTMVAPtRe5H6jug@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 8aaafba058aa9..f170741206e1d 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1925,7 +1925,7 @@ max3421_probe(struct spi_device *spi)
 	if (hcd) {
 		kfree(max3421_hcd->tx);
 		kfree(max3421_hcd->rx);
-		if (max3421_hcd->spi_thread)
+		if (!IS_ERR_OR_NULL(max3421_hcd->spi_thread))
 			kthread_stop(max3421_hcd->spi_thread);
 		usb_put_hcd(hcd);
 	}
-- 
2.51.0



