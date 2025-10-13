Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E56A3164AF;
	Mon, 13 Oct 2025 15:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370358; cv=none; b=D2vke6tjymdjy16yTYTjRpEJcWMLWJRaGq8XGqCI2AznQCv5YU0agEwoTOJ2U1NfnX4Ubf2mLgOqgFRfZjPYkaJ7wCFRQQAQq/+uRlufhvWxXnQj8/MrBv9W1LyIjNQFMox3DhYHGv66g6xAa3FOZKbMUrezcMTHZ3Of02O+glY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370358; c=relaxed/simple;
	bh=0XV5W3aFJxWIAw89MLT8Xp5Wfh+BffI2AIHFNfytcIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DljaJWw65VfCxi6zhzmpxHjp1EnBlwBXpYlHVR7XzQEFrJAnidqfQsi8tf8aSGVXJ2zCDAr5yfYjisIzZEYqf1sVyRUEpNTG0VF0HOJU1msphiUFi0wAdYGT6+SYePuZSpr/KRxH9WAeidrzZfDhR5cjPYLz66DcfTGFSUOeX1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8won5Q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8won5Q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92F8C19424;
	Mon, 13 Oct 2025 15:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370358;
	bh=0XV5W3aFJxWIAw89MLT8Xp5Wfh+BffI2AIHFNfytcIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8won5Q10Y27bRZbrra5U4ihpLfLYVHDWUErx7rdCZgo46f0RK8uYp46G0eYq2Bi5
	 cMZc/vmpdYuDvtDNKfd6vP9X6MHeatzfkIqGMmYuz5NwIhL+bpiRG5hn62LE2nlkHe
	 6ioDf38tArO4ncNtqpvn1jmEHRtd2oWvFpaG2/vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 6.17 561/563] usb: cdns3: cdnsp-pci: remove redundant pci_disable_device() call
Date: Mon, 13 Oct 2025 16:47:02 +0200
Message-ID: <20251013144431.627574710@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit e9c206324eeb213957a567a9d066bdeb355c7491 upstream.

The cdnsp-pci driver uses pcim_enable_device() to enable a PCI device,
which means the device will be automatically disabled on driver detach
through the managed device framework. The manual pci_disable_device()
call in the error path is therefore redundant.

Found via static anlaysis and this is similar to commit 99ca0b57e49f
("thermal: intel: int340x: processor: Fix warning during module unload").

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20250903141613.2535472-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-pci.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-pci.c
+++ b/drivers/usb/cdns3/cdnsp-pci.c
@@ -85,7 +85,7 @@ static int cdnsp_pci_probe(struct pci_de
 		cdnsp = kzalloc(sizeof(*cdnsp), GFP_KERNEL);
 		if (!cdnsp) {
 			ret = -ENOMEM;
-			goto disable_pci;
+			goto put_pci;
 		}
 	}
 
@@ -168,9 +168,6 @@ free_cdnsp:
 	if (!pci_is_enabled(func))
 		kfree(cdnsp);
 
-disable_pci:
-	pci_disable_device(pdev);
-
 put_pci:
 	pci_dev_put(func);
 


