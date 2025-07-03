Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F422D23A8;
	Thu,  3 Jul 2025 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554838; cv=none; b=JTLgWaYaoFO3OlUtUItXM0SyvvRHzgmad6kjGqJgp9c9viYfIcoBUMZNl9tMfeLOB2yuhJSlhIKaVuZhamzCoJcMVLUVgcsIfTvZrBYi/T2xst0PtdxeNL5mv9hw+/mVztjm61EKE+pDDAMIMesbctoPbaDaM7Y9pvuctjsPbyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554838; c=relaxed/simple;
	bh=getv5wjWe5J1m00DQ2OKezrdaL1DCW1revHFu+yP3ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHRpH+f4Q0eYfilBZvgSSLHirhN0EXDkJw7ZH9tdOeo1QWc1gFPM3zxqSI3vVCTmpO/jhqfoDQPEMnzTAHXa5sT75/tGCc/6Hgb9eGxh7BESWCC3579IlWn8TUqu4poG7QxiqwNvrtzG1dJs4sVSMjr+dKNkS++vlFC1lK29hoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plAJX6ct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plAJX6ct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC40CC4CEE3;
	Thu,  3 Jul 2025 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554838;
	bh=getv5wjWe5J1m00DQ2OKezrdaL1DCW1revHFu+yP3ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plAJX6ct8GgoE6GO4BXI7ZL7yaiTq90ghc3Q2Mx7h2CLsSaTOmZvjeYNL1yojtv4g
	 cXNdWQTY+w3NTi1AhRALAGh46u3nJccln8lEJNzb32bX04E23ZF1l376lL/1qg3V/h
	 FPZrOmS1rx7nFJZPQI0KpjmvJDa4jHs+d63w2vfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 064/263] usb: typec: tcpci: Fix wakeup source leaks on device unbind
Date: Thu,  3 Jul 2025 16:39:44 +0200
Message-ID: <20250703144006.871702304@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 9fc5986fbcd7e1e63afb04be94cd4e8a536a4b04 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250406204051.63446-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci_maxim_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpci_maxim_core.c b/drivers/usb/typec/tcpm/tcpci_maxim_core.c
index 648311f5e3cf1..b5a5ed40faea9 100644
--- a/drivers/usb/typec/tcpm/tcpci_maxim_core.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim_core.c
@@ -537,7 +537,10 @@ static int max_tcpci_probe(struct i2c_client *client)
 		return dev_err_probe(&client->dev, ret,
 				     "IRQ initialization failed\n");
 
-	device_init_wakeup(chip->dev, true);
+	ret = devm_device_init_wakeup(chip->dev);
+	if (ret)
+		return dev_err_probe(chip->dev, ret, "Failed to init wakeup\n");
+
 	return 0;
 }
 
-- 
2.39.5



