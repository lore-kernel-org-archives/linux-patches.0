Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DA413C3F2;
	Tue, 26 Aug 2025 14:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219299; cv=none; b=JschTl12EpHj1Qc7B7zxNU7v3rIbvtaz3G0chNjSY535Npk1sJk6nHUBSNNmvGgeKNQtojNcYen0PzR5UJ6VHdFtMH2t7sa4NW+9hkn8AswNBJpby5kG+j+l+TruSRLm1iZMVFKuIw72qZqEXHe8Wek6e2NOJpHrV5/g3Oaf9pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219299; c=relaxed/simple;
	bh=2oMM552oD3avaM71C9/A69GgI8qVXQvnPmCUqONu1b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBMTQxYqQeYzlPWexu4QYeGjmp2Vi5vbK4RkvxpaJ38lDdm4rp498OJcYERDQurMsolJeYL0O8mh32mQHdka1yOolctlqtlqTX03T9R/oeYbxCobGP+2PUh6xQiU3o5csTYsAs+ZfYC2pLwL6fgQrTUVSuEXwXmfioaERjyvPkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V35JHJGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V35JHJGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2758AC4CEF1;
	Tue, 26 Aug 2025 14:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219299;
	bh=2oMM552oD3avaM71C9/A69GgI8qVXQvnPmCUqONu1b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V35JHJGneU7FcWk72dzgLsANy9jPAojyIBzaLTgAIiRX1/AZaKB569IFEl+bihuVz
	 HT75FMnMgpM41D+Vt9g98pXxpzuJhHI8RuLeowhZHPZSgW9hn86HBWIYHJuiM1wLei
	 0Z7uUQNafICijH6D9d68ouyFyjdIh7Ii9XwJb1ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 329/403] comedi: Fix initialization of data for instructions that write to subdevice
Date: Tue, 26 Aug 2025 13:10:55 +0200
Message-ID: <20250826110915.919222653@linuxfoundation.org>
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

[ Upstream commit 46d8c744136ce2454aa4c35c138cc06817f92b8e ]

Some Comedi subdevice instruction handlers are known to access
instruction data elements beyond the first `insn->n` elements in some
cases.  The `do_insn_ioctl()` and `do_insnlist_ioctl()` functions
allocate at least `MIN_SAMPLES` (16) data elements to deal with this,
but they do not initialize all of that.  For Comedi instruction codes
that write to the subdevice, the first `insn->n` data elements are
copied from user-space, but the remaining elements are left
uninitialized.  That could be a problem if the subdevice instruction
handler reads the uninitialized data.  Ensure that the first
`MIN_SAMPLES` elements are initialized before calling these instruction
handlers, filling the uncopied elements with 0.  For
`do_insnlist_ioctl()`, the same data buffer elements are used for
handling a list of instructions, so ensure the first `MIN_SAMPLES`
elements are initialized for each instruction that writes to the
subdevice.

Fixes: ed9eccbe8970 ("Staging: add comedi core")
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250707161439.88385-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Reworked for before commit bac42fb21259 ("comedi: get rid of compat_alloc_user_space() mess in COMEDI_CMD{,TEST} compat") ]
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: Fixed a patch application error due to fixing up the wrong commit.
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedi_fops.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1584,21 +1584,27 @@ static int do_insnlist_ioctl(struct come
 	}
 
 	for (i = 0; i < insnlist.n_insns; ++i) {
+		unsigned int n = insns[i].n;
+
 		if (insns[i].insn & INSN_MASK_WRITE) {
 			if (copy_from_user(data, insns[i].data,
-					   insns[i].n * sizeof(unsigned int))) {
+					   n * sizeof(unsigned int))) {
 				dev_dbg(dev->class_dev,
 					"copy_from_user failed\n");
 				ret = -EFAULT;
 				goto error;
 			}
+			if (n < MIN_SAMPLES) {
+				memset(&data[n], 0, (MIN_SAMPLES - n) *
+						    sizeof(unsigned int));
+			}
 		}
 		ret = parse_insn(dev, insns + i, data, file);
 		if (ret < 0)
 			goto error;
 		if (insns[i].insn & INSN_MASK_READ) {
 			if (copy_to_user(insns[i].data, data,
-					 insns[i].n * sizeof(unsigned int))) {
+					 n * sizeof(unsigned int))) {
 				dev_dbg(dev->class_dev,
 					"copy_to_user failed\n");
 				ret = -EFAULT;
@@ -1665,6 +1671,10 @@ static int do_insn_ioctl(struct comedi_d
 			ret = -EFAULT;
 			goto error;
 		}
+		if (insn.n < MIN_SAMPLES) {
+			memset(&data[insn.n], 0,
+			       (MIN_SAMPLES - insn.n) * sizeof(unsigned int));
+		}
 	}
 	ret = parse_insn(dev, &insn, data, file);
 	if (ret < 0)


