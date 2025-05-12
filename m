Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F57578F52;
	Mon, 12 May 2025 17:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071056; cv=none; b=IDz0YWRoo+fDVx3yB2vytH5dmrl3DroXAaimhQhUKhEDrmlwERr7GWi6xF4EaOuc7yQAotu0UeXmaiQaK9XSISi9YdVLxQbqD7JyuZsCST+BtIDPhYtK+faXHr+Q5by3jpIYzy1VLUqmZcZaAEn+f9wMxwRYdTIUB2GV2fr44Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071056; c=relaxed/simple;
	bh=3xX+zg97Xtih2FZZvzmCSijbbBmsdkBVBcjhwRLqkJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bb5+vM2pfvIpp2tlMyRH7I9EHctGCmROsgFdoAGxYSRNVKbd3KdxVn256AdBvW36TiGODlDOlDKYOThi6ovxWAMeFJZnbVfHquVPwx0u0WO8rvnTMyp5O3U/Uf8291Yp/cnpzqfwhP8xB5qLHxjA/lgZornva0n4To5qJTHJACc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ww5Da3UI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ww5Da3UI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4D1C4CEE7;
	Mon, 12 May 2025 17:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071055;
	bh=3xX+zg97Xtih2FZZvzmCSijbbBmsdkBVBcjhwRLqkJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ww5Da3UIqcQuVvu7qoB/H4oWoT2IpltaiZyMjeDQNHdal1N/Rauh3d6ifCNy827YZ
	 HcNKbtdgKDkjrUqc6+kwf2/GDhdMRUy66Q4vbGOGB9u5q0XQsrYTEBaELHUai0J6v9
	 8AjipaESU/TLWNcCUw5zX9+ZSZrIScrCJwv4L0RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>
Subject: [PATCH 5.15 22/54] staging: axis-fifo: Correct handling of tx_fifo_depth for size validation
Date: Mon, 12 May 2025 19:29:34 +0200
Message-ID: <20250512172016.540672966@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

commit 2ca34b508774aaa590fc3698a54204706ecca4ba upstream.

Remove erroneous subtraction of 4 from the total FIFO depth read from
device tree. The stored depth is for checking against total capacity,
not initial vacancy. This prevented writes near the FIFO's full size.

The check performed just before data transfer, which uses live reads of
the TDFV register to determine current vacancy, correctly handles the
initial Depth - 4 hardware state and subsequent FIFO fullness.

Fixes: 4a965c5f89de ("staging: add driver for Xilinx AXI-Stream FIFO v4.1 IP core")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Link: https://lore.kernel.org/r/20250419012937.674924-1-gshahrouzi@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/axis-fifo/axis-fifo.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/staging/axis-fifo/axis-fifo.c
+++ b/drivers/staging/axis-fifo/axis-fifo.c
@@ -780,9 +780,6 @@ static int axis_fifo_parse_dt(struct axi
 		goto end;
 	}
 
-	/* IP sets TDFV to fifo depth - 4 so we will do the same */
-	fifo->tx_fifo_depth -= 4;
-
 	ret = get_dts_property(fifo, "xlnx,use-rx-data", &fifo->has_rx_fifo);
 	if (ret) {
 		dev_err(fifo->dt_device, "missing xlnx,use-rx-data property\n");


