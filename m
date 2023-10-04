Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B441D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82E2C433C7;
	Wed,  4 Oct 2023 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443253;
	bh=JQN0ZMM7fJEBDs8zFvKhxOogVV9OW9IxjgV75q4nQNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENACl3opfnxo2L2ggT/AGXa3qFNLPedQ0Pjw4f1vaGnG3vA3G76Ge/tB3pTaAZo/H
	 qpJpL7Kejl0QYM6uyO5zrmmgWZBVMGbdrOjq57K6MYVGWHhYHr79tt/JNHsT5HXIId
	 h7H1ws2fxz4kHFdl4cE0lYRQZhzOgnioZBYvk17o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/259] i2c: mux: gpio: Add missing fwnode_handle_put()
Date: Wed,  4 Oct 2023 19:54:23 +0200
Message-ID: <20231004175221.488627758@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang He <windhl@126.com>

[ Upstream commit db6aee6083a56ac4a6cd1b08fff7938072bcd0a3 ]

In i2c_mux_gpio_probe_fw(), we should add fwnode_handle_put()
when break out of the iteration device_for_each_child_node()
as it will automatically increase and decrease the refcounter.

Fixes: 98b2b712bc85 ("i2c: i2c-mux-gpio: Enable this driver in ACPI land")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-mux-gpio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index 73a23e117ebec..0930a51c8c7c0 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -105,8 +105,10 @@ static int i2c_mux_gpio_probe_fw(struct gpiomux *mux,
 
 		} else if (is_acpi_node(child)) {
 			rc = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), values + i);
-			if (rc)
+			if (rc) {
+				fwnode_handle_put(child);
 				return dev_err_probe(dev, rc, "Cannot get address\n");
+			}
 		}
 
 		i++;
-- 
2.40.1



