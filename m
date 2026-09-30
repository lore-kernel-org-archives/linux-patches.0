Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132A7515961;
	Wed, 30 Sep 2026 17:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787869; cv=none; b=PiJ6mO8AADiGj9DhUu2CyWRVl+hMmY+XvXAZaeQJAQ7Xe03UhR8ZZAeQ6uD3qjQ0ZvhP6AMaMqC12x3+bzFEiJz7stkDFAbu6VVV7ouOmuNVowbYa2WTdC7Yn7shj0HvBTGIHfYl6icqnnIFKouLsmqF9ubBaQsMpdl3Kb3nqUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787869; c=relaxed/simple;
	bh=a6rXXDqwrIRc0mPKjQyxT+n5KTRh1C7CcCoVDD6gsuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhI/kX9zQffr1q5la3Xjr+Hfw2PucUWYirQ2n0n9cIODliD3D74HX7ez0X6aY7oP6YGidIrNWXy4wY8Fyrk3/panM4erBj00+uTD4fxEYD2O3D5JXewwz9PJOyObfV0ss2Db/NzuOaUKRZozztl8JZLphztH8GHhtum7ClZjCQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+o9Z5Sb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+o9Z5Sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4B31F00898;
	Wed, 30 Sep 2026 17:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787868;
	bh=xmYbdb/aI/WP3CDNFzTSr1N5KKEZugixVi3K7+hRu9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+o9Z5SbpUXBqUnxcTfdGHE14Dci0sH2qCS82HuDSah2caGq4iisre0X0/Wb2Xwm/
	 mQWVNGb3RTRFdFtT0qoAPEfis66XNe/cCMHNhuUB35NBdNbv9XAUu8oe1F9a2K7nXN
	 Ogo+qh1NvrPhJlykz5b1+RYgDw8qSfbDdzBO/ZB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.2 381/457] s390/pci: Dont report recovery success on skipped recovery
Date: Wed, 30 Sep 2026 17:28:06 +0200
Message-ID: <20260930152354.222627002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
@@ -190,6 +190,7 @@ static pci_ers_result_t zpci_event_attem
 	device_lock(&pdev->dev);
 	if (pdev->error_state == pci_channel_io_perm_failure) {
 		ers_res = PCI_ERS_RESULT_DISCONNECT;
+		status_str = "skipped (permanent failure)";
 		goto out_unlock;
 	}
 	pdev->error_state = pci_channel_io_frozen;


