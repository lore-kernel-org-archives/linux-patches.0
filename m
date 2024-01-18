Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7DE1774B;
	Thu, 18 Jan 2024 10:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575435; cv=none; b=nbtvLV9ix8dq4g2nKL0XLbNZriFzMuRvyHiyE/qx8ndp2trbv4eH+pgXk8NI+wQ6M7bnqPZ500xbFgEtwcub/JVo8mFr00iB888XCNYhfIChF16WXK+5loMi6UU5Z9x+X1sMAM9NcOXo0wBcMRemidSKIF2lsrR+LKbws8j4Xro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575435; c=relaxed/simple;
	bh=RhPASSHBm6bRpuVvXmhACdhCWczqKTXKoHpn4af1jiU=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=s1UbazbbCjd0R5L0NAF+CUN4F7Zn2ZeW45rKjVXKrNGr5YgQUtTH+fIW4W28m9t1riFIpZ9Jxhsn5ZiP8N5pFc1CIJzeKGARukf9XgbiZhNbbofWJxd0dqr5LrCZX9ehXAbk2G/XotOBRgsFO1GfTDIs3ZGKfdL+NJ7yvJKApU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYmlzRsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYmlzRsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0490BC433C7;
	Thu, 18 Jan 2024 10:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575435;
	bh=RhPASSHBm6bRpuVvXmhACdhCWczqKTXKoHpn4af1jiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYmlzRswix2eKovhX0xMR6XoU9XCrnnoPr1zQGr2BocfM8E1rRT7zdLaanZdNNLOC
	 lxexrHCjbu8ASWUd56O9dMsATmu3EqqeeYYRR8D3Sws9NSRXY33CcKWO62V9BoKoha
	 FRLQSmk6v4G+s4tdhR+Lia+aKAOt86GCgo9EHTCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.6 132/150] bus: moxtet: Mark the irq as shared
Date: Thu, 18 Jan 2024 11:49:14 +0100
Message-ID: <20240118104326.164425257@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjoerd Simons <sjoerd@collabora.com>

commit e7830f5a83e96d8cb8efc0412902a03008f8fbe3 upstream.

The Turris Mox shares the moxtet IRQ with various devices on the board,
so mark the IRQ as shared in the driver as well.

Without this loading the module will fail with:
  genirq: Flags mismatch irq 40. 00002002 (moxtet) vs. 00002080 (mcp7940x)

Signed-off-by: Sjoerd Simons <sjoerd@collabora.com>
Cc:  <stable@vger.kernel.org> # v6.2+
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/moxtet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/moxtet.c
+++ b/drivers/bus/moxtet.c
@@ -755,7 +755,7 @@ static int moxtet_irq_setup(struct moxte
 	moxtet->irq.masked = ~0;
 
 	ret = request_threaded_irq(moxtet->dev_irq, NULL, moxtet_irq_thread_fn,
-				   IRQF_ONESHOT, "moxtet", moxtet);
+				   IRQF_SHARED | IRQF_ONESHOT, "moxtet", moxtet);
 	if (ret < 0)
 		goto err_free;
 


