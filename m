Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EB2433A8;
	Tue, 22 Jul 2025 13:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192070; cv=none; b=R0I+uqXZ20Aker2EbuFOM1KdiMgoliE1RvO5jo0x9z/Dtm+UkYeH1KPpL0f2wtQsZF36cmR3O9+NLs6mDlAUYqW5XQFujSyNGzqpKHaUlv/DJCEvTEY557NoKH6F/t5RjcfFcnwJeLa/ylAbgG+0mK767GjAP72L+2reqSjRyJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192070; c=relaxed/simple;
	bh=KC+4gWqovkxVglkZOsPumxvBN4LqtloBOz3xLWY4gu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4kBY3WB14fk+sm02+9OGO70NgG7F1o2/tuc01o5lWvxW6Nab4DyCZi9JxBTFUgWU9xcPy0u1kQQBWeufwpvQw5GDmt4yDxeOa/BKMKRYtfQVWg+2gJVEkk46MqhbB22uEndz+AZ62/Rp9HofNgpsuHU0Ia4URSSEq/5AVkNhG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmhIaPDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmhIaPDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12506C4CEEB;
	Tue, 22 Jul 2025 13:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192070;
	bh=KC+4gWqovkxVglkZOsPumxvBN4LqtloBOz3xLWY4gu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmhIaPDS1hXcYHEtshu7m9oxtGPp5BNthJQLH1NfbXwlhqHMwxppS1iqxmtOdeBJY
	 w/C+j5XYabPu8SH4eYt3EE3DNG4BqViGVOtDvYwY7zrDmWLQ0t9sn8eJ6jP/qiMF3+
	 /qlV8dCl0zM4PM8qGndjX1kGqnUm9KZgdUUeb4gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.1 35/79] comedi: aio_iiro_16: Fix bit shift out of bounds
Date: Tue, 22 Jul 2025 15:44:31 +0200
Message-ID: <20250722134329.659119976@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


