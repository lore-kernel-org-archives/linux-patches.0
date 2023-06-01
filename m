Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFF2E54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79456C4339B;
	Thu,  1 Jun 2023 13:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625901;
	bh=nhyMnnQgX7jpXljlgHLHbEzNS4uQQWL+pnAbSlL+Gfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pN7IdPrauS0Au9h4YlBaRfRSMXbXc35XBuYYk+V9/WRswq00ifwR8Pzn25Nripar
	 ifZGuKCHZp03ngcCcong9r+EDPgv04Exh1UxS/wlUIdEnc7FKZpBG6ClIP2OM1VPE6
	 FOcFlzLw9MthLyBCBEJMkmZhDfjymvHm67U5N8H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wahl <steve.wahl@hpe.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/42] platform/x86: ISST: Remove 8 socket limit
Date: Thu,  1 Jun 2023 14:20:59 +0100
Message-Id: <20230601131937.265279817@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve Wahl <steve.wahl@hpe.com>

[ Upstream commit bbb320bfe2c3e9740fe89cfa0a7089b4e8bfc4ff ]

Stop restricting the PCI search to a range of PCI domains fed to
pci_get_domain_bus_and_slot().  Instead, use for_each_pci_dev() and
look at all PCI domains in one pass.

On systems with more than 8 sockets, this avoids error messages like
"Information: Invalid level, Can't get TDP control information at
specified levels on cpu 480" from the intel speed select utility.

Fixes: aa2ddd242572 ("platform/x86: ISST: Use numa node id for cpu pci dev mapping")
Signed-off-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230519160420.2588475-1-steve.wahl@hpe.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86/intel/speed_select_if/isst_if_common.c       | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index fd102678c75f6..f6b32d31c5110 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -294,14 +294,13 @@ struct isst_if_pkg_info {
 static struct isst_if_cpu_info *isst_cpu_info;
 static struct isst_if_pkg_info *isst_pkg_info;
 
-#define ISST_MAX_PCI_DOMAINS	8
-
 static struct pci_dev *_isst_if_get_pci_dev(int cpu, int bus_no, int dev, int fn)
 {
 	struct pci_dev *matched_pci_dev = NULL;
 	struct pci_dev *pci_dev = NULL;
+	struct pci_dev *_pci_dev = NULL;
 	int no_matches = 0, pkg_id;
-	int i, bus_number;
+	int bus_number;
 
 	if (bus_no < 0 || bus_no >= ISST_MAX_BUS_NUMBER || cpu < 0 ||
 	    cpu >= nr_cpu_ids || cpu >= num_possible_cpus())
@@ -313,12 +312,11 @@ static struct pci_dev *_isst_if_get_pci_dev(int cpu, int bus_no, int dev, int fn
 	if (bus_number < 0)
 		return NULL;
 
-	for (i = 0; i < ISST_MAX_PCI_DOMAINS; ++i) {
-		struct pci_dev *_pci_dev;
+	for_each_pci_dev(_pci_dev) {
 		int node;
 
-		_pci_dev = pci_get_domain_bus_and_slot(i, bus_number, PCI_DEVFN(dev, fn));
-		if (!_pci_dev)
+		if (_pci_dev->bus->number != bus_number ||
+		    _pci_dev->devfn != PCI_DEVFN(dev, fn))
 			continue;
 
 		++no_matches;
-- 
2.39.2



