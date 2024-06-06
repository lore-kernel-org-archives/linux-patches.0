Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59DB198853;
	Thu,  6 Jun 2024 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683041; cv=none; b=uDISP8+lxZYaJHsNGg2KmhjqXCskacw08CA7u91g9qAgVx/ljSB3KyWDo67adXO2vw4sjhsf1FM9125yoeATR9huuQQGkKTFDE4HZ4D68VLfK966BMT8PK7D6+YY+ZKl3VNNvm3ItzEVWVIKOkx70E2Yzp7i0sS2zWPM42+uX5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683041; c=relaxed/simple;
	bh=UBWvpjzpNhhUBxwZJpwa5FQpmATKS5PxxvYXuFUzvGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZK6bY7ySlgDk7bUP9nMlAvRKbalD1BCwiDZIms2N54uQ3rZ4uJl0oy9/yQwDN/XUq6Fn25Mt3P+zXWapok0zNR0XCekNENmo4Tt7nTKPYn9qXcE6iG9TrNicXvAykkNILNy2EBMC6WH3YdhNe6nf9wzMFalB8Uursm8PE7Ej04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5IhAJY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5IhAJY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8B5C4AF07;
	Thu,  6 Jun 2024 14:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683040;
	bh=UBWvpjzpNhhUBxwZJpwa5FQpmATKS5PxxvYXuFUzvGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5IhAJY7guDLkKHUgo/XlibW44OJAYsnvHgE3xin4Vg4Inzdw8hD4rwP6E7VixkQ8
	 8sFTomjqJHLctOIAAAQatEy8ki4fLX8zXJtguqxUXjRmXO/PFXXkAWKjNTMJZYpXRm
	 ykgKfDcbPH3cIPUoFpUMmwieciNjMsLIoLbGyAF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Langstaff <stephenlangstaff1@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 233/374] net: Always descend into dsa/ folder with CONFIG_NET_DSA enabled
Date: Thu,  6 Jun 2024 16:03:32 +0200
Message-ID: <20240606131659.622418548@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit b1fa60ec252fba39130107074becd12d0b3f83ec ]

Stephen reported that he was unable to get the dsa_loop driver to get
probed, and the reason ended up being because he had CONFIG_FIXED_PHY=y
in his kernel configuration. As Masahiro explained it:

  "obj-m += dsa/" means everything under dsa/ must be modular.

  If there is a built-in object under dsa/ with CONFIG_NET_DSA=m,
  you cannot do  "obj-$(CONFIG_NET_DSA) += dsa/".

  You need to change it back to "obj-y += dsa/".

This was the case here whereby CONFIG_NET_DSA=m, and so the
obj-$(CONFIG_FIXED_PHY) += dsa_loop_bdinfo.o rule is not executed and
the DSA loop mdio_board info structure is not registered with the
kernel, and eventually the device is simply not found.

To preserve the intention of the original commit of limiting the amount
of folder descending, conditionally descend into drivers/net/dsa when
CONFIG_NET_DSA is enabled.

Fixes: 227d72063fcc ("dsa: simplify Kconfig symbols and dependencies")
Reported-by: Stephen Langstaff <stephenlangstaff1@gmail.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 7cab36f94782e..db55ffdb5792d 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -48,7 +48,9 @@ obj-$(CONFIG_MHI_NET) += mhi_net.o
 obj-$(CONFIG_ARCNET) += arcnet/
 obj-$(CONFIG_CAIF) += caif/
 obj-$(CONFIG_CAN) += can/
-obj-$(CONFIG_NET_DSA) += dsa/
+ifdef CONFIG_NET_DSA
+obj-y += dsa/
+endif
 obj-$(CONFIG_ETHERNET) += ethernet/
 obj-$(CONFIG_FDDI) += fddi/
 obj-$(CONFIG_HIPPI) += hippi/
-- 
2.43.0



