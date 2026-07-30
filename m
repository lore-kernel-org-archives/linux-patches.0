Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA82E43E4B5;
	Thu, 30 Jul 2026 14:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422601; cv=none; b=aIU9UZxjnfv7xoJiRvIrYfSL2rmCw7lgieDtivlksIJABgDMcEh5lsTgxArIhBQbQbNCy0cKfgvhiIfb6bCSW29ydvwo9D9pAd7jJDf1ffTSxXy8KaFPSxSqhNUT7XkkA4ZTWEV8bPFAYkLCO6nT7OFDcwYBqUfojkoL8gO2bPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422601; c=relaxed/simple;
	bh=zICQAaGmhTyNcPH4QHudMSplweFyClJY1Pnvq2TNtqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeGjC95L0ZUz6YrfzXytIsb2hngqmpaQtVZwJBS143+u+FSujytKs74oW5HeXkxqWlcsa2mBHdFbpcxVVs2uZ8xdqm5u4z+omboAotxi33xgFrfGbPCDjSH3Cshu9xd/K1EB6VxE3creu4XT35ylnvlfvHE8yth5BeZRTAfzLBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSwMkttd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSwMkttd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BC91F000E9;
	Thu, 30 Jul 2026 14:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422600;
	bh=t3an7aTyYz1PU0Z1UEtlAAVC99tZW7iDfIG3isztA/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tSwMkttdPqgiY0bvHtqfgycd5jBje50NPJVb1uiOGZ8IMb8314iuEXQDDjW3TwAYN
	 yDXjYeFh+iMXxquQaUV9mcwtpEufDTE7MjycarhWNYzcqKFc3xchRqAu9X40ljDKIo
	 /mbIF7mYWuUQhgg7oA+5t/dTTvlBU8BWmnnmrMfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 493/744] media: marvell-cam: fix missing pci_disable_device() on remove
Date: Thu, 30 Jul 2026 16:12:46 +0200
Message-ID: <20260730141454.769593471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 033ff0420e4c9c240ae5523fff39770298efa964 upstream.

During manual code audit, we found that cafe_pci_probe() enables the
PCI device with pci_enable_device(), and its probe error path properly
calls pci_disable_device() on failure.

However, cafe_pci_remove() tears down the controller and frees the
driver data without disabling the PCI device, leaving the remove path
inconsistent with probe cleanup.

Add the missing pci_disable_device() call to cafe_pci_remove().

Fixes: abfa3df36c01 ("[media] marvell-cam: Separate out the Marvell camera core")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/marvell/cafe-driver.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/marvell/cafe-driver.c
+++ b/drivers/media/platform/marvell/cafe-driver.c
@@ -609,6 +609,7 @@ static void cafe_pci_remove(struct pci_d
 		return;
 	}
 	cafe_shutdown(cam);
+	pci_disable_device(pdev);
 	kfree(cam);
 }
 


