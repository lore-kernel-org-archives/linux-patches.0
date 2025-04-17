Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5AD1A3178;
	Thu, 17 Apr 2025 18:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913727; cv=none; b=IogutPvZIBXHrdVopoMcX4pfHBcQm6qCvkUu+h373Jz90xXNxGr0uXZxJBVB+97rlr9uYpIua8KfMxKlhqJQvP+Ndg4B84TU+/CdVkteCJsOfkoUAQ6enycfYvnh3m0SmBaCWtbSKKz5DonJVA3JZF763KUupGmnmgIlBHtQTlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913727; c=relaxed/simple;
	bh=v24IT946we8cLvvr5e0bMh/koE7ulOSXkOfEh/qIDwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMSGceMuoLOobc55u5BRjAuXXDXe+IbdiwPiNKKuIembY0sgp1d4YO9kxZFz/IVvsm8QlMnulB/fbu0Wa09d60ebc8EVy2OlX4hXs77DaP5HH/G0Agr3zbLo6rJmXvhHfAXfySWDFFvSQ16SEp49wj3bQgauGmm8i06rEQuWmKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tinVHIro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tinVHIro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0993C4CEE4;
	Thu, 17 Apr 2025 18:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913727;
	bh=v24IT946we8cLvvr5e0bMh/koE7ulOSXkOfEh/qIDwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tinVHIro844fGE2zljZjuMmlfiYD7OZYrCpic0NlQAeqBp9Ayj0mPuyPKUVLUf8MN
	 X1egS3Gp/rv3Z9T9uGNRESZMASDd8KoayPslbpJTaOKt4fVoL8cCEU2vF0QZSKRqJG
	 WaAGyNojK0kmBbr6sIx61Tc1UV/BHkF7VqQWvONs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.14 434/449] s390/pci: Fix zpci_bus_is_isolated_vf() for non-VFs
Date: Thu, 17 Apr 2025 19:52:02 +0200
Message-ID: <20250417175135.768555448@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

commit 8691abd3afaadd816a298503ec1a759df1305d2e upstream.

For non-VFs, zpci_bus_is_isolated_vf() should return false because they
aren't VFs. While zpci_iov_find_parent_pf() specifically checks if
a function is a VF, it then simply returns that there is no parent. The
simplistic check for a parent then leads to these functions being
confused with isolated VFs and isolating them on their own domain even
if sibling PFs should share the domain.

Fix this by explicitly checking if a function is not a VF. Note also
that at this point the case where RIDs are ignored is already handled
and in this case all PCI functions get isolated by being detected in
zpci_bus_is_multifunction_root().

Cc: stable@vger.kernel.org
Fixes: 2844ddbd540f ("s390/pci: Fix handling of isolated VFs")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_bus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -335,6 +335,9 @@ static bool zpci_bus_is_isolated_vf(stru
 {
 	struct pci_dev *pdev;
 
+	if (!zdev->vfn)
+		return false;
+
 	pdev = zpci_iov_find_parent_pf(zbus, zdev);
 	if (!pdev)
 		return true;


