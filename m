Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D9E1F8AD4;
	Tue, 17 Dec 2024 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456713; cv=none; b=t0HELCe8O3Md5HbtpqeGeVwpqQw+B/LWK0iIXeksaTOGCqKtsdAtR6tGpMNGVeroqR6ajM8OEzdEcDz3RI/ePSMielH/HfdfL6Yh5Kx/oLFjN4bOZ1ECsqUV6Jcq9a6ugOY38BmFOAcNems3A1z4P9P0gr1OAc1P053oMi8aIGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456713; c=relaxed/simple;
	bh=+YS/Fc8edvNCUuag61CWUjrEMTEYt6l57S7a4tvBLpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcZEWqD4BSwYus5l6Af7+V78Qv57eYLJyCLFBVCukse7qSvWZ+ZAEUwi0rnaC0lGTwpRNA5WUkC6csQvSNt/lnqRYBnAsD5ChhwiuwPX7vE6JgWFjpGgdLw+jUtccMKVdhM+CAlo1Fsk6/sklKKTT7n+h9YY+G2Iwwmc61EfSH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bieFW+pl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bieFW+pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB96AC4CED3;
	Tue, 17 Dec 2024 17:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456713;
	bh=+YS/Fc8edvNCUuag61CWUjrEMTEYt6l57S7a4tvBLpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bieFW+pllz0aC6P5dOBUPdrdcyQCKHefxqvOIZpU7HqAN5ey8oq73sKchDcbCm92u
	 9sI2ADMVReWOLQithUL3bC/hYCJEGiUfYr1nb83stntDYWtNnOOfTwQAScR8PCgYa3
	 UfIQeiSG0digsbp9Utf3PrB8TQlUgelotqcqzI10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/172] qca_spi: Make driver probing reliable
Date: Tue, 17 Dec 2024 18:07:51 +0100
Message-ID: <20241217170551.101438859@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a73426a8c429..6b4b40c6e1fe 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -53,7 +53,7 @@ MODULE_PARM_DESC(qcaspi_burst_len, "Number of data bytes per burst. Use 1-5000."
 
 #define QCASPI_PLUGGABLE_MIN 0
 #define QCASPI_PLUGGABLE_MAX 1
-static int qcaspi_pluggable = QCASPI_PLUGGABLE_MIN;
+static int qcaspi_pluggable = QCASPI_PLUGGABLE_MAX;
 module_param(qcaspi_pluggable, int, 0);
 MODULE_PARM_DESC(qcaspi_pluggable, "Pluggable SPI connection (yes/no).");
 
-- 
2.39.5



