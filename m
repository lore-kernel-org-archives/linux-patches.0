Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31EA3C13E0;
	Sat, 17 Oct 2026 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260409; cv=none; b=bRzTAXSYsptNLO82oBK96wIJDPVui+s1+Y1JfqCsLSa5Mt0ztr1vN7yLuHjjMP5imgQ4eDuEvcm2qf9183e+9/aAuMoxkVB8H3HfUpd5FKYNbazusycF4Uy4Bqx9c7niRx7Mpp+g3XUtPPAh3hnhD/qxBv+FdsobPGa5ifGM7gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260409; c=relaxed/simple;
	bh=SOPpq8WTfgFT9p7Kp04oALa/okbCi/ZCQAAF5ak6Q6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLF61Mtog8Wwt4mhkhEgkLgxBS4DV/Gg8Eiw9CNarZsWNMj8B/49EaHi3QzwmYD5tG7shYyZdPMRdnvpCBdzTwM3d10X1Fq7tveChFgXqxXVzEnNgqGk46Wq4PMA37Pzs0KCd8U/yvFxDOPX3s6Ia2gcYyml9V1txysub1RH1Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6nzKl4p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6nzKl4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE061F000C4;
	Sat, 17 Oct 2026 18:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260407;
	bh=loUbVFpLtuUPb13mTfsHyGfN0Vms9zbudKUEDdNqza4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6nzKl4pwLTb+BwgohxLpomQIY9xvKF1oO/7yRGAzq36OcMdenSOLFEdqwri3NoZJ
	 jg+fpn7z3HRoumU8azy+jcypRrHTpra+duMeypMMWhWtOiMH/hiiLAi1oLIz1YdCE9
	 M6YFvSH6wKFwOE2P4hXh+KciRw9YaxXzB5ZlfEoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1534/1674] driver core: Avoid warning when removing a device while its supplier is unbinding
Date: Sat, 17 Oct 2026 18:03:26 +0200
Message-ID: <20261017160510.492766179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 36d74f17e03f7e60e1b08fbe16cfad6e69cc3aa9 ]

During driver removal, the following warning can appear:
   WARNING: CPU: 1 PID: 139 at drivers/base/core.c:1497 __device_links_no_driver+0xcc/0xfc
   ...
   Call trace:
     __device_links_no_driver+0xcc/0xfc (P)
     device_links_driver_cleanup+0xa8/0xf0
     device_release_driver_internal+0x208/0x23c
     device_links_unbind_consumers+0xe0/0x108
     device_release_driver_internal+0xec/0x23c
     device_links_unbind_consumers+0xe0/0x108
     device_release_driver_internal+0xec/0x23c
     device_links_unbind_consumers+0xe0/0x108
     device_release_driver_internal+0xec/0x23c
     driver_detach+0xa0/0x12c
     bus_remove_driver+0x6c/0xbc
     driver_unregister+0x30/0x60
     pci_unregister_driver+0x20/0x9c
     lan966x_pci_driver_exit+0x18/0xa90 [lan966x_pci]

This warning is triggered when a consumer is removed because the links
status of its supplier is not DL_DEV_DRIVER_BOUND and the link flag
DL_FLAG_SYNC_STATE_ONLY is not set.

The topology in terms of consumers/suppliers used was the following
(consumer ---> supplier):

      i2c -----------> OIC ----> PCI device
       |                ^
       |                |
       +---> pinctrl ---+

When the PCI device is removed, the OIC (interrupt controller) has to be
removed. In order to remove the OIC, pinctrl and i2c need to be removed
and to remove pinctrl, i2c need to be removed. The removal order is:
  1) i2c
  2) pinctrl
  3) OIC
  4) PCI device

In details, the removal sequence is the following (with 0000:01:00.0 the
PCI device):
  driver_detach: call device_release_driver_internal(0000:01:00.0)...
    device_links_busy(0000:01:00.0):
      links->status = DL_DEV_UNBINDING
    device_links_unbind_consumers(0000:01:00.0):
      0000:01:00.0--oic link->status = DL_STATE_SUPPLIER_UNBIND
      call device_release_driver_internal(oic)...
        device_links_busy(oic):
          links->status = DL_DEV_UNBINDING
        device_links_unbind_consumers(oic):
          oic--pinctrl link->status = DL_STATE_SUPPLIER_UNBIND
          call device_release_driver_internal(pinctrl)...
            device_links_busy(pinctrl):
              links->status = DL_DEV_UNBINDING
            device_links_unbind_consumers(pinctrl):
              pinctrl--i2c link->status = DL_STATE_SUPPLIER_UNBIND
              call device_release_driver_internal(i2c)...
                device_links_busy(i2c): links->status = DL_DEV_UNBINDING
                __device_links_no_driver(i2c)...
                  pinctrl--i2c link->status is DL_STATE_SUPPLIER_UNBIND
                  oic--i2c link->status is DL_STATE_ACTIVE
                  oic--i2c link->supplier->links.status is DL_DEV_UNBINDING

The warning is triggered by the i2c removal because the OIC (supplier)
links status is not DL_DEV_DRIVER_BOUND. Its links status is indeed set
to DL_DEV_UNBINDING.

It is perfectly legit to have the links status set to DL_DEV_UNBINDING
in that case. Indeed we had started to unbind the OIC which triggered
the consumer unbinding and didn't finish yet when the i2c is unbound.

Avoid the warning when the supplier links status is set to
DL_DEV_UNBINDING and thus support this removal sequence without any
warnings.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Link: https://patch.msgid.link/20260511155755.34428-4-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index a972b585bae9c..9dc293cee52b5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1508,7 +1508,8 @@ static void __device_links_no_driver(struct device *dev)
 		if (link->supplier->links.status == DL_DEV_DRIVER_BOUND) {
 			WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
 		} else {
-			WARN_ON(!(link->flags & DL_FLAG_SYNC_STATE_ONLY));
+			WARN_ON(link->supplier->links.status != DL_DEV_UNBINDING &&
+				!(link->flags & DL_FLAG_SYNC_STATE_ONLY));
 			WRITE_ONCE(link->status, DL_STATE_DORMANT);
 		}
 	}
-- 
2.53.0



