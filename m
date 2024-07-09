Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8C9156F2B;
	Tue,  9 Jul 2024 11:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523795; cv=none; b=Va8fNwJgNZIlI/5g079fYgPHrbmBMTGxaRChaa4IG4HnY7p8s2g0PB/K6eI9jur41gs9gKt/N/uNV+vnsn7IpwgGBBxIwmYZ7by0nz1LP6kaSJICP/Ya9AUhBV9HDuRzyM0bwITxm8L/QwnutwIEum4z/hzLknIR15+TMkaWhVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523795; c=relaxed/simple;
	bh=19Rd+ypZjkZPLB1YHFXOW4Kc0OuQYjG3qtIyOKoDyA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJDi3+M77gRL1uvjNLqdx40NuP9KrFNk8zgnWaivR2cPLmDEm62BW/jwkzNmfOSYE7WuEW4UE/wEwSINXLpijU5fEv4HqxdVqebtiyalEYZlE31F+IjJFFZDCG6t7J4ZyW5wRng8Dh7ejy3sG42woPGtqa3ndSbHRCK9XmiiIk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBbKzGcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBbKzGcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34688C3277B;
	Tue,  9 Jul 2024 11:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523795;
	bh=19Rd+ypZjkZPLB1YHFXOW4Kc0OuQYjG3qtIyOKoDyA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBbKzGcgTuXRJapJF2Fjj2RpKaXaUvTNhof5mOrzJGjlOvmB/pkbf8Rob4e7sUXxY
	 Qd/Wu5BwMtZVuYX52MwzxnW8V9QIiwO4Nbqkx9+jG4pmFI7U0YO/I4x7xGBF6nOqs6
	 3BA8Mh0E6yXTJX0s15LYfvtYNmAlMydRATOj25Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Steven Seeger <steven.seeger@flightsystems.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 110/139] mtd: rawnand: Fix the nand_read_data_op() early check
Date: Tue,  9 Jul 2024 13:10:10 +0200
Message-ID: <20240709110702.426430837@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 5da39530d19946f6241de84d1db69da2f5c61da7 upstream.

The nand_read_data_op() operation, which only consists in DATA_IN
cycles, is sadly not supported by all controllers despite being very
basic. The core, for some time, supposed all drivers would support
it. An improvement to this situation for supporting more constrained
controller added a check to verify if the operation was supported before
attempting it by running the function with the check_only boolean set
first, and then possibly falling back to another (possibly slightly less
optimized) alternative.

An even newer addition moved that check very early and probe time, in
order to perform the check only once. The content of the operation was
not so important, as long as the controller driver would tell whether
such operation on the NAND bus would be possible or not. In practice, no
buffer was provided (no fake buffer or whatever) as it is anyway not
relevant for the "check_only" condition. Unfortunately, early in the
function, there is an if statement verifying that the input parameters
are right for normal use, making the early check always unsuccessful.

Fixes: 9f820fc0651c ("mtd: rawnand: Check the data only read pattern only once")
Cc: stable@vger.kernel.org
Reported-by: Alexander Dahl <ada@thorsis.com>
Closes: https://lore.kernel.org/linux-mtd/20240306-shaky-bunion-d28b65ea97d7@thorsis.com/
Reported-by: Steven Seeger <steven.seeger@flightsystems.net>
Closes: https://lore.kernel.org/linux-mtd/DM6PR05MB4506554457CF95191A670BDEF7062@DM6PR05MB4506.namprd05.prod.outlook.com/
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Alexander Dahl <ada@thorsis.com>
Link: https://lore.kernel.org/linux-mtd/20240516131320.579822-2-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -2154,7 +2154,7 @@ EXPORT_SYMBOL_GPL(nand_reset_op);
 int nand_read_data_op(struct nand_chip *chip, void *buf, unsigned int len,
 		      bool force_8bit, bool check_only)
 {
-	if (!len || !buf)
+	if (!len || (!check_only && !buf))
 		return -EINVAL;
 
 	if (nand_has_exec_op(chip)) {


