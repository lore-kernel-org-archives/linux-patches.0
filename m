Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81222263F3B;
	Tue,  8 Apr 2025 12:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114837; cv=none; b=R5HlQksegmeSD7D5quCGuAN60PUz2z6GJeG2SUF2wSh2Ej6FPMahk17XHtjZfbG3pVcmg5cihb0Q4cY/KDp9EGHjDs5LIx9zN4rId1B4IKf7/ZpKspuOwfnrjIhB99ZVQ88NJzUB82M0VIWBfxfS4I0FiaDpU2D+87OHQp1ejjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114837; c=relaxed/simple;
	bh=0mUabeJ/7xY5tsswYyMXnMUw+L0ZOzi2zY2Toyr7wrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZT6l3oP0+8GrLzuYG5yJKsPzZQOOWdr5w8/Ta709qBs/XuYYe59mofTBAkdm0ZfGIBB48qR+pCO58nuBN6x4Tb53bxt9nlcKNWwQDl/LVxemb6h+EvOzBPTx/vKWRxLKDGp0IvF4PpIK3dzA3v+HgYeKZjItISCZrnoS4YZ3hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCqKiTQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCqKiTQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48EFC4CEE5;
	Tue,  8 Apr 2025 12:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114837;
	bh=0mUabeJ/7xY5tsswYyMXnMUw+L0ZOzi2zY2Toyr7wrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCqKiTQqwhYaidpU5yp/4DQaq+4utTXLXV3QCiYf/kFUvKjQe1y/PZ4yFbybvfdiK
	 qWvodeNC6Rjillovt9xd67uqNxi4ivY3PCN5KxNKE/XtP64Cq/f23RyLw412qqV40W
	 DTWxP+hp19rmX8a3CiSJ/fYG3f1PIfzSp0k98cTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ayush Singh <ayush@beagleboard.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 213/499] greybus: gb-beagleplay: Add error handling for gb_greybus_init
Date: Tue,  8 Apr 2025 12:47:05 +0200
Message-ID: <20250408104856.520051028@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit be382372d55d65b5c7e5a523793ca5e403f8c595 ]

Add error handling for the gb_greybus_init(bg) function call
during the firmware reflash process to maintain consistency
in error handling throughout the codebase. If initialization
fails, log an error and return FW_UPLOAD_ERR_RW_ERROR.

Fixes: 0cf7befa3ea2 ("greybus: gb-beagleplay: Add firmware upload API")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Ayush Singh <ayush@beagleboard.org>
Link: https://lore.kernel.org/r/20250120140547.1460-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/greybus/gb-beagleplay.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/greybus/gb-beagleplay.c b/drivers/greybus/gb-beagleplay.c
index 473ac3f2d3821..da31f1131afca 100644
--- a/drivers/greybus/gb-beagleplay.c
+++ b/drivers/greybus/gb-beagleplay.c
@@ -912,7 +912,9 @@ static enum fw_upload_err cc1352_prepare(struct fw_upload *fw_upload,
 		cc1352_bootloader_reset(bg);
 		WRITE_ONCE(bg->flashing_mode, false);
 		msleep(200);
-		gb_greybus_init(bg);
+		if (gb_greybus_init(bg) < 0)
+			return dev_err_probe(&bg->sd->dev, FW_UPLOAD_ERR_RW_ERROR,
+					     "Failed to initialize greybus");
 		gb_beagleplay_start_svc(bg);
 		return FW_UPLOAD_ERR_FW_INVALID;
 	}
-- 
2.39.5



