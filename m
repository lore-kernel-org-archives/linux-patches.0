Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6AB169AD2;
	Tue, 16 Jun 2026 17:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632057; cv=none; b=EeUfaeb22uRrvx4+9YegrRZGfzhiZyALjMSmn+sitcQU9BIBumqI+XzkhscNjb7MPpI5i21PVsEd5Ir2rLAhTrhp4C17QvOGga6DRiPLtfulNnejq5mIPj5hHTCpA8KSrKksPN2RR3jf/n6wqX1D+/qbb5LXt13ZXm87hBGhQZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632057; c=relaxed/simple;
	bh=UVa0SNQgSIhEtui1Qb0l5ZBaw1tncLJD7LFKfUk9m4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EikFcgLV9/aXZgv/cjrCK27yZIwQwwnvfGGviZh4aIbvzzPSb5T9+gTGR/XXiNl53sSWDI4OsE5Gw3QMBvR13bKvbcmJxtj8W3mn80iX+wPT98gM72p4HwMqHk/xq0WNhaooj+tosTaDLM3YXfpL08hBn5wBiOqMiZHu4AiKq24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6hCMPho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6hCMPho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26461F000E9;
	Tue, 16 Jun 2026 17:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632056;
	bh=L1Jgr5s42l94IGg46MI5pewWEza6oDv7wXItZm7CyeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6hCMPhokQVv4SiDHpFPBI+x5m3/9zq/NI0eeVHNjF18unVXLwPmDE63bdHY+Xf27
	 sa66ojw4BahAO1qUC0bgyzkHh3Dv2NM0HXXQSLerSIcyCmJgif4qP6evEpKbV+30I2
	 c/pNQdGAQ1uQUyJZcoliM/q4La6/U1A6Olh3R7y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 305/522] net: bonding: fix NULL pointer dereference in bond_do_ioctl()
Date: Tue, 16 Jun 2026 20:27:32 +0530
Message-ID: <20260616145140.151217037@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: ZhaoJinming <zhaojinming@uniontech.com>

commit a764b0e8317a863006e05732e1aefe821b9d8c2d upstream.

In bond_do_ioctl(), slave_dev is obtained via __dev_get_by_name() which
can return NULL if the requested interface name does not exist. However,
the subsequent slave_dbg() call is placed before the NULL check:

    slave_dev = __dev_get_by_name(net, ifr->ifr_slave);
    slave_dbg(bond_dev, slave_dev, "slave_dev=%p:\n", slave_dev); //here
    if (!slave_dev)
        return -ENODEV;

The slave_dbg() macro expands to netdev_dbg(bond_dev, "(slave %s): " fmt,
(slave_dev)->name, ...) which unconditionally dereferences slave_dev->name
before the NULL check is performed. This results in a NULL pointer
dereference kernel oops when a user calls bonding ioctl (e.g.
SIOCBONDENSLAVE, SIOCBONDRELEASE, etc.) with a non-existent slave
interface name.

This is reachable from userspace via the bonding ioctl interface with
CAP_NET_ADMIN capability, making it a potential local denial-of-service
vector.

Fix by moving the slave_dbg() call after the NULL check.

Fixes: e2a7420df2e0 ("bonding/main: convert to using slave printk macros")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Link: https://patch.msgid.link/20260601085649.4029067-1-zhaojinming@uniontech.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4623,11 +4623,11 @@ static int bond_do_ioctl(struct net_devi
 
 	slave_dev = __dev_get_by_name(net, ifr->ifr_slave);
 
-	slave_dbg(bond_dev, slave_dev, "slave_dev=%p:\n", slave_dev);
-
 	if (!slave_dev)
 		return -ENODEV;
 
+	slave_dbg(bond_dev, slave_dev, "slave_dev=%p:\n", slave_dev);
+
 	switch (cmd) {
 	case SIOCBONDENSLAVE:
 		res = bond_enslave(bond_dev, slave_dev, NULL);


