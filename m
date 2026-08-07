Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2860B397931;
	Fri,  7 Aug 2026 14:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113953; cv=none; b=K9Iq2njOmaXatJwAfF5jbMT11Xe5J5xiaQbZVbnqooTAhM8L06DTU1EVZeCEaLEyEaJmm9IDQI8lN59AI+H5bnXFL28nbPC0e9ojfA0ckrr7SpM/30ScXI3j3SERYaDdDRiNBnb1/EY0Ue4Pr+GhoUb6PZl0CYOU2OMCvFwqbjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113953; c=relaxed/simple;
	bh=SumIvRF/+btgKi31aP2A00elKsbqbtTce/Qa5BFvx+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQLZ0LWLF0vDZQNVGHzXawok1rG2IP9sI5mP86wbbtF2bFtwjRiwyVjxJSm6ToSrx0pxWKoK+02Pq4dsBi1+aYkTCwKK5oNsWl4iTgCM8UX66TeKDhnJvmC0dnd602crL11bADtvgTx7s4RwB2YlToTKhyJYH4LYipcJitYyqo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnyl8z9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnyl8z9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA2E1F000E9;
	Fri,  7 Aug 2026 14:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113951;
	bh=4jwhz+phSk/xEYNkfU/uHOgeEeVa1wyAsa2VRhb04lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnyl8z9wMYv78JM+oLRfjc5lfwwW9NeO7tO0+QdtKXwkGd7qu8W+8Bxv2LlIgSzYB
	 t1vmMmxDUdFpc1DUXc8Maf56HPjSxtJqreNMMkTHDEP0gdMIRlcK9/QJs1H8Ww9H7n
	 xal9zFwJa765E/VYf42eHVgLm4CNCwGleXIKYQx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/337] hwmon: (pmbus) Fix return value from pmbus_update_byte_data()
Date: Fri,  7 Aug 2026 16:34:56 +0200
Message-ID: <20260807143420.558352061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit a19038a200f18d9e74ac30081797917d0886e16b ]

pmbus_update_byte_data() is supposed to return a negative error code or 0.
However, if no change is made to the register, it actually returns the
register value. This can result in problems if the calling code explicitly
expects to see an error code or 0.

Fix it to return 0 on success or the error code as expected.

Fixes: 11c119986f270 ("hwmon: (pmbus) add helpers for byte write and read modify write")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index a431cce336034..e08e30f288130 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -508,7 +508,7 @@ int pmbus_update_byte_data(struct i2c_client *client, int page, u8 reg,
 	if (tmp != rv)
 		rv = _pmbus_write_byte_data(client, page, reg, tmp);
 
-	return rv;
+	return rv < 0 ? rv : 0;
 }
 EXPORT_SYMBOL_NS_GPL(pmbus_update_byte_data, PMBUS);
 
-- 
2.53.0



