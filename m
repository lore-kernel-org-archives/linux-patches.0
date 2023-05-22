Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22EB171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418DCC433EF;
	Mon, 22 May 2023 19:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783561;
	bh=4P211YT8/0M0fmViOACoSJ0/RAqxd5CBjxbTUNuJyJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdV31JYhtKEbWSlyDiKLhsSTQMLN6ac+fnhCQVbshZeE+fswIDrMYWYlnxiJUiKwM
	 0KyKKetpCqgxubw10q89DL1vmzlIpTOKOFBI0sLuSBQjxhMO7AXTndlf5LPxh5TLV6
	 rlUb793jp/MZnfIK2Q/FYctPcDzn+/h8ym/UXJP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/292] ACPI: EC: Fix oops when removing custom query handlers
Date: Mon, 22 May 2023 20:06:55 +0100
Message-Id: <20230522190407.392381804@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit e5b492c6bb900fcf9722e05f4a10924410e170c1 ]

When removing custom query handlers, the handler might still
be used inside the EC query workqueue, causing a kernel oops
if the module holding the callback function was already unloaded.

Fix this by flushing the EC query workqueue when removing
custom query handlers.

Tested on a Acer Travelmate 4002WLMi

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 9751b84c1b221..ee4c812c8f6cc 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1121,6 +1121,7 @@ static void acpi_ec_remove_query_handlers(struct acpi_ec *ec,
 void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
 {
 	acpi_ec_remove_query_handlers(ec, false, query_bit);
+	flush_workqueue(ec_query_wq);
 }
 EXPORT_SYMBOL_GPL(acpi_ec_remove_query_handler);
 
-- 
2.39.2



