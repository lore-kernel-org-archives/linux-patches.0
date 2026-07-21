Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFD5436BC6;
	Tue, 21 Jul 2026 19:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661469; cv=none; b=KIpv2X4SVgKgEFFx0R1vwSXK1Wjzz8suJ8JWEEOTAsiHGqXZ05jFmC8xoq3MPYj77ae/vCV5u+pcTqoAX4pu8RgbTfhTCbIDsEclMbEbRaX/7F4mw2kQ66GPlkH2ZeMin7rlc33Sfx7W3Ii1ll3XlJ8ygWwTdIUEJ1vdkLIoj1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661469; c=relaxed/simple;
	bh=Bmbkv2ou8eh9mCg4g7Ujd0FWA/IIm/R37mneGHAnYVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMYdoik8m+UVy0XsalXpUQWuDC42UiBfQ+2FHriFHt2eGs/FvvmTMlX33kCBgH3z0nQfw3B685Q69tmNVhD+8zG38kVyjbRIXmvDA/kY/nkUqyNnn7P5eYhZzPvulkTf1BRWFZfaXgF/Ii4Dch/mE277akviUMRFfhdyH3y4Eac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cg2oXjDJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cg2oXjDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E681F000E9;
	Tue, 21 Jul 2026 19:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661468;
	bh=B3MLrkcpiRL4k5Hpp4KI20FaSVJDLgxPiqkHpJZ2J2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cg2oXjDJiR97K8fsJWKgeYp/tvcx3Mk563ITWlMRXUWI+1jwKYHLUlvo4KLvBdZxH
	 kZxTxsEXkaxAmBOI5YclJgo1thi9C7JOGhz9CeQwDftg+FQmma/xAsNq3j3ThEaGXM
	 4jkCnz973+or1DDUO/qEfa66eD7rnEF3sG+xGmZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0077/1276] driver core: use READ_ONCE() for dev->driver in dev_has_sync_state()
Date: Tue, 21 Jul 2026 17:08:40 +0200
Message-ID: <20260721152447.818686420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index ecbce2530eb733..3463dec1b0c31f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1023,9 +1023,12 @@ static inline void device_lock_assert(struct device *dev)
 
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



