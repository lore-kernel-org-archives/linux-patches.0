Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A332EAB69;
	Tue, 22 Jul 2025 14:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193428; cv=none; b=XE5dKZYxDGeXTRrWNcUwu9zjhbAZaz4WYp3iDR+kyyNtOizCGX9Gwd0EPqnmrJcv0SKwoJYtQQuBIn6g5UAg+Ad6J/HjEhSVfB/X99vZxcVzUpWgl3qd7sy1hjJLuzpuA7RTh+nFfhP0+n1JkTl/ecRn/oN5EJImsvPTgQKSERA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193428; c=relaxed/simple;
	bh=GEnaR5xp1Ic8yeFvj0ubqx7V4UP5RUZlyw6feZ51jmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bv4tsA3YNvQu8WZ02W8cnmPPAgb8FU8o+S738/g8GJ2po/svwNuk+yyxC2wQqQMdlKXu1MR7v80Criy5J0kzNLxi4mDfjTo6m46/UuZVZdr+N5Mn/WMhOUNBvsQVe+jV+WDFWgS4dAEHlR1PQJRU/9kZIw92VjEBLULMyIUqVs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ok4f4Ig1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ok4f4Ig1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF5BC4CEEB;
	Tue, 22 Jul 2025 14:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193427;
	bh=GEnaR5xp1Ic8yeFvj0ubqx7V4UP5RUZlyw6feZ51jmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ok4f4Ig1leBLnc5DkncUYGNxGprxaIx5B+NNHWgkhx1TSOtssUMrAI5Iv80hNIdhf
	 DeMuu898VmmymddjbdRlhMnDf9Ub8ssR5LJQPUH6SPygVHEZ13gHprHr+uH1b14Vo+
	 3E4pluA/98C0LMf8p7TQfXaW3inCGHmch+Axmg/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.15 089/187] comedi: aio_iiro_16: Fix bit shift out of bounds
Date: Tue, 22 Jul 2025 15:44:19 +0200
Message-ID: <20250722134349.043009092@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/aio_iiro_16.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/comedi/drivers/aio_iiro_16.c
+++ b/drivers/comedi/drivers/aio_iiro_16.c
@@ -177,7 +177,8 @@ static int aio_iiro_16_attach(struct com
 	 * Digital input change of state interrupts are optionally supported
 	 * using IRQ 2-7, 10-12, 14, or 15.
 	 */
-	if ((1 << it->options[1]) & 0xdcfc) {
+	if (it->options[1] > 0 && it->options[1] < 16 &&
+	    (1 << it->options[1]) & 0xdcfc) {
 		ret = request_irq(it->options[1], aio_iiro_16_cos, 0,
 				  dev->board_name, dev);
 		if (ret == 0)


