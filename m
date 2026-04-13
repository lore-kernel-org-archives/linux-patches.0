Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F22B31717C;
	Mon, 13 Apr 2026 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099186; cv=none; b=MHL+gHch8txDzya5GYB5U9Rrro7rJ3wxn8QnCn5DsNtO8bV6yeBBQLSnPTchL+6g165UGeP2QPS6xk2VUQOvD8g9h+5uIgCKJtUaMwJ3zDK8u3RgBjLjCJftcDlJQ+Iv8Y1eWYeUOY9iEtbN0xxvQGZk8QeouPIBSYWUb+tOjDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099186; c=relaxed/simple;
	bh=gaG8/XDc9C83WVC6xS46X/6afRh4nahWGnPog6uqFoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mt3GI/bDPgGiyeryX5Na+rbT2T0XFrpe/1jelUlqlGYUoeXOVv2iP9iRAzsxHmv6qJCMDb7jkCFptS4gzflNM8wISrIdoe0oVfRLGIMC/vkFA3xII1KkhiKaE58W/EaAIeq90vCB+F0P4zNSg9aYq9aYKj7PZa0VKXwCnyZ54Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIgAOZVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIgAOZVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A87C2BCB6;
	Mon, 13 Apr 2026 16:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099186;
	bh=gaG8/XDc9C83WVC6xS46X/6afRh4nahWGnPog6uqFoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIgAOZVtYAOONA3RkXWWahUQvYsCvqmZErggdV7AqX48NczQVSb0qWkNTUt+I+mpM
	 Nt5Hzsd+XKbVuYorTFodHd3WZRvkFOtMhAPBSudC9RviQDcYeH6AXhmv/SuoCW4F5E
	 7KahyPXQdC2QBQjZjm+mNgWMfgoXXKbbdRjxExNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Sioen <romain.sioen@microchip.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/491] HID: mcp2221: cancel last I2C command on read error
Date: Mon, 13 Apr 2026 17:58:07 +0200
Message-ID: <20260413155828.117045238@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Sioen <romain.sioen@microchip.com>

[ Upstream commit e31b556c0ba21f20c298aa61181b96541140b7b9 ]

When an I2C SMBus read operation fails, the MCP2221 internal state machine
may not reset correctly, causing subsequent transactions to fail.

By adding a short delay and explicitly cancelling the last command,
we ensure the device is ready for the next operation.

Fix an issue where i2cdetect was not able to detect all devices correctly
on the bus.

Signed-off-by: Romain Sioen <romain.sioen@microchip.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-mcp2221.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index 589f13ff0b606..9fb98c8e1ffb7 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -319,6 +319,8 @@ static int mcp_i2c_smbus_read(struct mcp2221 *mcp,
 				usleep_range(90, 100);
 				retries++;
 			} else {
+				usleep_range(980, 1000);
+				mcp_cancel_last_cmd(mcp);
 				return ret;
 			}
 		} else {
-- 
2.51.0



