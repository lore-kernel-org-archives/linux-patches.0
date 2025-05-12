Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FFD296D3A;
	Mon, 12 May 2025 17:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071806; cv=none; b=GfEV0kAj5feHL+NXoHtIQ22AM37VxBxUswbNBEaL5guB1nD3i7A5Deo3XOo7ZDttL6InRhE6fc4hl2xK7NfwnWvONVXnHLvhkmvumAmTisKueAMZVk+gZYc/Thc/nBKedLoJ+a0kYbVPvGxirWkCye0zromSgQL4ua2Ysf2yw5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071806; c=relaxed/simple;
	bh=+83AhmwS+im0Zx0MLGPfyXL5Vlq6aQjILc1abAKQ8BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQnEOcmwiBwtdI22IxCj6SSX8UwtlrFh71GpDjWtnyTslmyWZGh3sWeOKMKYoq1XTNUaL+etFS5/eWpCTFxvvEo5MbbnXVrPpwxfVT6kvdsZsWK1aVsfVHjRgtHTD5zjh/8w387g76cB364i8BU+ZN8CIwoQqFC5VqNy9zRny3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wts5UjF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wts5UjF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DBBC4CEE7;
	Mon, 12 May 2025 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071806;
	bh=+83AhmwS+im0Zx0MLGPfyXL5Vlq6aQjILc1abAKQ8BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wts5UjF+ZVgzBvObV2nKqKUBRstYMD8F3hxxNxQvDilImyWJ467/+YH2iZAj0C1y0
	 KwI46bYQ0f2Fa1FqpUmO3oXnZhPykVdF2I2ksxFuIHuEKLyQnBlMWjdagzo/c7+bF4
	 09P78VdTYXoT9fHtjdFQe2xP8uW5c7UTbRzmXBps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.14 007/197] s390/pci: Fix missing check for zpci_create_device() error return
Date: Mon, 12 May 2025 19:37:37 +0200
Message-ID: <20250512172044.645129400@linuxfoundation.org>
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

commit 42420c50c68f3e95e90de2479464f420602229fc upstream.

The zpci_create_device() function returns an error pointer that needs to
be checked before dereferencing it as a struct zpci_dev pointer. Add the
missing check in __clp_add() where it was missed when adding the
scan_list in the fixed commit. Simply not adding the device to the scan
list results in the previous behavior.

Cc: stable@vger.kernel.org
Fixes: 0467cdde8c43 ("s390/pci: Sort PCI functions prior to creating virtual busses")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_clp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -427,6 +427,8 @@ static void __clp_add(struct clp_fh_list
 		return;
 	}
 	zdev = zpci_create_device(entry->fid, entry->fh, entry->config_state);
+	if (IS_ERR(zdev))
+		return;
 	list_add_tail(&zdev->entry, scan_list);
 }
 


