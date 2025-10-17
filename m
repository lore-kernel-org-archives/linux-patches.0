Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6595A335084;
	Fri, 17 Oct 2025 15:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713575; cv=none; b=ZQNQkJ9frWELvdCs+i3M/MkvjsNV8zZ3Pm+tZ/8AuvutXKDAekZfFcxA5WREK8UWjVS/5xZTRW/ToPCHWB5Ukz3OseSaCsDGuYhXgKtQKUiWbTbEVt32HAI8BTwe7XYZ3E5CwVwyFAV1/okpHxe7ehiYr91uVpXQ53YjqipMFsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713575; c=relaxed/simple;
	bh=4y0Xuc1Be/dK0Vw2u3VHfv7dGWKlJzDtDhg0zXIK6Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SiB5iyf3LATqfQYcUCW5mOAMftUOpjIE7UyRYiEf39YCkATxiIiBDyKsI/U/zbD+H6nobmNPbuarPFcw2FRvx3N5oontkELJ8kxEg1+A0El9mTToUL3GqffH8RpZYzg//z5EXSy0RdN261GwEVY3oLw8qTpWn54HJGsVnzHSVYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMqQUymH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMqQUymH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ACCC4CEFE;
	Fri, 17 Oct 2025 15:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713573;
	bh=4y0Xuc1Be/dK0Vw2u3VHfv7dGWKlJzDtDhg0zXIK6Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMqQUymHLvff4u4STnO3mWcx2+GVBFs4F5418kxrSj/d1mzULSh7mY75wMM1p03L7
	 NRLZU+mE6ZXaMmDFbWJbnrkqOqGAOaiIrcF/VfGAyR65TTjCDj58lvd7uDVYuHJCXR
	 nfl+Lw7doHDGddCbO7jDxAm8/vbt6FmHZDfbMMiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/201] rtc: optee: fix memory leak on driver removal
Date: Fri, 17 Oct 2025 16:51:13 +0200
Message-ID: <20251017145135.183126279@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Le Goffic <clement.legoffic@foss.st.com>

[ Upstream commit a531350d2fe58f7fc4516e555f22391dee94efd9 ]

Fix a memory leak in case of driver removal.
Free the shared memory used for arguments exchanges between kernel and
OP-TEE RTC PTA.

Fixes: 81c2f059ab90 ("rtc: optee: add RTC driver for OP-TEE RTC PTA")
Signed-off-by: Clément Le Goffic <clement.legoffic@foss.st.com>
Link: https://lore.kernel.org/r/20250715-upstream-optee-rtc-v1-1-e0fdf8aae545@foss.st.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-optee.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-optee.c b/drivers/rtc/rtc-optee.c
index 9f8b5d4a8f6b6..6b77c122fdc10 100644
--- a/drivers/rtc/rtc-optee.c
+++ b/drivers/rtc/rtc-optee.c
@@ -320,6 +320,7 @@ static int optee_rtc_remove(struct device *dev)
 {
 	struct optee_rtc *priv = dev_get_drvdata(dev);
 
+	tee_shm_free(priv->shm);
 	tee_client_close_session(priv->ctx, priv->session_id);
 	tee_client_close_context(priv->ctx);
 
-- 
2.51.0



