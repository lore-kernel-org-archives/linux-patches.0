Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7A729345A;
	Mon, 12 May 2025 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071733; cv=none; b=tq0TKaXFAw2S2KwPlc2Ah6ORCQO1w1lPjIouq0RcPenV5LxJZ722lr7dyFT01cpQyR/G857MokjknbF+ZxSw/6fgT91AMJJTddpCVfFrWWjZj7lZiyZUiA0rfHsR96pwQGv16vpCrItSlH/OxLiEAIPZnA8Jvc7tQyuwl5RnI24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071733; c=relaxed/simple;
	bh=99xfVrzhU2HZnhYzvbLPc2or1TE+oe57Cmf+KazyPiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImQy8Tb4rR/PJM9OwVE90CnpOvZpzHhF0mgywmS9ESmoxeU9Me6if7chmKBMqJa/4F1us6eSDQCPYEmDCak+Gmx3tjkb4M1SVgDUUpfYDUUyPFSSqzOlNn4uVbDHuZF+j0UAJI1gdTe6VUv3rQqXXORz9LIPoG+93tf7/Qt43w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ul2hQGj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ul2hQGj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BE1C4CEE7;
	Mon, 12 May 2025 17:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071733;
	bh=99xfVrzhU2HZnhYzvbLPc2or1TE+oe57Cmf+KazyPiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ul2hQGj42qEQaOKoPFcA60i/0IQ4FbCLwU5Fny346OOXHkTg7RBInfCMglcD4O7Zs
	 LaoAmUlVeLH/qCa5FV2jXiJNN6S9CFjgBGHGt2vExGxaXgHnphW5/6AesiXXUrVU90
	 GOdTUGfePyseGrpfkh1Scq3XUQEZjxC4y6SVStjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.14 010/197] s390/pci: Fix duplicate pci_dev_put() in disable_slot() when PF has child VFs
Date: Mon, 12 May 2025 19:37:40 +0200
Message-ID: <20250512172044.766461079@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 05a2538f2b48500cf4e8a0a0ce76623cc5bafcf1 upstream.

With commit bcb5d6c76903 ("s390/pci: introduce lock to synchronize state
of zpci_dev's") the code to ignore power off of a PF that has child VFs
was changed from a direct return to a goto to the unlock and
pci_dev_put() section. The change however left the existing pci_dev_put()
untouched resulting in a doubple put. This can subsequently cause a use
after free if the struct pci_dev is released in an unexpected state.
Fix this by removing the extra pci_dev_put().

Cc: stable@vger.kernel.org
Fixes: bcb5d6c76903 ("s390/pci: introduce lock to synchronize state of zpci_dev's")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/hotplug/s390_pci_hpc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pci/hotplug/s390_pci_hpc.c
+++ b/drivers/pci/hotplug/s390_pci_hpc.c
@@ -59,7 +59,6 @@ static int disable_slot(struct hotplug_s
 
 	pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
 	if (pdev && pci_num_vf(pdev)) {
-		pci_dev_put(pdev);
 		rc = -EBUSY;
 		goto out;
 	}


