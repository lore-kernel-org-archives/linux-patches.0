Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624079;
	b=uvcWOLdzvVb5H46dYzuvSV6ZsSWgoVZNWanc7ljTx7JIcehBmVT63aHhKQtP4WHBizic
	 +/Tf2+9KX7JMX1MVgwLj5ls/Z2I0vJCsM5+VUN799B8nU40pMygtoFm1Sg9PICTjB7abQ
	 38looCHSQuuW1DssG4AuerBCDekPsoFnbeEL+dTAvKVbsHKl5p3IQdqttIZJk1Hhh6psJ
	 9YkzLIRl7mdhSfUJwofLOfa2p9w+ZQmRpV15VhOCp4hzBX8sjUrQXNSeK0RSCcQDdhl0a
	 NNDEQmjH3qIMAC9h85qT23ItC/DnOL9tBggZEvqRQZJC/M/+U5v2fVTayi4NWemUwjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b5xRaFNnNIV86zm1BnZdq/tsM3vaQgHx1MvsJAr0Ab0=;
	b=MkkdEjM4/9HdN8RqSwLa2ifCq3lhfO0PN9C4CVxRMTXwPkRYZnTnrtF8kQ7ReVIkkIYL
	 eK0CsrYbHG+pmb0Gb7QfYt2A+iGVe76rn3d9scC9S4kHfru8hO2bvYXsYgMtOB89pb6ww
	 MO5K2Eec12APw1LyrbQm+PF8O4Fn+R28YGWXCX1uqLVBQfHJGhcpIEWC7I9Sy5QJfnzu7
	 vUdHv/WFn5m6ED+gtexzyY+92aU7T7fjHg7PDayfzT4QnrAqfMkXPloFV0yDDecM6kbnE
	 pDou0ddi2A/b1bd6Q4P3MsIo5m5hsWpEtGPtDXXztKyVoPrA/585QibFceb2I4+JM2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LBtiSqa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB38D606A32C;
	Wed, 25 Nov 2026 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LBtiSqa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30D01F000D2;
	Wed, 25 Nov 2026 16:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624079;
	bh=b5xRaFNnNIV86zm1BnZdq/tsM3vaQgHx1MvsJAr0Ab0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LBtiSqaHWLPSIaeGNKMfvn5Dm1+9SpQdem3OwUV+LouXqlFi6v+wkxgBWVNqEL83
	 klPcxe8+kzdG532nG9P528W+qoqQl+LR3U5s44tP2mMQXWxGJf9zT9zDEX3gYyynCA
	 /uER86cjQItVnAjvtA9PEDGvXmbRqMgIBzUiIPgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/816] ptp: drain virtual clock sysfs operations before unregistering children
Date: Wed, 25 Nov 2026 15:27:05 +0100
Message-ID: <20261125143851.004452298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 03c17b1db7aac..52849072e4372 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -424,6 +424,11 @@ static int unregister_vclock(struct device *dev, void *data)
 
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
index f329263f33aa1..5ac416074ad26 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -167,6 +167,7 @@ extern const struct attribute_group *ptp_groups[];
 
 int ptp_populate_pin_groups(struct ptp_clock *ptp);
 void ptp_cleanup_pin_groups(struct ptp_clock *ptp);
+void ptp_vclock_remove_sysfs(struct ptp_clock *ptp);
 
 struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock);
 void ptp_vclock_unregister(struct ptp_vclock *vclock);
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 0d4b081daf639..998de4be08ebd 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -267,6 +267,12 @@ static ssize_t n_vclocks_store(struct device *dev,
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



