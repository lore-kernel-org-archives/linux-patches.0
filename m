Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9569C1DDCE;
	Tue, 16 Jul 2024 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145115; cv=none; b=qRlFgqiSbboJYIt4rui2KWJFYESA4PfaTOPbCuUVU9YUO2z8P80HhxlvVz6FHUAQ7SgD+FL/sgV9WV+Fc90Q9gtcJTslfdFcdaEGvrHUNGNKTLQ42J6SyU6vXBh+bS7PDRAcJRwPFMsLuxObPx/2ZVyU7l3m1s3cjaz307sR4sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145115; c=relaxed/simple;
	bh=RO8J4ue8/bQ5QEh+tGJ7y3pcjiWP183L8cTKmh/7R4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUkos3gNTDWoDM6qG1GhnqovbneMDqqn43Q4HHneEe5U5Pep8ycbwtSanUcZ7Ib7Jw5QJNcRc28jBdH3enaHLHg/87fppZc7I92HF2h8a58skVpUkR3X64SMdfXlmykoV1XC4MLqtrqS1XeH/W3VayGRhC0uvLSMGPXYCb5fY6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19ayUo8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19ayUo8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC0CC4AF0D;
	Tue, 16 Jul 2024 15:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145115;
	bh=RO8J4ue8/bQ5QEh+tGJ7y3pcjiWP183L8cTKmh/7R4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19ayUo8g8RoZWC10ybK/wkKCPqWH5IPX2GxxZonVCq1bnMIT4Nc+CeM6KY5zt9Ktr
	 xlZBLjesfmse+XIqyHNRWAchM8MgGqw9yepbpbklHcKC4i9R/i6wFrowtxV0ixHs0N
	 GpM4WhQ35+Y74IbWnyPrxP4P5KWX3s5JjqhygWX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jacky Huang <ychuang3@nuvoton.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.9 104/143] tty: serial: ma35d1: Add a NULL check for of_node
Date: Tue, 16 Jul 2024 17:31:40 +0200
Message-ID: <20240716152759.979088526@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

From: Jacky Huang <ychuang3@nuvoton.com>

commit acd09ac253b5de8fd79fc61a482ee19154914c7a upstream.

The pdev->dev.of_node can be NULL if the "serial" node is absent.
Add a NULL check to return an error in such cases.

Fixes: 930cbf92db01 ("tty: serial: Add Nuvoton ma35d1 serial driver support")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/8df7ce45-fd58-4235-88f7-43fe7cd67e8f@moroto.mountain/
Signed-off-by: Jacky Huang <ychuang3@nuvoton.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240625064128.127-1-ychuang570808@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/ma35d1_serial.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/ma35d1_serial.c
+++ b/drivers/tty/serial/ma35d1_serial.c
@@ -688,12 +688,13 @@ static int ma35d1serial_probe(struct pla
 	struct uart_ma35d1_port *up;
 	int ret = 0;
 
-	if (pdev->dev.of_node) {
-		ret = of_alias_get_id(pdev->dev.of_node, "serial");
-		if (ret < 0) {
-			dev_err(&pdev->dev, "failed to get alias/pdev id, errno %d\n", ret);
-			return ret;
-		}
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	ret = of_alias_get_id(pdev->dev.of_node, "serial");
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to get alias/pdev id, errno %d\n", ret);
+		return ret;
 	}
 	up = &ma35d1serial_ports[ret];
 	up->port.line = ret;


