Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548DB255E47;
	Mon, 12 May 2025 17:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072636; cv=none; b=oU75UviNDKOkTg+i+AGbK/9Yks0HF3/LNSZR1HrgWAEVFKg1YyXviLKK7puMKwsQsfsQrAIjBKbr2wg2tIkV6Fa4iWgTNuGYkz+FdTCtXgLuKmHY/0jSBUasnHhbKxAc+JVLMrYCY0/zWuoWjYfUDKBVvfYE6A9IZbAZctmFmuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072636; c=relaxed/simple;
	bh=PfHrR9XtXALv/u6CH7LIeY4Jqo3Sam8wwg2t44UlDWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqpMtgAaQb2Hv0Pj1dAXYNtUqmVizI2RQlfKYPlSc+yOPu7sG7Yzo1Zgnt3oYZbgpWoK5biwUuBp1uqHe5hS5h80vei1mQ/gxsOKB67yVaCyXYyzSUkG3JIhyRCrzw8i51oxQov1sa3b+IYGiaeL1XWhTHbCwoECtqYjWgyV8lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Unb0VKih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Unb0VKih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760F7C4CEE7;
	Mon, 12 May 2025 17:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072635;
	bh=PfHrR9XtXALv/u6CH7LIeY4Jqo3Sam8wwg2t44UlDWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Unb0VKihE9ppyNtLdDtISC4PsLMuiRoDCEqVcxCT1ObgcpZGaKOVO1tIkcVKwZrfD
	 B2EkLpZ04SqyxDanlWAEs32VwStd/pxzv55XJ+9rEt5xYLMmaevBL4ThJ3qk/MDVtS
	 fmWnP48HDDxzn3hTSgHmDIQi7dmVNac+53bFoXjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 010/184] s390/pci: Fix duplicate pci_dev_put() in disable_slot() when PF has child VFs
Date: Mon, 12 May 2025 19:43:31 +0200
Message-ID: <20250512172042.071519976@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


