Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA2A2AE68;
	Tue, 26 Aug 2025 14:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219302; cv=none; b=CIqv6kUmUa34FcwPltJ0gKJrNzfOiSoUOvurZVcEWIEB5u+crmgRCu2CaR6rxtsCFH+B3CcSrAtU29Muj6AU7uhN+923Bm7Kbw2aGEgHOsub2oqU02NwA36cXh7eADQW9IgAMkuKqKfZAB4zvaezTnMPtfXjzZ2s7Jxb/XVRcPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219302; c=relaxed/simple;
	bh=lI9/RD0nY3sPtGNsRcd94Tb7+s+mv+SIRWvtLblFhXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdkQxuEaZWGiF/RGc5OyAsSAbekSftVsM6hJaQ3tJCgaZLjg2GGvdnUq3MYe66PsQapRvXN7Pi1HZqHfCbrEtZqfhm5/6giwq/+eO4NvNocZhgumHRnJIpMv6J4tUxs/w1GTgEPwC4dpcXC1WViko9nJafjLw/1UimkOyDp36Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dale/yu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dale/yu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DC1C4CEF1;
	Tue, 26 Aug 2025 14:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219302;
	bh=lI9/RD0nY3sPtGNsRcd94Tb7+s+mv+SIRWvtLblFhXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dale/yu4a/umz6Ou8aPdaKfCTR1HZCP5WsKQtyAftu8yA70BmkSCGQjU3WIuw9gAZ
	 Mw7/rGjIjQK3CSoyXO6+cQWwk0x64C2NZHFPG9Vx+Rf/L5ElyId/pKTPmR1uC22/Ae
	 uBZVILpqt9g+lcppFYrs9vwRJdhN/drxqli5N1H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d6995b62e5ac7d79557a@syzkaller.appspotmail.com,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 330/403] comedi: Fail COMEDI_INSNLIST ioctl if n_insns is too large
Date: Tue, 26 Aug 2025 13:10:56 +0200
Message-ID: <20250826110915.948695235@linuxfoundation.org>
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

[ Upstream commit 08ae4b20f5e82101d77326ecab9089e110f224cc ]

The handling of the `COMEDI_INSNLIST` ioctl allocates a kernel buffer to
hold the array of `struct comedi_insn`, getting the length from the
`n_insns` member of the `struct comedi_insnlist` supplied by the user.
The allocation will fail with a WARNING and a stack dump if it is too
large.

Avoid that by failing with an `-EINVAL` error if the supplied `n_insns`
value is unreasonable.

Define the limit on the `n_insns` value in the `MAX_INSNS` macro.  Set
this to the same value as `MAX_SAMPLES` (65536), which is the maximum
allowed sum of the values of the member `n` in the array of `struct
comedi_insn`, and sensible comedi instructions will have an `n` of at
least 1.

Reported-by: syzbot+d6995b62e5ac7d79557a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d6995b62e5ac7d79557a
Fixes: ed9eccbe8970 ("Staging: add comedi core")
Tested-by: Ian Abbott <abbotti@mev.co.uk>
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250704120405.83028-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Reworked for before commit bac42fb21259 ("comedi: get rid of compat_alloc_user_space() mess in COMEDI_CMD{,TEST} compat") ]
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: Fixed a build error due to applying a fixup to the wrong commit.
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedi_compat32.c |    3 +++
 drivers/staging/comedi/comedi_fops.c     |   13 +++++++++++++
 2 files changed, 16 insertions(+)

--- a/drivers/staging/comedi/comedi_compat32.c
+++ b/drivers/staging/comedi/comedi_compat32.c
@@ -360,6 +360,9 @@ static int compat_insnlist(struct file *
 	if (err)
 		return -EFAULT;
 
+	if (n_insns > 65536)	/* See MAX_INSNS in comedi_fops.c */
+		return -EINVAL;
+
 	/* Allocate user memory to copy insnlist and insns into. */
 	s = compat_alloc_user_space(offsetof(struct combined_insnlist,
 					     insn[n_insns]));
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1519,6 +1519,16 @@ out:
 	return ret;
 }
 
+#define MAX_INSNS   65536
+static int check_insnlist_len(struct comedi_device *dev, unsigned int n_insns)
+{
+	if (n_insns > MAX_INSNS) {
+		dev_dbg(dev->class_dev, "insnlist length too large\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /*
  * COMEDI_INSNLIST ioctl
  * synchronous instruction list
@@ -1551,6 +1561,9 @@ static int do_insnlist_ioctl(struct come
 	if (copy_from_user(&insnlist, arg, sizeof(insnlist)))
 		return -EFAULT;
 
+	ret = check_insnlist_len(dev, insnlist.n_insns);
+	if (ret)
+		return ret;
 	insns = kcalloc(insnlist.n_insns, sizeof(*insns), GFP_KERNEL);
 	if (!insns) {
 		ret = -ENOMEM;


