Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A581478868;
	Tue, 16 Jun 2026 18:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634424; cv=none; b=oSO/pXZnRLTl2/kTnlBzSt/QAGikr8EyyYgXCU2VL3fdClWZjJ6dJCXq+Df5UI6fV9A6w2GzRvhDrPD6A6YgHLynZ7QugyRXX5f5ov8XYEh9xnIPZI02/Hx3wv1UZogKjr2mVaKQM0jPDnpy5kon/F4H4792y/kQpwGtTUVM304=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634424; c=relaxed/simple;
	bh=36Vnu8Oyg67v1G9u0dZ4clkIQXzY78KfKDAs04DNdos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG8OwzHNvFFJZ0VvoEdSCsZEuiKGK2NWiHRzttovzuijH1cc0R89QwizErJc3n15Y24Z1wTEjLlQzanN/xVyECoE4d9qppGKpW0wmYk7+h2CTmhHU3Q6zP7GkM0mqagqkkIT1QnI2hGEUeiZjOjIbuO2aQ/JymH2xyiQ3XltX3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ao2Qkrfw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ao2Qkrfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC9E1F000E9;
	Tue, 16 Jun 2026 18:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634423;
	bh=ep8fvqDWxe4Ka65CK4b3MnOBWJaUCP1w97f4UjOt5ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ao2QkrfwbPUeqsaWvmrkuUZM8rNe/gZ0eA7p8mUuZTbjPa5qWww94/sm+ViRlSehI
	 oQhuxNvVoXdsvETZlqwgwsyYc/jhA8RnjhgPzGjSqm90884fbv0lNiocNtero8a6KG
	 EDo09nGsIopi5xzPsqeNWR7V69qQ7G4RdmyxVxJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 229/411] net: bonding: fix NULL pointer dereference in bond_do_ioctl()
Date: Tue, 16 Jun 2026 20:27:47 +0530
Message-ID: <20260616145112.988728651@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4250,11 +4250,11 @@ static int bond_do_ioctl(struct net_devi
 
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


