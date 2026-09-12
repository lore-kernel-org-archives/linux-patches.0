Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462B1282F1B;
	Sat, 12 Sep 2026 07:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199062; cv=none; b=NbzauXr1dJ/MQfRSCI4nJ0a58Nmw8BUCR0ci9MTVXGQO6DcYWxQC0p6Uu9CqjscVM56EOWpnaM7vJkZhLPOWwU+Xk/v2aDBzExNmywRuKNvrQyYfeV/SonebeVoRAWRFHYk2vYnuf8uHBccv70j/HU5KxVd1bwoZWtUX1lcmYdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199062; c=relaxed/simple;
	bh=8Sf7cMgtwLfJTj33kstWXTh8EbNbSYkNdjz2jy49WCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpWq6DJU0ojut05IyJesRd3/DZjVi2FK8ZSZHHdNsBwF4Gt5NQsdANj1nKs2sA2n0/vx/yqisVeZH0hagm5ISnlI1vJnBkrnJk0GXoBHQoH+TfU7sb+phtxuDp9EHuxH19ZHte54qeE6rPhjwM8ZMtVc9vjFIL3sNpiIyLeOdhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fux9AGnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fux9AGnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A22E1F000FF;
	Sat, 12 Sep 2026 07:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199061;
	bh=Xs1Yw6NwfSJRkKp8c2YxEmXni7VQuGxLmhaCPUPAJ6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fux9AGnK9D1wPCXBveoUP7DDtYtaqhRv7QhqXNkPX4AqXkFKQpunXrN74t9+7tVGb
	 G9MxEwQPgh5x/mz24Ak+F2hJX6FN3tgO2Cbp6MWE2A9aQr4KdqtSpyOsjVF82TF2Uk
	 M+svxviXZJ3w2KJ3gAZqBK7LjGJaTEvljUGE8kWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0501/1815] misc: lan966x_pci: depopulate children on populate failure
Date: Sat, 12 Sep 2026 08:37:31 +0200
Message-ID: <20260912065700.654605080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit f6e2ed54db95286d9512b1cff38264e2f6299814 ]

lan966x_pci_probe() applies a device-tree overlay and then populates
platform children from the overlaid node. If
of_platform_default_populate() creates some children and then fails, the
current error path only unloads the overlay.

Depopulate the children before unloading the overlay on that failure
path, matching the remove path order.

Fixes: 185686beb464 ("misc: Add support for LAN966x PCI device")
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260623015248.22721-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lan966x_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lan966x_pci.c b/drivers/misc/lan966x_pci.c
index 0bb90c0943bf7..b0949c653e5ba 100644
--- a/drivers/misc/lan966x_pci.c
+++ b/drivers/misc/lan966x_pci.c
@@ -183,6 +183,7 @@ static int lan966x_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	return 0;
 
 err_unload_overlay:
+	of_platform_depopulate(dev);
 	lan966x_pci_unload_overlay(data);
 	return ret;
 }
-- 
2.53.0



