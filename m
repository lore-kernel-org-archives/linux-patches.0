Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A06B450902;
	Tue, 16 Jun 2026 18:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636233; cv=none; b=ZrbIVQFNs0LQs3yqCdcfB9RAGlu1ylXZUlxTqbyBzVZGK/ocv74Wl4/mNYOacZ+q+ViqZYGwXzY01mxi178qPqoNGdVr/Ug4xY5mGm4dUkS5l0pD5Em2DRcUSmO0cQJVNVamnJN+DZtrAuu5+v8e1noIQmoCF9BP6Y21bvLMvHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636233; c=relaxed/simple;
	bh=QZyGmONEVFMbKw4kthrUB2yQdm7x7b3MQdHQ5JizD5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqy5No/GZJ/bj9akA+xtOEOL6cYXIfczCrLv+YeqagRoK1X6IIbBYVF6Sm10DElBIIBnxPPSfF5EbL1HQwbfXKJ91NKiqkcaY63hcpLChdbbAwZnKX3WKxs1LbGoLHvcCvFzut3g6JMDo8kx3g6dXVRMCd0ZwE5vnESoDU7Gduk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCrg+9o8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCrg+9o8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C851F000E9;
	Tue, 16 Jun 2026 18:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636232;
	bh=bV0DqxLF5V9L9Iw5CjK/GQFkehHFKG1at0rnp//1FcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCrg+9o8UYv0E2YwXuDKu3fUpfFlCa7EuqEe17XZyZA4DFyS+mvOKq20izKRzAffd
	 OI2Zh2QKvhv3T7VtsIl4V7N3MgozD38LbpyGZIkgadax/PwgUK2G6jiVV0R/Y/AYmI
	 l1MJ4SIZxO4Qhn8LltXrsjUJbzUjYSacOsmnTbLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 200/342] net: bonding: fix NULL pointer dereference in bond_do_ioctl()
Date: Tue, 16 Jun 2026 20:28:16 +0530
Message-ID: <20260616145057.514128808@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4018,11 +4018,11 @@ static int bond_do_ioctl(struct net_devi
 
 	slave_dev = __dev_get_by_name(net, ifr->ifr_slave);
 
-	slave_dbg(bond_dev, slave_dev, "slave_dev=%p:\n", slave_dev);
-
 	if (!slave_dev)
 		return -ENODEV;
 
+	slave_dbg(bond_dev, slave_dev, "slave_dev=%p:\n", slave_dev);
+
 	switch (cmd) {
 	case BOND_ENSLAVE_OLD:
 	case SIOCBONDENSLAVE:


