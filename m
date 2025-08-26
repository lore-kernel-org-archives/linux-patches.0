Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F1D2F83BA;
	Tue, 26 Aug 2025 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218504; cv=none; b=IgX8HWuALbxZ7yGo5brZqmi5AP0GHypAyxudod7NNIltOC0QxKKF7QXTri0PpUx98N6q1tmkDE9U9zl3ff1vh8Xy4wRjR2pcWO5sido0Uxsvxd7aopJ4cnCE33WBu918brXFaXrQjE3ayytkf1FGHhJPfTGsqe9ZA+O/F4um+uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218504; c=relaxed/simple;
	bh=6icj9BTYIC8kwqsxCOLC01tuAqZ0EE7gS8Fj7vrANG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSNkwzYknXskaxGIZL+1gmqjfUcoAYrOCZFnTuSN975k5nRqTNKmMVX1PqbY6OcXytLS3Z4P4voXVNYD5mCRrhz/rNYwnkjeaPPkb/eNI5y4D4NakUhxvIKpWB62jdYoziS6Z7LreFIXSSG0oBSrczh8yT2YiZa+ThJ+KFWDuKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Es26n7yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Es26n7yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB72C113D0;
	Tue, 26 Aug 2025 14:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218504;
	bh=6icj9BTYIC8kwqsxCOLC01tuAqZ0EE7gS8Fj7vrANG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Es26n7yqAf75hP7XW2hdVWJ3hgw6/xt3/A9hL9ybmdGKli0Qo8JK2OyYlGW6kLIMU
	 6aEr7nkrBf76b2DF2qQkhzopcfDuMKiKY+9COdDA+BBMzt/k1hfBPzyDTXSVfCXj6f
	 4ljVmWXkwqQuwxBWhg4qBKm1eJOVzRJ46TsM2K10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 026/403] comedi: aio_iiro_16: Fix bit shift out of bounds
Date: Tue, 26 Aug 2025 13:05:52 +0200
Message-ID: <20250826110906.509963248@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 66acb1586737a22dd7b78abc63213b1bcaa100e4 upstream.

When checking for a supported IRQ number, the following test is used:

	if ((1 << it->options[1]) & 0xdcfc) {

However, `it->options[i]` is an unchecked `int` value from userspace, so
the shift amount could be negative or out of bounds.  Fix the test by
requiring `it->options[1]` to be within bounds before proceeding with
the original test.  Valid `it->options[1]` values that select the IRQ
will be in the range [1,15]. The value 0 explicitly disables the use of
interrupts.

Fixes: ad7a370c8be4 ("staging: comedi: aio_iiro_16: add command support for change of state detection")
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250707134622.75403-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/aio_iiro_16.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -178,7 +178,8 @@ static int aio_iiro_16_attach(struct com
 	 * Digital input change of state interrupts are optionally supported
 	 * using IRQ 2-7, 10-12, 14, or 15.
 	 */
-	if ((1 << it->options[1]) & 0xdcfc) {
+	if (it->options[1] > 0 && it->options[1] < 16 &&
+	    (1 << it->options[1]) & 0xdcfc) {
 		ret = request_irq(it->options[1], aio_iiro_16_cos, 0,
 				  dev->board_name, dev);
 		if (ret == 0)


