Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAE5386562;
	Sat, 12 Sep 2026 16:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230220; cv=none; b=myZzbydUYoAKd/q1UTIOV5wb2kFwE3na/ZNRvFgH/BSlnbEUTwke71L1RgZoEOu1TbXO94i7aXbA7AlDdLwBGBUirWi1kf8SCcHznh8SwvHu+r0wkwvvbib9rXBEQT+bUeDsI6s6H2h3FskP7f5QNoL6vYxw4cPWkzgPXy4T/58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230220; c=relaxed/simple;
	bh=CCNoEXtYf5tNqAxeU8IUB3ZB7dfKkfKkfSmYQ9wseW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQe0o38DJ4FR6zUN3HENREb92jTOHyl/CLy2u5TM/RXQn2GKwfWxNYlBw5MvewUnJV6vgoatC6mF2keykAV0lza9bU/QZMkna4URANdRdliSFFoyk1s91Q5+NbWeAC3qDFUDm0oO8mnsAOUwPyXjYF4IbZQBs00HdwPaNSyqbH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ze11i3o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ze11i3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482541F000FF;
	Sat, 12 Sep 2026 16:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230219;
	bh=U2XcmN7qPJVExvsYl5Or2DDLwmyM5cf+VjuQ/W5w9lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ze11i3oY52KWpM3VQWmycwT3K4HgGzCR9JzRinxOhtBV0tS07JUvWT9v0NsQgwVu
	 KBAgb85ZBsvQ2bwaIb+R+xF1qod0v3tXZwFI0SYOZFfUAnxuxoXYcJH8K22nDtKZmc
	 J9zfslDlI59IIXsywA+oqr5NFi3vR1Bxb5v9FsMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex@shazbot.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0750/1191] bus: mhi: host: Flush the posted write after writing to MHI_SOC_RESET_REQ_OFFSET
Date: Sat, 12 Sep 2026 08:57:58 +0200
Message-ID: <20260912065605.126146070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 24f4423cbc89548def2b05ae86de6175086dbf94 ]

mhi_soc_reset() tries to reset the device by writing to the
MHI_SOC_RESET_REQ_OFFSET register. But it doesn't do a read-back to ensure
that the write gets flushed to the device before returning to the caller.

This may lead to the delay (if implemented) on the caller to be
insufficient, if the posted write doesn't reach the device before the
delay.

So add a read-back after writing to the MHI_SOC_RESET_REQ_OFFSET register.

Fixes: b5a8d233a588 ("bus: mhi: core: Add device hardware reset support")
Reported-by: Alex Williamson <alex@shazbot.org>
Closes: https://lore.kernel.org/linux-pci/20260622160822.09350246@shazbot.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260623145134.43976-1-manivannan.sadhasivam@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/bus/mhi/host/main.c b/drivers/bus/mhi/host/main.c
index 3136c68af713b..9568097c42f2d 100644
--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -168,6 +168,9 @@ EXPORT_SYMBOL_GPL(mhi_get_mhi_state);
 
 void mhi_soc_reset(struct mhi_controller *mhi_cntrl)
 {
+	int __maybe_unused ret;
+	u32 tmp;
+
 	if (mhi_cntrl->reset) {
 		mhi_cntrl->reset(mhi_cntrl);
 		return;
@@ -176,6 +179,9 @@ void mhi_soc_reset(struct mhi_controller *mhi_cntrl)
 	/* Generic MHI SoC reset */
 	mhi_write_reg(mhi_cntrl, mhi_cntrl->regs, MHI_SOC_RESET_REQ_OFFSET,
 		      MHI_SOC_RESET_REQ);
+	/* Flush the posted write to the device (ignore return value) */
+	ret = mhi_read_reg(mhi_cntrl, mhi_cntrl->regs, MHI_SOC_RESET_REQ_OFFSET,
+			   &tmp);
 }
 EXPORT_SYMBOL_GPL(mhi_soc_reset);
 
-- 
2.53.0



