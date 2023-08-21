Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331E41171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB98BC433C7;
	Mon, 21 Aug 2023 20:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648447;
	bh=78MYwy8XgCAgFKukhPUGoBjr05wRf4VSiu4SwVb4B3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0DgMCMnyOOnYFEZn+fqBmPfXOhGrjEWWuyQP+x49y77wENJZ8bV1gP/Dcwga2dC2D
	 pIBy4+DJSrDiq6r9rbUsqvDjBC44frCZlx8eyYy2SzQfjNgKUjiS705mfsXEUEwN2T
	 vC07xwrJuHFfT5sC5JE7tCBHxyMtb/N2w44d4BUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Chopra <manishc@marvell.com>,
	Alok Prasad <palok@marvell.com>,
	John Meneghini <jmeneghi@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 178/234] qede: fix firmware halt over suspend and resume
Date: Mon, 21 Aug 2023 21:42:21 +0200
Message-ID: <20230821194136.709602289@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit 2eb9625a3a32251ecea470cd576659a3a03b4e59 ]

While performing certain power-off sequences, PCI drivers are
called to suspend and resume their underlying devices through
PCI PM (power management) interface. However this NIC hardware
does not support PCI PM suspend/resume operations so system wide
suspend/resume leads to bad MFW (management firmware) state which
causes various follow-up errors in driver when communicating with
the device/firmware afterwards.

To fix this driver implements PCI PM suspend handler to indicate
unsupported operation to the PCI subsystem explicitly, thus avoiding
system to go into suspended/standby mode.

Without this fix device/firmware does not recover unless system
is power cycled.

Fixes: 2950219d87b0 ("qede: Add basic network device support")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230816150711.59035-1-manishc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 4b004a7281903..99df00c30b8c6 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -176,6 +176,15 @@ static int qede_sriov_configure(struct pci_dev *pdev, int num_vfs_param)
 }
 #endif
 
+static int __maybe_unused qede_suspend(struct device *dev)
+{
+	dev_info(dev, "Device does not support suspend operation\n");
+
+	return -EOPNOTSUPP;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(qede_pm_ops, qede_suspend, NULL);
+
 static const struct pci_error_handlers qede_err_handler = {
 	.error_detected = qede_io_error_detected,
 };
@@ -190,6 +199,7 @@ static struct pci_driver qede_pci_driver = {
 	.sriov_configure = qede_sriov_configure,
 #endif
 	.err_handler = &qede_err_handler,
+	.driver.pm = &qede_pm_ops,
 };
 
 static struct qed_eth_cb_ops qede_ll_ops = {
-- 
2.40.1



