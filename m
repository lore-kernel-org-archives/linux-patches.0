Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355DB338F24;
	Tue, 26 Aug 2025 13:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215178; cv=none; b=YdDGPtwOCXAbrhU50M6ctzwL5mBTKXIzHiPUSHtf4x8+E7uki9plJqoVP4lRnPVmWXAZVIR3fH01rMshp3w9XwSf2pk12kKZHdh5T8GUcOT+V1LLF3nahaDcMvxp8AX6GCj6VaNUGw0AN0Q7eQ8dlRm/M8OQbzK7so0wibQei7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215178; c=relaxed/simple;
	bh=LyN+5I50+H5PXa2YP3nlyJKHj8TO1JRP4XO758X4edc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwH7bPRxsB2ZPZbwlNMS5dgMiyjJd3ljwHkrIPqrpZ1c54ykD4sn2Dd9ZUz3BoI+f0aTQTkXI2ZO9V1BgSRdX5mXqLF4hyD//BJO22sux3tjJBSSRHWPH/Et6EhN6r2/bWar/8FuYXiCEFvHmWA/LZ/9cugbcf3W8f7ZgqatPqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1AED9tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1AED9tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD10C113CF;
	Tue, 26 Aug 2025 13:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215178;
	bh=LyN+5I50+H5PXa2YP3nlyJKHj8TO1JRP4XO758X4edc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1AED9tw5dWAWJigvr8XK3D7HmHIcNm68ViZHwQqNO5iwH8eS6T8LZk2oGjMcv4Vp
	 /qa7zdJrZuZ9DWRNpj74XUjumh0m9jonj1fnH6761Gw2NLrYMlYYaVVADGq/tF+yI7
	 aXfqPREc3bWX2KaorVst28vt9+HTFuqvGpR34NeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5cd373521edd68bebcb3@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 415/482] comedi: pcl726: Prevent invalid irq number
Date: Tue, 26 Aug 2025 13:11:08 +0200
Message-ID: <20250826110941.078977766@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

commit 96cb948408b3adb69df7e451ba7da9d21f814d00 upstream.

The reproducer passed in an irq number(0x80008000) that was too large,
which triggered the oob.

Added an interrupt number check to prevent users from passing in an irq
number that was too large.

If `it->options[1]` is 31, then `1 << it->options[1]` is still invalid
because it shifts a 1-bit into the sign bit (which is UB in C).
Possible solutions include reducing the upper bound on the
`it->options[1]` value to 30 or lower, or using `1U << it->options[1]`.

The old code would just not attempt to request the IRQ if the
`options[1]` value were invalid.  And it would still configure the
device without interrupts even if the call to `request_irq` returned an
error.  So it would be better to combine this test with the test below.

Fixes: fff46207245c ("staging: comedi: pcl726: enable the interrupt support code")
Cc: stable <stable@kernel.org> # 5.13+
Reported-by: syzbot+5cd373521edd68bebcb3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5cd373521edd68bebcb3
Tested-by: syzbot+5cd373521edd68bebcb3@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/tencent_3C66983CC1369E962436264A50759176BF09@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/pcl726.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/comedi/drivers/pcl726.c
+++ b/drivers/comedi/drivers/pcl726.c
@@ -328,7 +328,8 @@ static int pcl726_attach(struct comedi_d
 	 * Hook up the external trigger source interrupt only if the
 	 * user config option is valid and the board supports interrupts.
 	 */
-	if (it->options[1] && (board->irq_mask & (1 << it->options[1]))) {
+	if (it->options[1] > 0 && it->options[1] < 16 &&
+	    (board->irq_mask & (1U << it->options[1]))) {
 		ret = request_irq(it->options[1], pcl726_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0) {


