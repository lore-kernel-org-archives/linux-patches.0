Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBF944AB6E;
	Tue, 21 Jul 2026 21:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668774; cv=none; b=OmfW4C7hdgmclWVNV/AgvOHBMJQYF/cHyn5clBVFsDb5GqAkUku/2WrKUUPiwX2yER5znVaSNIcBVYIXDREtN25uS1/1wLJK1r7ipa0uMCLCFQNiTYrEB8r7FP4bfcjvfM/WgNQdf571S1FnyeSXXhQLiM+03b/dtr8APht1Vz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668774; c=relaxed/simple;
	bh=OAj+mW6rlo/H/HWhcOkp6UaaQfqUfVXpAO5gFJ8HATA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrGUommGMz1MNJmJp8DLax6uiYDsLQbsTh7XjrLPmAzAlVKJQq6u8k+CWvR8TpEpmcJXfpS20PcOm5baD8PtwpBGpAHYGDGv0hhEZzSUrHSmauLSGb9DC5VLtlcFkbmjBtshwiANlguO/V7zfdrrt8/EMKYcvP5SvwH/lGbIsME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5jDZoO3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5jDZoO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAB61F000E9;
	Tue, 21 Jul 2026 21:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668773;
	bh=oIiuEeuT5qUEpX/g775AsxIeJD1lN9Llu/QgKPp815Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5jDZoO3+d9GuCsPHm7zBR/uaH0jdyqzv1oMzsaIK8ite1VwLFG1nNb7KIIUbpZ6d
	 LbNr4kAjqSykBuXIrW7v96wsIryjTdbaIfQr7N77LtQv/ngVQpHFShphVvpe6Lf+WB
	 2BeH2+rbvwjzeisWDcdJ5hyfdgKbvXLtciRS0698=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0286/1067] driver core: use READ_ONCE() for dev->driver in dev_has_sync_state()
Date: Tue, 21 Jul 2026 17:14:47 +0200
Message-ID: <20260721152430.999027711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e642b366aa380f..eae657af3a0e51 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -914,9 +914,12 @@ static inline struct device_node *dev_of_node(struct device *dev)
 
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



