Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3A8254863;
	Mon, 12 May 2025 17:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072711; cv=none; b=HouJ511R9A7RL2nL3a6a6ovJ3sewZtAHRU0CC97rhHn6TFKLYRdCGDoB8qBVBWquJwQsNjqK1+xGBhtuzyTQOwXGglyMABpPdwsbTerAQpM+7JIQSXfPqsM3EJNe8ozUPwUJZZavmdH9jzuFK/70J4PqsJsiF9RCNcgc3QXany4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072711; c=relaxed/simple;
	bh=LGKN7PqgaNOObztH/Q+NyIiTv/jurqC/Wr1/rfiVz34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSS9Z5xTTOupGlprbmySmlGxKIIwz7n2TJVxtQKdEO16IttCNAH2UDnSDjUNTxPHhzaTNWl7000cPi0mXdP2juZU7XMl9ARFZ8p0xKx0d2VVWLVqeK1aASHE3mrG+qiyvUWO1jaoxsmtYMtpkMTOWstakcbsw3PAG7dK4ho2MbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucLdh74h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucLdh74h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D06C4CEE7;
	Mon, 12 May 2025 17:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072711;
	bh=LGKN7PqgaNOObztH/Q+NyIiTv/jurqC/Wr1/rfiVz34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucLdh74hMtV5+7nc5b6pfI7jgY5DferNhZk+jz9K+qz4SqsTLHK3peXfnE967wr60
	 AC5TAAPDjpIA3OxCVTLt4pXZBWee3Pp3Bzz+irXv8cjvtfnnxmEG5D3cgMGysAMdxQ
	 TWi4hEoYdYyawIb4C5sCFkUPj+is3LVCMrCxPb1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 007/184] s390/pci: Fix missing check for zpci_create_device() error return
Date: Mon, 12 May 2025 19:43:28 +0200
Message-ID: <20250512172041.946497383@linuxfoundation.org>
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
@@ -422,6 +422,8 @@ static void __clp_add(struct clp_fh_list
 		return;
 	}
 	zdev = zpci_create_device(entry->fid, entry->fh, entry->config_state);
+	if (IS_ERR(zdev))
+		return;
 	list_add_tail(&zdev->entry, scan_list);
 }
 


