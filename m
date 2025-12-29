Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E399B33066C;
	Mon, 29 Dec 2025 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025781; cv=none; b=ZpctWXc0E47L8pRSPaJSrPDdBSC6xqyH5aktSjcVDbgK7ZMf7Gv/yRyYMrIxghPifkF9WzyQ/zQeRr5C6qIjyNTuU9MozNfBd0m2My7NB/mMZv4CP8/TuafQYpq+UyZHJHrchLunBXpBA6T5nsNTUx9z23HJ1z4wcr4LTc1WCLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025781; c=relaxed/simple;
	bh=YHCuyXfDXprSuYgLOmFelWTUFUahzQnk6BbMsLnpTEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbgKG4Buu+VfkvloURVhwoXt0bQ9IWJjE6J8zc+MkHGwm/wLFFMkpxOnZlxhGPFFpFblVZsCKiLVaPEJUhJfhrWaKfi/+fjjd/cTPcnVzYOdKaV+PTNEzFRSB46rjoB/U/k6kb+QOgcmmx45W7a+N8IeSq4KC6YrNfhZHs4ByDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJGa131k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJGa131k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D937C4CEF7;
	Mon, 29 Dec 2025 16:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025780;
	bh=YHCuyXfDXprSuYgLOmFelWTUFUahzQnk6BbMsLnpTEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJGa131kxX3ahSA7IDsaORUEPFMgEyDurjuj6hMmlsR/zr5flg2HB1p1xJOVGg/zr
	 HZlgqJf6PrXRYvpNDRNouOaul+ZwOBVf8w3qlyvEdbqULJ/S6Br0+HW4FtLgtcB1Ef
	 bRmdcVV/EXARVKJCjL/RjwSHMncwauXf6FWohfdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 334/430] parisc: Do not reprogram affinitiy on ASP chip
Date: Mon, 29 Dec 2025 17:12:16 +0100
Message-ID: <20251229160736.617967301@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit dca7da244349eef4d78527cafc0bf80816b261f5 upstream.

The ASP chip is a very old variant of the GSP chip and is used e.g. in
HP 730 workstations. When trying to reprogram the affinity it will crash
with a HPMC as the relevant registers don't seem to be at the usual
location.  Let's avoid the crash by checking the sversion. Also note,
that reprogramming isn't necessary either, as the HP730 is a just a
single-CPU machine.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/gsc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -154,7 +154,9 @@ static int gsc_set_affinity_irq(struct i
 	gsc_dev->eim = ((u32) gsc_dev->gsc_irq.txn_addr) | gsc_dev->gsc_irq.txn_data;
 
 	/* switch IRQ's for devices below LASI/WAX to other CPU */
-	gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
+	/* ASP chip (svers 0x70) does not support reprogramming */
+	if (gsc_dev->gsc->id.sversion != 0x70)
+		gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
 
 	irq_data_update_effective_affinity(d, &tmask);
 


