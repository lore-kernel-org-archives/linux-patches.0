Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537DB221704;
	Tue, 26 Aug 2025 13:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213896; cv=none; b=DSLPo0SfJ3XN0zxEagDbfZrHFjrHs1//x+tDjBCLKrCOu0PlQz/PxPQWeKWW0dxjkbE/GwEacf0jtzZcYf2sZeC7WcV84gTgRk5eWTILO5m/FFjxhOOTdN5WAHUkyMN+XIPC+0ur9KaKFR5sLS8333JUHDHFwODL14KR/rK1+6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213896; c=relaxed/simple;
	bh=Pb6fEs0Rbz6GTdE+pgMRQo0073rrEIkR/IADinFYukM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieleSD35HcU2bUU2EohD/Y/ayhfNfH9mLhOJ9513RGISGjS4VJtkGGGjMtvaLHwxMyxdHNqhxXrtqYYF3PmerIc6MUCrp3utAOnyJEsRHymUEzVwWn5BGgJGx3AfFXd7/niiUQlCNgRDs6kP8CjXGZ4dG+KHOzDNnFqrosIyErI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toFMw5Ek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toFMw5Ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D860FC4CEF1;
	Tue, 26 Aug 2025 13:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213896;
	bh=Pb6fEs0Rbz6GTdE+pgMRQo0073rrEIkR/IADinFYukM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toFMw5Ek5C2bJrOGGQbp4HvoDT6ezrqN4i4hxqAS3wuSz9pKtjYg2m30wSiMT+wDs
	 9KCjUSI/az5aQZRYb/XcoPtjxSFPI9tOXzd0VyTxLHni3XPNFKAzSfi9GkVq5L1RsL
	 BKBfvI1xwfbfHdQqBgTSNByM29y/XwNMlhWQ0yB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5cd373521edd68bebcb3@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 521/587] comedi: pcl726: Prevent invalid irq number
Date: Tue, 26 Aug 2025 13:11:10 +0200
Message-ID: <20250826111006.250178700@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


