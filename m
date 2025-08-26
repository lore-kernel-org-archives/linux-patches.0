Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A51534DCC0;
	Tue, 26 Aug 2025 14:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217218; cv=none; b=JcxgbAO5g3gRRVoFFTlewKzRgRrIrweA8lFiqQXR2/3wBwKCa1bPDVZDw5drATyC12J+5cvFRKWiY9mIDkpQRw4kq90XvftujK0rlBivTRBh8pTBFgo9DPnPGjiGIg0R/r6CqDT0qf0NRO4+3tT8lX2zqOmaMYUMwurIBkHD/N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217218; c=relaxed/simple;
	bh=t1v/k26CMo4WqvQyLcn+j72gwtPIENSjnrGk6/6bMfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0XzJJAPvDJEcqLtEPEYxOcFfMKJW8byAuUz/nH7LgS2SgcgIzVRu63U/5gZPmzHPPcdtm16PfRf2zh1n6JPwSwqfHJ30BPQrbCwfQ5so+VJ28IE1cw6g0nOaD0ZPJO6/c4uzHK/23W/XLxQhkbOomDwLK7SIi+gm//9gCU0EfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEPRFJ2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEPRFJ2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BE5C116D0;
	Tue, 26 Aug 2025 14:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217218;
	bh=t1v/k26CMo4WqvQyLcn+j72gwtPIENSjnrGk6/6bMfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEPRFJ2fd6P5bzeCpLZiu7ZgjGQrbPAhYVCNcaNkkwe0aBZuTjBik1oJP1jA2rl3n
	 hQKjfUYoiZaWTbcoyXyVOh03eoxC2hyEqXgwx619T9zX3dJEFMGGk1QWmmX7nQLZsC
	 wGQIlQEvAjaLLI3/iAyD299JeuJNoloOtJGocszw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 033/523] comedi: Fix initialization of data for instructions that write to subdevice
Date: Tue, 26 Aug 2025 13:04:03 +0200
Message-ID: <20250826110925.417635645@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 46d8c744136ce2454aa4c35c138cc06817f92b8e upstream.

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
---
 drivers/staging/comedi/comedi_fops.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1551,21 +1551,27 @@ static int do_insnlist_ioctl(struct come
 	}
 
 	for (i = 0; i < n_insns; ++i) {
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
@@ -1628,6 +1634,10 @@ static int do_insn_ioctl(struct comedi_d
 			ret = -EFAULT;
 			goto error;
 		}
+		if (insn->n < MIN_SAMPLES) {
+			memset(&data[insn->n], 0,
+			       (MIN_SAMPLES - insn->n) * sizeof(unsigned int));
+		}
 	}
 	ret = parse_insn(dev, insn, data, file);
 	if (ret < 0)


