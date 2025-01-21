Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDA11F0E44;
	Tue, 21 Jan 2025 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482418; cv=none; b=b+IP82WiDpJ1BIh9ZsD2Ot0jVCwinEcQa5wy0Bb+GZcjhDtKv9fTtfK1AAH2SUs1jWCa3Co4KTUP+cubPg5B6cxxHhK0ediOidbyq3xqr976Od3vLuCwEISKmMhAs7WhomR8dygL04vZdtHuEJ0CX2QAnFe8/7kieUdlxP1Mi3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482418; c=relaxed/simple;
	bh=Xw5khCM+XjYe+IG94e2Q9gPWVC4hCOJot0xOCsN1ZMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3c11Ii+IGpVgmcbiQTiJSQKO7te34p1kSWpebdnnmOnvGkTzNkkBhCBV90LanKOmpcXm5rcJNKxAKreM1eNpmIn3XyR4Jg/8/eJuMXzB8QA2PBOSuV86lpp2wUcQ1gCw9qqSa9EJ+cIbUSVUpjxLnrDvYWpYoINgnC/iQ+Wh80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X58nOzJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X58nOzJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B371C4CEE3;
	Tue, 21 Jan 2025 18:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482417;
	bh=Xw5khCM+XjYe+IG94e2Q9gPWVC4hCOJot0xOCsN1ZMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X58nOzJEdSI4RcChKK5Tyeiqsos235383REyO4dIEyS2R6pxJLwVqVHtuIjvqahO3
	 +IACOKlz4Uhqp22K3K9obEHl/btt+Azg4RNsbUO+G4k8buuBzzPDaBkmWKqtW7QpzW
	 1yGbS7U2vSm5cueorsLzUE69QellEJ4PV+0x+LM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/122] i2c: core: fix reference leak in i2c_register_adapter()
Date: Tue, 21 Jan 2025 18:51:27 +0100
Message-ID: <20250121174534.491586824@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 3f8c4f5e9a57868fa107016c81165686d23325f2 ]

The reference count of the device incremented in device_initialize() is
not decremented when device_add() fails. Add a put_device() call before
returning from the function.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 60f68597024d ("i2c: core: Setup i2c_adapter runtime-pm before calling device_add()")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 7c810893bfa33..75d30861ffe21 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1562,6 +1562,7 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
+		put_device(&adap->dev);
 		goto out_list;
 	}
 
-- 
2.39.5



