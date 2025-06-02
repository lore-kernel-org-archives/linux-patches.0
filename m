Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6832248B3;
	Mon,  2 Jun 2025 14:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872944; cv=none; b=EKTq4ML34IONOcIAKC08a4UCPbJsIoQivxJxeqtb7zgUoSp+wwCPo4CDWJ/FK1XrT5tvFdZ4F3lx2HJ68A7CnNMrELyjzd3yG3FEsa0iuVVzTc0KNaepbY0W/VeBCuK7pYlXqsmmq+2RAeLgr5CNuR7A97WPfkxUzMKtkBN0lJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872944; c=relaxed/simple;
	bh=d7elWOw1LXkDbgdBq0m2EPpbNVp2vG5sYJ+XFpEXssg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AONUd8VWCt7xUvpW0XnwLOW9J57mEyAcmLg33fNyOR5aAs7XElK3oh+YK6PBxbyPp40l443cMq/hw9Scwr7lpqHaNtDGMnM+dkPmgn7b/TQCrmClAYuoHN3xGS3K9q1L5j/v3r/sx/+xVFEz0T+/piyES3j8oyezFz+qbZMw4fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcD8jXvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcD8jXvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0165EC4CEEE;
	Mon,  2 Jun 2025 14:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872944;
	bh=d7elWOw1LXkDbgdBq0m2EPpbNVp2vG5sYJ+XFpEXssg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcD8jXvSec8ELIBIH33K3gySp65FhSpE3e8WoBUSnJ0dXh02bp/3c+nJlMtE9WIYy
	 fsUChQ/kG/Ue2Lyg6PpjN78/GTjVOuo3wEoCQnBw6hbx1DJxFuBoc83fcJYqYcIjVV
	 sDvZSRmGjOnBp08ZMNDHgVKRUd0zibEppFOyZCs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Grassi <alessandro.grassi@mailbox.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 45/55] spi: spi-sun4i: fix early activation
Date: Mon,  2 Jun 2025 15:48:02 +0200
Message-ID: <20250602134240.055385114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Grassi <alessandro.grassi@mailbox.org>

[ Upstream commit fb98bd0a13de2c9d96cb5c00c81b5ca118ac9d71 ]

The SPI interface is activated before the CPOL setting is applied. In
that moment, the clock idles high and CS goes low. After a short delay,
CPOL and other settings are applied, which may cause the clock to change
state and idle low. This transition is not part of a clock cycle, and it
can confuse the receiving device.

To prevent this unexpected transition, activate the interface while CPOL
and the other settings are being applied.

Signed-off-by: Alessandro Grassi <alessandro.grassi@mailbox.org>
Link: https://patch.msgid.link/20250502095520.13825-1-alessandro.grassi@mailbox.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sun4i.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sun4i.c b/drivers/spi/spi-sun4i.c
index 2ee6755b43f54..3019f57e65841 100644
--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -264,6 +264,9 @@ static int sun4i_spi_transfer_one(struct spi_controller *host,
 	else
 		reg |= SUN4I_CTL_DHB;
 
+	/* Now that the settings are correct, enable the interface */
+	reg |= SUN4I_CTL_ENABLE;
+
 	sun4i_spi_write(sspi, SUN4I_CTL_REG, reg);
 
 	/* Ensure that we have a parent clock fast enough */
@@ -404,7 +407,7 @@ static int sun4i_spi_runtime_resume(struct device *dev)
 	}
 
 	sun4i_spi_write(sspi, SUN4I_CTL_REG,
-			SUN4I_CTL_ENABLE | SUN4I_CTL_MASTER | SUN4I_CTL_TP);
+			SUN4I_CTL_MASTER | SUN4I_CTL_TP);
 
 	return 0;
 
-- 
2.39.5



