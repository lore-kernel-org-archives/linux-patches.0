Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042B446AA68;
	Tue, 21 Jul 2026 15:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648168; cv=none; b=BxDRShx7hp++3BIdnNuVA0YaoTxFRkyTJkdZwLzqF90js6t6ewGTtToodh6NLJ8NO2AgpQtr2HMMTeng1jdInFm3kimSO/smpmZKF4EzasDwT8VUH5UlSkWFib+brJ1d2a7De6+SzxjDJBFFjOUiTEzmM3w6JJshm/YBhylOous=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648168; c=relaxed/simple;
	bh=chstTvPE1rsU832U2au5CVNS6UFzWe+Vw7aoATG0QAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJx31L2wsJQ3RQ2G2ZrthU0VQoJuWt707SnT09ZH/Dq/7IhITbFQxHLLU6HGudsdHrbOOBoTBflDNJSGgJEYuInRZAyu//PtQ24vFHZlk0Drn6BBDxwy76+D8/gfuxMznGpnEmS6ErCtphAMgUj+0e3br2S/1KDOJLozcI9YPmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiHCLk3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiHCLk3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351821F000E9;
	Tue, 21 Jul 2026 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648166;
	bh=JfzlC0S5NhyLx4ejKQf7sYssLc3xdLbqEjza1afMYAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SiHCLk3PTWFAl7uBvgBqN4qEX40XFfqvYy9jV8TnbjLjmEA6m0LQvT8n5yVGm10dc
	 XHUIumtiJsIWoR8PfXFnTcPlgnP4pxld5DdmzMpmEkxIv1nvhjd+UnKhX5NcCn4yJd
	 8K9CzD7xpkzsqTXa1R2BYcyYVItFybHceAGVP5y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0098/2077] driver core: use READ_ONCE() for dev->driver in dev_has_sync_state()
Date: Tue, 21 Jul 2026 16:56:11 +0200
Message-ID: <20260721152555.004007387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit e9506871a8ea304cde48ff4a57226df2aadddae3 ]

dev_has_sync_state() reads dev->driver twice without holding
device_lock() -- once for the NULL check and once to dereference
->sync_state. Some callers only hold device_links_write_lock, which
doesn't prevent a concurrent unbind from clearing dev->driver via
device_unbind_cleanup().

Fix it by reading dev->driver exactly once with READ_ONCE(), pairing
with the WRITE_ONCE() in device_set_driver().

Link: https://lore.kernel.org/driver-core/DHW8QPU1VU1F.3P6PH69HLFBYC@kernel.org/
Fixes: ac338acf514e ("driver core: Add dev_has_sync_state()")
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Saravana Kannan <saravanak@kernel.org>
Link: https://patch.msgid.link/20260418162221.1121873-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 9c8fde6a3d866b..79a4a6549be8e3 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1065,9 +1065,12 @@ static inline void device_lock_assert(struct device *dev)
 
 static inline bool dev_has_sync_state(struct device *dev)
 {
+	struct device_driver *drv;
+
 	if (!dev)
 		return false;
-	if (dev->driver && dev->driver->sync_state)
+	drv = READ_ONCE(dev->driver);
+	if (drv && drv->sync_state)
 		return true;
 	if (dev->bus && dev->bus->sync_state)
 		return true;
-- 
2.53.0



