Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D099E46D2B3;
	Tue, 21 Jul 2026 17:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655642; cv=none; b=UvEVBUBlXS22YQbzhvlKzUEdihB2Mdmcon7wFqmD6ljTc27ZCSuavwclo3oi9Rs9tz+cLihrAWUv0UcsvCf9cqqcGPpoI+ovt7MoYmsLEkFdXn/1frVyCw5lNKUgev+yCUyQiF+jjHeGRWfgON+nQwpvSD17WSMJxzcbJ0uIpuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655642; c=relaxed/simple;
	bh=6H2QoPJ1ctjrPWbn3VB1P9N8jdsUp9nJ7r5jlQjlwto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQnzw1DTgDhMynRvOm2pVlUspZk9LSSzumDltlc3RFXBKaMhlSwr55YZDF33uTwGRt7UI9xKJ4OMwnXu0+8Drj0yKrdbvt/mq+43ncSZYZsGTSKamJtWlKi5ctZzJSPyZ8UiPdPRd4r80fh2yzts8Vq8kiY32AicbAbDfmemF4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXeWudZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXeWudZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434761F000E9;
	Tue, 21 Jul 2026 17:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655641;
	bh=cFQ40mTZpH2IROnmN1HtovNVF1Z9h0dgCCyktEc8tLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXeWudZWBc0pJMF2ZGLlQ/Q+Cm0WfitxLgUclyq1rSwm/AgI+E3k3tKjt9D8gwoxM
	 eGINHn2Gk+yrQag8gBuDZp9xkrJpg10F9as9YgPylSn08AhPVzLsMS6IhD0rrpJlHx
	 E/oV2cLqOPtGTNZIi13akDDK/cMzWAvyGTGNfwRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0085/1611] driver core: use READ_ONCE() for dev->driver in dev_has_sync_state()
Date: Tue, 21 Jul 2026 17:03:21 +0200
Message-ID: <20260721152516.757250548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 84910bffe79533..dc1252a06480cc 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1037,9 +1037,12 @@ static inline void device_lock_assert(struct device *dev)
 
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



