Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A991487CD;
	Thu, 12 Dec 2024 17:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023492; cv=none; b=P5ylxEezAv4SlH1ifl5Nxo1rRi4bIkwFqt4M0NkqHO/juzx7IQGfEEX9ww9IJFlJnBE6woiEkAMYsLIZuAk5Cd5a0bHdrgiPwwYl3fekIA3199zfyu1Y0PpqZLGc/IzDEoRUjROWH8eCuRdedljh/9TiqSus5a6vHIY/s/cSpIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023492; c=relaxed/simple;
	bh=wyw01ugeuRRun+NX/lfdbZqMLJDrcxrk1MXuka+nPJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipu0P/Wwvs/FkYh8VffXJJy5gkm0J8bHsUBXaYGckZVCQEod7mDFpU4OWIYiAi2ADzeiNB4NQsofpKCWiUsYyajX2vsdCVw24aL49BryzR8kX6mP+0/rYjqg5ZIgPGaMzro4Au8E09MuiAoZrqMJky3G1BmKuvpHe32Fk3QEc1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fONYVorT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fONYVorT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E451BC4CED0;
	Thu, 12 Dec 2024 17:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023492;
	bh=wyw01ugeuRRun+NX/lfdbZqMLJDrcxrk1MXuka+nPJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fONYVorTEv+2UQ5XjkKfN/xYWkglydfqveXZW+99s/mRLqGd4puBormgpWW51g5ys
	 dleTM+89SxVdN+Aj5e6Mjiukhb7cQvRLz8gp/rSgc6vJmjKKEAQEW9r74GSpv+r88t
	 0IPwHyNJZ8WROwYrK76vtJ8BUniViNfCtcF3r14U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 521/565] i3c: mipi-i3c-hci: Mask ring interrupts before ring stop request
Date: Thu, 12 Dec 2024 16:01:56 +0100
Message-ID: <20241212144332.389150992@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 6ca2738174e4ee44edb2ab2d86ce74f015a0cc32 ]

Bus cleanup path in DMA mode may trigger a RING_OP_STAT interrupt when
the ring is being stopped. Depending on timing between ring stop request
completion, interrupt handler removal and code execution this may lead
to a NULL pointer dereference in hci_dma_irq_handler() if it gets to run
after the io_data pointer is set to NULL in hci_dma_cleanup().

Prevent this my masking the ring interrupts before ring stop request.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20240920144432.62370-2-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index b9b6be1864384..61a5abac50dc0 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -174,10 +174,10 @@ static void hci_dma_cleanup(struct i3c_hci *hci)
 	for (i = 0; i < rings->total; i++) {
 		rh = &rings->headers[i];
 
+		rh_reg_write(INTR_SIGNAL_ENABLE, 0);
 		rh_reg_write(RING_CONTROL, 0);
 		rh_reg_write(CR_SETUP, 0);
 		rh_reg_write(IBI_SETUP, 0);
-		rh_reg_write(INTR_SIGNAL_ENABLE, 0);
 
 		if (rh->xfer)
 			dma_free_coherent(&hci->master.dev,
-- 
2.43.0



