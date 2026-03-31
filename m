Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5465E421EF4;
	Tue, 31 Mar 2026 16:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974786; cv=none; b=fGzeSwQOEmHb9C5xFhMl++bhSuajfpLFbwlDtTrx/RmpyElybqJLK/QUbNwDZLSnPL4AwEBd8GOgAjiud9Avu/7e5ZZlaQ1UYrfRG+HOYhJnqgH6CkmQ7P9+aVHvm4yTnXksW05lkCrTtlkSqnS5EBs/S/QAAyinwF2vBn6dtCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974786; c=relaxed/simple;
	bh=1lESme6jGAnUARuKeAtnT5V78OyugRa3K5swsKZjlXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjTtOBtTaqamulwEl3RDCC4vgchsy7+f/PMhoUS/cEXw5WZ0NbH6Bc33gSwXL2NbqvcSbHLq/B9o9XmOz3nL3873iPZXUdUUeaPNK6VItqn84ojrH5x3sw8nyPQtKR98jWgIzI2T/n1y3EPxeNinERAlccRFMqIig/jbheikChQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ci9jWEo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ci9jWEo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA78C19423;
	Tue, 31 Mar 2026 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974786;
	bh=1lESme6jGAnUARuKeAtnT5V78OyugRa3K5swsKZjlXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ci9jWEo1H6l6BcgnLzXtX9dNel3RHfh2g3HFnMf89kcn9yvLts++I76NQuMEAq/UE
	 ecRLILx9gslAqovtExCJjxsZA0UAGBLBvorZgqAjrrB/Km/OgTmzxLwVJ+eOPz/I1o
	 bfesA7xxW+Cp9EmSraDnHWRZUTiF5EtYB6sTMISA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Sioen <romain.sioen@microchip.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 043/342] HID: mcp2221: cancel last I2C command on read error
Date: Tue, 31 Mar 2026 18:17:56 +0200
Message-ID: <20260331161800.486458821@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 33603b019f975..ef3b5c77c38e3 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -353,6 +353,8 @@ static int mcp_i2c_smbus_read(struct mcp2221 *mcp,
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



