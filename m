Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028E21F76C4;
	Tue, 17 Dec 2024 17:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455638; cv=none; b=tnohuGQYIcdPVV+hJI7MTVMrjsmZSluBmT/Sbkct6zeA1G3RmYjf0igbSd94JLBV7BylKc0I//hnyzDPy7e4Ia/FFMAZ9C4Jd+mUDgp4kigwaXQr/Vo5pEpB4QDCCkw5D7R1Sm92N+QnsCGG3zSGnAnWLBRAdvPfHAHPwNf12Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455638; c=relaxed/simple;
	bh=AMd7FrWCFkfOFliIx87HGzSgvPLosATbTrY1UUJFTu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WupexQ3t0SoBawhdbVApuZSsEfABvPf/EpQei1brbqqwrSvKgV+rFVsNvpTJlWb7NTtXHq9q0LHm7fhMwUCcLi1GvTn0hIGhkoi4dMqDu3WegvY6s+hjbydkiLk2RFPcR+1XcgsJQiZ+Ol4m8nibyumVkFjHg45aR3XJX/ZJKpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4RR0x1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4RR0x1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AD6C4CED3;
	Tue, 17 Dec 2024 17:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455637;
	bh=AMd7FrWCFkfOFliIx87HGzSgvPLosATbTrY1UUJFTu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4RR0x1HKnKGIJqRgJXW03IVYtO0y/XFO8CAHU7THRKnUi6ZWsxVHYf90XjjUjvc+
	 KUmWRbSodNZMtB+y9HPk4oAM5YIabmduMJOPilP97P5sznzTZFnhWXObnoDim+qxKO
	 H7xw6/qd2ylJ5J/UVQqDnknVk+s2aSZMIFNos/qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/51] qca_spi: Make driver probing reliable
Date: Tue, 17 Dec 2024 18:07:26 +0100
Message-ID: <20241217170521.641267386@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit becc6399ce3b724cffe9ccb7ef0bff440bb1b62b ]

The module parameter qcaspi_pluggable controls if QCA7000 signature
should be checked at driver probe (current default) or not. Unfortunately
this could fail in case the chip is temporary in reset, which isn't under
total control by the Linux host. So disable this check per default
in order to avoid unexpected probe failures.

Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://patch.msgid.link/20241206184643.123399-3-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/qca_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 926eec0a9532..9b34ab547840 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -67,7 +67,7 @@ MODULE_PARM_DESC(qcaspi_burst_len, "Number of data bytes per burst. Use 1-5000."
 
 #define QCASPI_PLUGGABLE_MIN 0
 #define QCASPI_PLUGGABLE_MAX 1
-static int qcaspi_pluggable = QCASPI_PLUGGABLE_MIN;
+static int qcaspi_pluggable = QCASPI_PLUGGABLE_MAX;
 module_param(qcaspi_pluggable, int, 0);
 MODULE_PARM_DESC(qcaspi_pluggable, "Pluggable SPI connection (yes/no).");
 
-- 
2.39.5



