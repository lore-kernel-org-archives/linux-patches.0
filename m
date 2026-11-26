Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705083;
	b=K/VHnBZBtxdMyRCFOfo6+yj7SzfK9NYGIOzJjgThKrSoCX4wSZEZk62Uv5vgOqnGPUjA
	 xDUPezVIfPmX+OJhh9EuU8XRYGP17a4hta1onSy19Ta344Onj4VovUuODeZMXFv6m4njk
	 2xpnSTaN8YlN09b0GE3aUFiMRkn7zT7SW0ovYhC/fYxNVN47jJ9738d8PUlnaQSwJqp1M
	 SFmOirqu+VkP0FR803SnCC5pDwHgQY/DI8EKFzu6sCqwC/Fmfpzc3nbc4mc5uBcR9+h+u
	 Pye2SruLq1TYyH5kIn+BESiL/c/aigx17jL69nGfi6PoB1rNgP9bRUWxiDYB7H7ddaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BE742eioWA7olonIt3xzd5++uyhFnyPNu4tPo8AaMYs=;
	b=FNQJN4dVj97fbpuVUvfHJZT/d4dxGzyyitgYrSgKGnLHjn1UFtEORRcHhxjtG78lp+b1
	 uxE9NfOfGNScnsfgtVNBpwY9OtlCA/cp5zweQ+A9kUVRuwUAh0ntsGSS0WlZnO8tDJ/Tf
	 TW0bwlK4M84smuLjtaRDzXaE54Wf4VtIKKYfIpmPVQW6YDv9yocoMnY+iOAF3kF5vYSlg
	 w5FxZXFKv81GtR0Cap9vetAjn4K6F0DH6xSl0EvmucbB4Y8RrAIFU48+PxOEn/idYavJf
	 GiR5ksFW0799f4uo3h2zII/KCCAcSdICnFI7xrB0l+vGoBiD4gRuiwSUwVHGMPeajcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rCcrmjLm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF92606A32C;
	Thu, 26 Nov 2026 14:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rCcrmjLm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91211F000CF;
	Thu, 26 Nov 2026 14:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705083;
	bh=BE742eioWA7olonIt3xzd5++uyhFnyPNu4tPo8AaMYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rCcrmjLmDjBfRyxY4xGyzFMRdW06VCPuoTWSgiGvmVIh8fH1SviRP722XDVsDNjMg
	 Uu7mb0ZyXVYWesHQCnRQVDfr6NWMq4DnVLUzcpKKlCraSpkxQZDkKUAZrnbg5VYfhn
	 hVAKUcB/AGz8zPNvsnVCr6IBrevU5Qlw/N3lOzTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/319] ptp: drain virtual clock sysfs operations before unregistering children
Date: Thu, 26 Nov 2026 15:36:40 +0100
Message-ID: <20261126144007.464374972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit 0e4a135aebc7686286d87e286499ce55e5bd5aad ]

Parent clock removal walks its virtual clocks before removing the
n_vclocks sysfs attribute. The mutex taken by ptp_vclock_in_use() is
released before that walk, so a concurrent sysfs deletion can pick the
same child and unregister and free its ptp_vclock a second time. A
reference held by the device iterator does not protect that separately
allocated virtual clock.

Remove n_vclocks before walking the children. Removing the attribute
prevents new stores and drains stores already running, without holding
n_vclocks_mux across a callback that needs that mutex. Skip virtual
clocks, which do not have this attribute.

This race was found by code inspection of virtual-clock registration
failure cleanup and parent removal.

Fixes: bfcbb76b0f59 ("ptp: unregister virtual clocks when unregistering physical clock.")
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20261026-ptp-vclock-sampling-v6-1-e705612541f1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c   | 5 +++++
 drivers/ptp/ptp_private.h | 1 +
 drivers/ptp/ptp_sysfs.c   | 6 ++++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index d6dee90bed35f..d1e76f9ecea2f 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -348,6 +348,11 @@ static int unregister_vclock(struct device *dev, void *data)
 
 int ptp_clock_unregister(struct ptp_clock *ptp)
 {
+	/*
+	 * Stop and drain virtual-clock creation and deletion before walking the
+	 * children. Do not hold n_vclocks_mux while waiting for sysfs callbacks.
+	 */
+	ptp_vclock_remove_sysfs(ptp);
 	if (ptp_vclock_in_use(ptp)) {
 		device_for_each_child(&ptp->dev, NULL, unregister_vclock);
 	}
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 1787fb7a9e1db..2497c37b2de04 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -146,6 +146,7 @@ extern const struct attribute_group *ptp_groups[];
 
 int ptp_populate_pin_groups(struct ptp_clock *ptp);
 void ptp_cleanup_pin_groups(struct ptp_clock *ptp);
+void ptp_vclock_remove_sysfs(struct ptp_clock *ptp);
 
 struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock);
 void ptp_vclock_unregister(struct ptp_vclock *vclock);
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index be58d5257bcb6..88814e7d19785 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -247,6 +247,12 @@ static ssize_t n_vclocks_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(n_vclocks);
 
+void ptp_vclock_remove_sysfs(struct ptp_clock *ptp)
+{
+	if (!ptp->is_virtual_clock)
+		device_remove_file(&ptp->dev, &dev_attr_n_vclocks);
+}
+
 static ssize_t max_vclocks_show(struct device *dev,
 				struct device_attribute *attr, char *page)
 {
-- 
2.53.0



