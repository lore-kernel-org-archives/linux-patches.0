Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C993B3C17;
	Mon, 23 Mar 2026 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278345; cv=none; b=VzcCweGCGeIHGkOatNHerMa6pfQky//x2GONxw7XuAH0i53TX0zRrTUoTcqoe+Dg+86llqArJQtoRrktUPlGmP9R+jsHsmTBlGJpETZ1lV8hUTaWxQ6I+jF/3KzVoUwGBc69l65X844Nq34dvG/e8fsTFHeUXj5tp1m0Px3nkoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278345; c=relaxed/simple;
	bh=chsrUtodxUOSu9jn+UxD7MZTJ7O1nzncqwsfRyLMb8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QChJGBxRnzaGzNHO/aaFKCyMNN6i60JiteOucYHtxjCvchkxs047EiU/ncjAgwsaZogZzsOw6HwlwGzkO9NwUVn9KVaHXiZ9oF7EBV7qJXD+SuZKY8uR5iB1sq3iVafiXqnpDlsho2p0RQKcgweR6Mp0/GpCjazjgvlut+K0y9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJsQU8m5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJsQU8m5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E352BC4CEF7;
	Mon, 23 Mar 2026 15:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278345;
	bh=chsrUtodxUOSu9jn+UxD7MZTJ7O1nzncqwsfRyLMb8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJsQU8m57hbh7i77zmB3Xlwbmw9cLJu9fO60QY/BPrwFiHQEMl0Ly+R2WVarBSPV6
	 OLtUwPIymT9hWTP0YpqIiTSsVnnLRmN98tfslDmHX2gcZ2MBREVoKuMdvMJl/R/K/i
	 4PUsmLZJwM8nBznZbj7gtn7rrnhym4vcQXdesOpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyue Wang <haiyuewa@163.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/567] mctp: i2c: fix skb memory leak in receive path
Date: Mon, 23 Mar 2026 14:42:35 +0100
Message-ID: <20260323134539.651083941@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyue Wang <haiyuewa@163.com>

[ Upstream commit e3f5e0f22cfc2371e7471c9fd5b4da78f9df7c69 ]

When 'midev->allow_rx' is false, the newly allocated skb isn't consumed
by netif_rx(), it needs to free the skb directly.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Signed-off-by: Haiyue Wang <haiyuewa@163.com>
Link: https://patch.msgid.link/20260305143240.97592-1-haiyuewa@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index c8c2c5dc46eb7..1a7e7397ba75c 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -344,6 +344,7 @@ static int mctp_i2c_recv(struct mctp_i2c_dev *midev)
 	} else {
 		status = NET_RX_DROP;
 		spin_unlock_irqrestore(&midev->lock, flags);
+		kfree_skb(skb);
 	}
 
 	if (status == NET_RX_SUCCESS) {
-- 
2.51.0



