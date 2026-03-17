Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BC82116F6;
	Tue, 17 Mar 2026 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767555; cv=none; b=DClYfp/EX2LTprLKgdoP5ZH489u6IBwuc0eIUREZdA52XlrFRP5fIwDXymqm9JOeTOAfmQAxIghXr2q5EejYukNI/RiyC2riitF5iI0k/Ki56eAgXBVhbCa5m4ezqYhWoPHJLoLpnebK0RMYPO83vlC44L2SEpivDoTkba1zVuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767555; c=relaxed/simple;
	bh=3zhSDNsrH+60A3b5Vs+3RHnrfpsBKEvtHmQdqV2+pzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moLupi2nZDHgadRTTtMsTFVyVT+NNfJOgRLaXngyKpA/rroeQmJWOPLiUtU3v2a/zquz85TBz1HkjJdob/n+mKFCISH+04t57FPK9HcyEG8U5hFi8dihKeY61GrQhwQBl/rgDRcpGlmt98XIzxzIhkk8Gbk/kiAlt/biPfIL1UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4Gf3cIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4Gf3cIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA82C4CEF7;
	Tue, 17 Mar 2026 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767554;
	bh=3zhSDNsrH+60A3b5Vs+3RHnrfpsBKEvtHmQdqV2+pzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4Gf3cIm87SwU6x/gdFzWHadQ7MhLaHrVN628rMviIySX9lEXC8egT42F5px250tv
	 Ei89Xd8NTv2065psQaHptD1ZUpiuIuEj6hXxZjeuSAloYDCuJ4f0SneVbpt1uaHbdO
	 SteLFBbL1qLe5qmKZE5pes7ug6MHCgVBYPDE5vHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/333] usb: gadget: f_mass_storage: Fix potential integer overflow in check_command_size_in_blocks()
Date: Tue, 17 Mar 2026 17:32:12 +0100
Message-ID: <20260317163003.189661915@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit 8479891d1f04a8ce55366fe4ca361ccdb96f02e1 ]

The `check_command_size_in_blocks()` function calculates the data size
in bytes by left shifting `common->data_size_from_cmnd` by the block
size (`common->curlun->blkbits`). However, it does not validate whether
this shift operation will cause an integer overflow.

Initially, the block size is set up in `fsg_lun_open()` , and the
`common->data_size_from_cmnd` is set up in `do_scsi_command()`. During
initialization, there is no integer overflow check for the interaction
between two variables.

So if a malicious USB host sends a SCSI READ or WRITE command
requesting a large amount of data (`common->data_size_from_cmnd`), the
left shift operation can wrap around. This results in a truncated data
size, which can bypass boundary checks and potentially lead to memory
corruption or out-of-bounds accesses.

Fix this by using the check_shl_overflow() macro to safely perform the
shift and catch any overflows.

Fixes: 144974e7f9e3 ("usb: gadget: mass_storage: support multi-luns with different logic block size")
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260228104324.1696455-2-eeodqql09@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 94d478b6bcd3d..6f275c3d11ac5 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -180,6 +180,7 @@
 #include <linux/kthread.h>
 #include <linux/sched/signal.h>
 #include <linux/limits.h>
+#include <linux/overflow.h>
 #include <linux/pagemap.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
@@ -1853,8 +1854,15 @@ static int check_command_size_in_blocks(struct fsg_common *common,
 		int cmnd_size, enum data_direction data_dir,
 		unsigned int mask, int needs_medium, const char *name)
 {
-	if (common->curlun)
-		common->data_size_from_cmnd <<= common->curlun->blkbits;
+	if (common->curlun) {
+		if (check_shl_overflow(common->data_size_from_cmnd,
+				       common->curlun->blkbits,
+				       &common->data_size_from_cmnd)) {
+			common->phase_error = 1;
+			return -EINVAL;
+		}
+	}
+
 	return check_command(common, cmnd_size, data_dir,
 			mask, needs_medium, name);
 }
-- 
2.51.0



