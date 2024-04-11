Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1151E48E;
	Thu, 11 Apr 2024 10:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832676; cv=none; b=gi/ZR0csjG9PmOeebubf+MOo+x+Blsacrwlg29gxbQ4Dw9RoDwOuetQgr4yvTeLMPw/sZp4FXxDWZBAFWYoc498RscqLebDkqWLrp6/0D6GtinqORZIfrC985k4G5CuVe0r2HwnUPBMmoWB8kxLRks32mMLNJxfhQKQhOYJwxH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832676; c=relaxed/simple;
	bh=cofsqJButqda6DprpQ1Vot88h1tmFzPe/ErbHTKcmXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiTeaSN5ulqeZ6hFtUpFMMZZN+ut1Z1/Wio/pLOlqKeWUQkQCTkRpFHJRFWGf/KD4gs6qLbG5wWXDKUTWsXn0AzRF3/aoiTE9cfN/R4kki8csyU21v9XhiOU8tQwKoGYE9za8JdiH60j/pb66wjuaSUkOdMV2VTWkdUHoKC6Q0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3KCKK2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3KCKK2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30953C433F1;
	Thu, 11 Apr 2024 10:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832676;
	bh=cofsqJButqda6DprpQ1Vot88h1tmFzPe/ErbHTKcmXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3KCKK2En5nGgq6YRMQXuI/qPnC/65cDsaRFWvRpqBkQg2SBwrNqsFd/1si56NpZ9
	 LZYe3DiOzHVmOjQbjBMAWY1/7I8Y9jUfJ8koPaIoEdMdNb0Tv9ur5ZipwOjhWQGx2u
	 /pjUP1FxcXgdlduNACqUiXah7F9aAiyQXiUFHpHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Fu <i@ibugone.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 44/57] drivers/nvme: Add quirks for device 126f:2262
Date: Thu, 11 Apr 2024 11:57:52 +0200
Message-ID: <20240411095409.322504043@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jiawei Fu (iBug) <i@ibugone.com>

[ Upstream commit e89086c43f0500bc7c4ce225495b73b8ce234c1f ]

This commit adds NVME_QUIRK_NO_DEEPEST_PS and NVME_QUIRK_BOGUS_NID for
device [126f:2262], which appears to be a generic VID:PID pair used for
many SSDs based on the Silicon Motion SM2262/SM2262EN controller.

Two of my SSDs with this VID:PID pair exhibit the same behavior:

  * They frequently have trouble exiting the deepest power state (5),
    resulting in the entire disk unresponsive.
    Verified by setting nvme_core.default_ps_max_latency_us=10000 and
    observing them behaving normally.
  * They produce all-zero nguid and eui64 with `nvme id-ns` command.

The offending products are:

  * HP SSD EX950 1TB
  * HIKVISION C2000Pro 2TB

Signed-off-by: Jiawei Fu <i@ibugone.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index fd20f3fdb1592..7bb74112fef37 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3339,6 +3339,9 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_VDEVICE(REDHAT, 0x0010),	/* Qemu emulated controller */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x126f, 0x2262),	/* Silicon Motion generic */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
+				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x126f, 0x2263),	/* Silicon Motion unidentified */
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST, },
 	{ PCI_DEVICE(0x1bb1, 0x0100),   /* Seagate Nytro Flash Storage */
-- 
2.43.0



