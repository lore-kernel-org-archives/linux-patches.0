Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621032;
	b=wp2eRqTqgfwdSTIWKnR+PHYmj0tcKxWLwwuqlN7HVW/+e20ZHQG3JzJAnE3XUqwuqtxl
	 H65/+1Wn+DXimjRtQtmZ4rQ02VD7gpYzm/VaYmdC7YZdyq/bTI8VZMVYZE3eXginKk1Uj
	 iklh/pHUIj37nXuYzaWWCIMNSL8Ju0KIu8RF3umB38uQY1q9oCx2N4retA8iNyTKFOltX
	 m3UZD79MtLdgFVOHPZmtJGSKmUhVriim/1RWUm/bO5CgF0Vu0SyVbqnXLDhL7B06HixfQ
	 0B35X20DxTQkUQ79VeF3BHUOZQO3YxprwSDsXngl1CtszDm1+3IGpU1Uj3SLO44wLOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AqKImYs6IkhOjKScm1JZ9Nn6hp4tK+sPuOWsPptwS4w=;
	b=UT4rycdGYSvMmh4jkTeUuY8KJvQzSg/zRjh+sWKJqMnAle2rlgHwDaj6jFbNUcIEjwXk
	 i1PHfHxz06gkTTltOGZ7Wy2pqIBXucPzKoCWoVbogUKO2XUFmfy954IpY9bKitKEQTo7h
	 UuHKcfFWcfn/WVcGJwpmi8jY8agP/PDFvOghrDT/0bZKLTWEH0R8GKryIrVutRu1E3cq8
	 Tm/Zn6lTA/n13qaCyirEvpsS6duZECbsoC0bT+PJryWs0nOglC1zSoRjhcz7DEyVxoFAO
	 XffLf1hg8AOevLrGTi8i9hCacz+r1BSmwUVXOIEfSJbUUNxZc0WLSx1Dn2DS+sg5t7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uA5Uux8d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357E4606A329;
	Wed, 25 Nov 2026 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uA5Uux8d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C0B1F000C4;
	Wed, 25 Nov 2026 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621032;
	bh=AqKImYs6IkhOjKScm1JZ9Nn6hp4tK+sPuOWsPptwS4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uA5Uux8dbcRMVpekYzUQu58/TV8H1H+kZscJGx3Wj6UvGfKj3AK73fZcfBs5dOeMb
	 5pbXF6oZeaJP2E8RdluPBC0ySlZSptYGUB8Qhoer8nIiWAXfoxQAK1l8RD0LS/pcFh
	 58kaJJLQFBu4lXDI0dmGBuymSP+GB2xIYy1J5s4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/990] ptp: unwind partially completed virtual clock creation
Date: Wed, 25 Nov 2026 15:24:25 +0100
Message-ID: <20261125143824.385496704@linuxfoundation.org>
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

[ Upstream commit 3dea778260e3dddf30651a6913d87a42861346a2 ]

n_vclocks_store() publishes the new clock count only after every child
has been registered. If a later registration fails, it returns without
unregistering the children already created by that request. Those clocks
are left out of n_vclocks, and a subsequent request can overwrite their
index entries without removing them.

Unregister the newly created children in reverse order and clear their
index entries on failure. Leave the previously installed clocks and
their count unchanged. The n_vclocks mutex serializes this rollback with
other sysfs changes, and parent removal drains the store before walking
the children.

This was found by code inspection while adding initial PHC sample error
handling to virtual clock registration.

Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20261026-ptp-vclock-sampling-v6-2-e705612541f1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_sysfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 998de4be08ebd..b07274b67294a 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -229,7 +229,7 @@ static ssize_t n_vclocks_store(struct device *dev,
 		for (i = 0; i < num - ptp->n_vclocks; i++) {
 			vclock = ptp_vclock_register(ptp);
 			if (!vclock)
-				goto out;
+				goto err_register;
 
 			*(ptp->vclock_index + ptp->n_vclocks + i) =
 				vclock->clock->index;
@@ -261,6 +261,12 @@ static ssize_t n_vclocks_store(struct device *dev,
 	mutex_unlock(&ptp->n_vclocks_mux);
 
 	return count;
+err_register:
+	num = i;
+	if (num)
+		device_for_each_child_reverse(dev, &num, unregister_vclock);
+	for (num = 0; num < i; num++)
+		ptp->vclock_index[ptp->n_vclocks + num] = -1;
 out:
 	mutex_unlock(&ptp->n_vclocks_mux);
 	return err;
-- 
2.53.0



