Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7A56FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C938C433EF;
	Mon, 16 Jan 2023 17:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888439;
	bh=mamFaROccbxzfggnQvtKuCa2of1T6DSmDeP2qJfKog4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXvmuE0OS3S5kJoDqOzIBL4Vx39vK0oEhpMMU/HZH+cb4DxdyFgR6gYr6cs6GiPTi
	 XEnbVVtqP+Mzf51nET2YDKkKUDQD+avXvJ97kF37nFBM5XP9GhT2yFwyUnWpHQQNxd
	 Ghyqb1DMjpyxx2A2F+WiwAnYf2f2mgq3pRd1ubfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 4.19 521/521] serial: tegra: Only print FIFO error message when an error occurs
Date: Mon, 16 Jan 2023 16:53:03 +0100
Message-Id: <20230116154910.496588142@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jon Hunter <jonathanh@nvidia.com>

commit cc9ca4d95846cbbece48d9cd385550f8fba6a3c1 upstream.

The Tegra serial driver always prints an error message when enabling the
FIFO for devices that have support for checking the FIFO enable status.
Fix this by displaying the error message, only when an error occurs.

Finally, update the error message to make it clear that enabling the
FIFO failed and display the error code.

Fixes: 222dcdff3405 ("serial: tegra: check for FIFO mode enabled status")
Cc: <stable@vger.kernel.org>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20210630125643.264264-1-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -991,9 +991,11 @@ static int tegra_uart_hw_init(struct teg
 
 	if (tup->cdata->fifo_mode_enable_status) {
 		ret = tegra_uart_wait_fifo_mode_enabled(tup);
-		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
-		if (ret < 0)
+		if (ret < 0) {
+			dev_err(tup->uport.dev,
+				"Failed to enable FIFO mode: %d\n", ret);
 			return ret;
+		}
 	} else {
 		/*
 		 * For all tegra devices (up to t210), there is a hardware


