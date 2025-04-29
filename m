Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47067216605;
	Tue, 29 Apr 2025 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946994; cv=none; b=GS7s2fIaxTekphnl3+xZ2lzv9f67qS/WG6lNOQ06k6lfQ2fWtG8BNwH9aJ+k5bbcAr63OMCpP3os7yAZDIvn2CpUNPZodsdamDz+6c72/KIE+nGtP4IFVk0Mi32sa1UTxX+uEcOOYPqgWn0uQEsVxaH+OEgroydUfSIQnOipPDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946994; c=relaxed/simple;
	bh=N0SXPmlXWS+GgtJXsuDMKRFiroRd273mqOoiWFlr0VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tf0I6EXdBQ2/nFviG0DPbmgPZQahgiOZImVlbWzaM21GSDwoGrdafXXYuI1tFmBCnA/26ESQLpAjA1bJUrnw+KhzTbqLhCFb+EKiMSbcHwQgivu7ls+SDn9PLTUKh7V6GxmRNm9KM99g+uqF1wCI93JnelHke1WWXI4xveP7lh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ye93wT19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ye93wT19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D8AC4CEE3;
	Tue, 29 Apr 2025 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946994;
	bh=N0SXPmlXWS+GgtJXsuDMKRFiroRd273mqOoiWFlr0VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ye93wT19c+yjGtoHQYZoexXqYi3qgWvbcWF0/Nrec7MMpXM0sk/xWcUXjYQylSWa2
	 VLKu5/bFS/x9hJ2XQk+Xj06VwH3/Zqw3sA3s9yuQNTp5w5N+5boZl0m22xYZEUJmDj
	 wqXdyD84M2R6L17vhLPJrgroyEPk0SK8+JMCAMMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.10 096/286] PCI: Fix reference leak in pci_alloc_child_bus()
Date: Tue, 29 Apr 2025 18:40:00 +0200
Message-ID: <20250429161111.803522557@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 1f2768b6a3ee77a295106e3a5d68458064923ede upstream.

If device_register(&child->dev) fails, call put_device() to explicitly
release child->dev, per the comment at device_register().

Found by code review.

Link: https://lore.kernel.org/r/20250202062357.872971-1-make24@iscas.ac.cn
Fixes: 4f535093cf8f ("PCI: Put pci_dev in device tree as early as possible")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/probe.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1105,7 +1105,10 @@ static struct pci_bus *pci_alloc_child_b
 add_dev:
 	pci_set_bus_msi_domain(child);
 	ret = device_register(&child->dev);
-	WARN_ON(ret < 0);
+	if (WARN_ON(ret < 0)) {
+		put_device(&child->dev);
+		return NULL;
+	}
 
 	pcibios_add_bus(child);
 


