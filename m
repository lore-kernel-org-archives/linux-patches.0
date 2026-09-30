Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507B751D503;
	Wed, 30 Sep 2026 18:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793595; cv=none; b=SRmsMUtC1DfZc7W2sB1ANQ3TX1BVT9E22zW4AuGq4KT1JPILsdCZi2Rs/z/Iqug3U8MbpK08lFH+bV6e2RKQtDfIoWhbtrPy/KbQeQuJCt57yF4nVN7auEcA7cheZh+u5MpNhzJpExcJ9WSmXT8aofGTtLmzc4BRmy5tdBdDTvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793595; c=relaxed/simple;
	bh=D75/QrJhnq6MbUFxz8vXFQsTOr+ZZPo0VvBbzv7rHZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leYoZC50xOGc+v3fS3maj/Q3Eyp1x0QMb5SmkJPhZmyrTWKSLONDepHWxU03fySFgAdFx49JxtP+/6sVE7KoWQYKHupKJ4fmSSNbyUCz0M1gHiyXkKWg2u5lNgeJZNq4+oCoxcXXVs7f9Tw5CcK/wsD7SS8egnCy5/x3OQjmGfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGDmrND7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGDmrND7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9932C1F000FF;
	Wed, 30 Sep 2026 18:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793594;
	bh=n1VQ1LC2enurlKji8Nxtv6nemVIwUttDEG+AYNpji74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGDmrND7zee+484geD0EWsEdYXIDBUK6YZaMo41Ot+hzhR5KmCLsP+Uz5JFSlhtRG
	 mRHqNifgMFscIfXckWAt2xxBl5xg4QzB8qnojRHynWMkQpk5+O5D9F5rxl/h/wYUcp
	 1zc19a1sgfWDkkvbY/uGzr4bDIregCcwBRnAllT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 308/395] s390/pci: Dont report recovery success on skipped recovery
Date: Wed, 30 Sep 2026 17:29:30 +0200
Message-ID: <20260930152347.335900729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 3a43be7a1fd06a35cf9e621b88283b3b6e7d281c upstream.

When a PCI device is already in the permanent failure state, recovery is
skipped, but the SCLP recovery report still shows success. Fix this by
changing the status string to explicitly state that recovery was skipped
due to permanent failure.

Cc: stable@vger.kernel.org
Fixes: 4ec6054e7321 ("s390/pci: Report PCI error recovery results via SCLP")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_event.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -191,6 +191,7 @@ static pci_ers_result_t zpci_event_attem
 	device_lock(&pdev->dev);
 	if (pdev->error_state == pci_channel_io_perm_failure) {
 		ers_res = PCI_ERS_RESULT_DISCONNECT;
+		status_str = "skipped (permanent failure)";
 		goto out_unlock;
 	}
 	pdev->error_state = pci_channel_io_frozen;


