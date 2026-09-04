Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A42C3EC6AE;
	Fri,  4 Sep 2026 05:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500102; cv=none; b=Iz+A/1UC2XVocTihj1/zqdGJIlS2Paw36PqkjLQ5/jZYX4W02AGYLlyY3RIp5ZT3lbOisk25g3woaJLju9nu+uxorsINe7t+VqEs+HAdWUjR+jcGNAYKaSyby1H9DjOm16ly32MVpC+d9ODB6sJJlNtiLl1IS66MH5cFGv5kPmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500102; c=relaxed/simple;
	bh=qQmJf8GBcghcF3UF57B7ZuemVdYdKdEZUSY8vTCiLro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwP59BrQMKgmsX21fd3NT9P87ztRhPHTYXHu2q6p2/O1fMzq6yzDF7+JfcVSH2Mh5zsfBSR1wUhHjWRO6Z+AgjqCpHMLCsk1vmf+iRjIBFHextyVaBrNwthK7dJh7oqgxceS/UQUy6GbnjNLmLASh/YH/TYwn9OSY4a+4Y+C0G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkaRuE7n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkaRuE7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0711F00A3D;
	Fri,  4 Sep 2026 05:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500100;
	bh=bTs5AzzAeMvMdMuPYrfFurS+7vnMNGz+Yp6pF6AyKoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkaRuE7n6uHeNBZG3QAxGMu+744EU4axt0nwL38dhphEhqFuYIRkSKdRbsAET5dc6
	 weV8TjSYgPTutHDmckBTpeDGaoRsZivTGMdXkWF+B+g9KzaiFegUZ1hF9bxwL26Yzq
	 RAMCs+5i5LsCdHT9XrdIBnmSO9vk7ohc3uIGL8JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.2 634/713] mfd: sm501: Fix potential memory leaks during remove
Date: Fri,  4 Sep 2026 07:00:02 +0200
Message-ID: <20260904045818.041386543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 83feedd9d83c0c5199f98c72df0a6196b4aefb4d upstream.

The memory allocated for struct sm501_devdata in sm501_pci_probe() and
sm501_plat_probe() is not freed by the corresponding remove functions
sm501_pci_remove() and sm501_plat_remove(). Fix that by adding a call to
kfree().

Fixes: b6d6454fdb66 ("[PATCH] mfd: SM501 core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260720113836.73133-1-nihaal@cse.iitm.ac.in
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/sm501.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1627,6 +1627,7 @@ static void sm501_pci_remove(struct pci_
 	release_mem_region(sm->io_res->start, 0x100);
 
 	pci_disable_device(dev);
+	kfree(sm);
 }
 
 static void sm501_plat_remove(struct platform_device *dev)
@@ -1637,6 +1638,7 @@ static void sm501_plat_remove(struct pla
 	iounmap(sm->regs);
 
 	release_mem_region(sm->io_res->start, 0x100);
+	kfree(sm);
 }
 
 static const struct pci_device_id sm501_pci_tbl[] = {


