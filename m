Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888F41D04BA;
	Wed,  2 Oct 2024 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878528; cv=none; b=bS9EOIiLCqGfF6eW2iPHgxa7HWJa1MaFOyXKw+z0eE/0VZajaIY2tW7GOIDHHueU2sVqNuJMgPfDfHo72seAmgySodGszSvDgykJDStozcAnIi6hDI/Kfco8/KmEHNSpO13w1prfdUQKB21TQ2nKRTEYfcAPV2FeAjZVto8I6c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878528; c=relaxed/simple;
	bh=qrSo5eRSnEQ4iJdUFNcXBkPNDUWa2OFqaJsPGRbCSBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpLnNVfFilsRmgqEwN5xK+W/+Pknc2dY3CNFLqV8mBdLaZd0DWy+5zkQH2igbegbWTnV81deQwwrt8vdZx4AEfDt6cl96HaFKeBhVpYL8kFswbFUa2iwUvl3cysuZkeuBBPdkYwGKmbzg3JNR4vYuoVKEQbtq10J4LrwLDPzjCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiyXhU+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiyXhU+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1434BC4CEC2;
	Wed,  2 Oct 2024 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878528;
	bh=qrSo5eRSnEQ4iJdUFNcXBkPNDUWa2OFqaJsPGRbCSBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DiyXhU+eOGZFh/V6NFcdlEiGmBZhmoXB3o/zvvH7K8Urrk0aqx17KtIo5eDKiUlfS
	 /grJULHpdDhE6YwIJfk7dgFE++RHbJ0qaNe+2xCf4vsdg2acEQGcJntUbsNLSdU74n
	 ka41SYxExi2sB1ZSgNFTvR2tbFIa012DvAY4eb88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 437/634] net: seeq: Fix use after free vulnerability in ether3 Driver Due to Race Condition
Date: Wed,  2 Oct 2024 14:58:57 +0200
Message-ID: <20241002125828.350879496@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaixin Wang <kxwang23@m.fudan.edu.cn>

[ Upstream commit b5109b60ee4fcb2f2bb24f589575e10cc5283ad4 ]

In the ether3_probe function, a timer is initialized with a callback
function ether3_ledoff, bound to &prev(dev)->timer. Once the timer is
started, there is a risk of a race condition if the module or device
is removed, triggering the ether3_remove function to perform cleanup.
The sequence of operations that may lead to a UAF bug is as follows:

CPU0                                    CPU1

                      |  ether3_ledoff
ether3_remove         |
  free_netdev(dev);   |
  put_devic           |
  kfree(dev);         |
 |  ether3_outw(priv(dev)->regs.config2 |= CFG2_CTRLO, REG_CONFIG2);
                      | // use dev

Fix it by ensuring that the timer is canceled before proceeding with
the cleanup in ether3_remove.

Fixes: 6fd9c53f7186 ("net: seeq: Convert timers to use timer_setup()")
Signed-off-by: Kaixin Wang <kxwang23@m.fudan.edu.cn>
Link: https://patch.msgid.link/20240915144045.451-1-kxwang23@m.fudan.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/seeq/ether3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq/ether3.c
index c672f92d65e97..9319a2675e7b6 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -847,9 +847,11 @@ static void ether3_remove(struct expansion_card *ec)
 {
 	struct net_device *dev = ecard_get_drvdata(ec);
 
+	ether3_outw(priv(dev)->regs.config2 |= CFG2_CTRLO, REG_CONFIG2);
 	ecard_set_drvdata(ec, NULL);
 
 	unregister_netdev(dev);
+	del_timer_sync(&priv(dev)->timer);
 	free_netdev(dev);
 	ecard_release_resources(ec);
 }
-- 
2.43.0



