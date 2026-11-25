Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621029;
	b=FbPiXCwC19qE75kAjGsKIDSOO9eVKGuKfRU3NfCj9GrjveLOzV50CwftRHrOT1Ybecgv
	 XpkZgr++bmohxkc7qm9YLHg7MLe0O457XI6k5+Y2O2GzbWkhSqb5TASUzNyjkCP+QGxkp
	 /KEEdA/1JTZPjGCTYys0iE3F9V6vg7HKp71MH0eXNVamSPORVEDxwwrsLBdUjoizJ4WLR
	 DyyGbeyWNiRPF5K5GAGmryJjzyX4YJ0Idh4U0cOpzMlgHXSpFN6IkRk73x9Kuf2zC43k0
	 QfPUJO+bFzHNmzhoQOnszI9bcWnQQgv649okVjceBbliIASuAun9ceZ+1wxH2aDSYFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6nDZvypGwyfR1FuWott4w9igVtR7E4BgFCF8VbirYU0=;
	b=XFZm5n7agvpTFo/rLjwg3dYINKquwH4uW2rzq//jvrWvgkYgN87s1pDeSy1/nNHyrR99
	 CbtZ7yMbagxr/saUEGqdMLgkmpRRziTMAocmnFl98L6qm1GMLOIHZW8T/j2zYb0h9pQ5k
	 aOop4eUU18ebFUPN4SgFRhqs40HxFSalcEJTHtcMOlvhYldKPH/y6sO3G84M7RNZc6KFo
	 yW6CX5vDmXrIamKfsSmc85jW0weRiEnP89FHfNkfnWpXiE4Fe9k0wgxb6rfl48CugOMU0
	 jlyjnG9FYHUKGM1Q3kvPhDEfSUCMoUB/Ss4HEBVb7O9d468disatMBSjsWhxtPd1yVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lk5/qxm7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481CB606A329;
	Wed, 25 Nov 2026 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lk5/qxm7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A8D1F000C4;
	Wed, 25 Nov 2026 15:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621028;
	bh=6nDZvypGwyfR1FuWott4w9igVtR7E4BgFCF8VbirYU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lk5/qxm70USYAoI6IXtV4hlofphGoktb0prMXlQqwaRlXcQKeAmcymVr7hz0Y0n3Y
	 JJZjYV6heUdJk3+xeobMcnrEFhsaxcsR0zJwwxDWYHunkTcAsBasFsEs8ZO4E+XQjr
	 bklajtmcaA/jerxaIwYvLztuqeAxog/+Kv0Usbwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/990] ptp: drain virtual clock sysfs operations before unregistering children
Date: Wed, 25 Nov 2026 15:24:24 +0100
Message-ID: <20261125143824.361286199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ef020599b7711..8b27c749aebea 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -494,6 +494,11 @@ static int unregister_vclock(struct device *dev, void *data)
 
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
index db4039d642b41..ec8633126d6b8 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -169,6 +169,7 @@ extern const struct attribute_group *ptp_groups[];
 
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



