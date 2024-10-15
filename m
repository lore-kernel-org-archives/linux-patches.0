Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670411B3936;
	Tue, 15 Oct 2024 20:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729022947; cv=none; b=bxO1Jxh5Abuyr1Jh57qRLg6LUaKKkH1d9qFI/Ofu4SxDhqOYSNpajkqdptImIMd3pF0r3YPFrjbTpR8UjHWK63faU9Mngul5B0ArdEHcasHsPM8gwXTn01L4vxRVAdlvtc/IughPiyTuxCC6vgOU3JjGYhPNWSsrvNqRouoxdOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729022947; c=relaxed/simple;
	bh=yOK+c3AkDCJtLcWfWWwZThk3SidCyjv2F09akPi0dDQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Q3my4vwwqeENAjw7Oaklp7/RbMFe8CEbMJqgfQEMyeQhvfmw18hQ7EknuElaQbXZLNpzrdWokmRF4osM2g1b8mg2Db+DwkapznTnD5PxxXqGVRN7eItB2XLr/LCrTJxueasTwPfFLM/tloI5AqFW5AQ5KpRIu8V2ERSGIV/CGUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AO6KPsrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AO6KPsrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92492C4CEC6;
	Tue, 15 Oct 2024 20:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729022946;
	bh=yOK+c3AkDCJtLcWfWWwZThk3SidCyjv2F09akPi0dDQ=;
	h=From:Date:Subject:To:Cc:From;
	b=AO6KPsrVhhx372QCXY93AxJSBx5E+Ql2F+YLwWAwVb6Lhrfy5bVT6FsGutt3avCos
	 KcPYnb7bO2dY52KTkntP/W5oLnY43rhPwoXtoMA/Y7oKvIsJznlxsbNPXaRNUWubXn
	 RuLAPUpQjejEYhH7K4tZtq8HVkFlUek3YaPEcDzG6cjfxBy9Y2oMYdkQosjbfYqYAC
	 sw/PWGrEeEyFaZs/RLhVUOCIFr/U1N29DN/1viFD3M5lRBp44KEudr3EEOWObVaxw7
	 WoDoyWaWt/Jl8/6w67npxvRBSizEIq8XmgBVIdARGlYAWEoVzIv5X1HzbPRBlabHHf
	 Oa/0poeEziKAA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 15 Oct 2024 13:09:02 -0700
Subject: [PATCH] staging: gpid: fmh: Drop residue from
 fmh_gpid_fifo_read_countable()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241015-staging-gpib-fmh-fix-residue-used-uninitialized-v1-1-23ef05b099da@kernel.org>
X-B4-Tracking: v=1; b=H4sIAN3LDmcC/x3NwQrCMBCE4Vcpe3ahCVrUVxEPSbNJBzSWbFOkp
 e9u8Pgd/pmdVApE6d7tVGSF4pMbzKmjcXI5CSM0k+3t2fTmwrq4hJw4zfAc3xNHfLmIIlThqhK
 4ZmQscC9sTf7qozXhZodBqK3ORVrxf3w8j+MH4Tgn/4EAAAA=
X-Change-ID: 20241015-staging-gpib-fmh-fix-residue-used-uninitialized-b8bf21d9266e
To: Dave Penkler <dpenkler@gmail.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2652; i=nathan@kernel.org;
 h=from:subject:message-id; bh=yOK+c3AkDCJtLcWfWWwZThk3SidCyjv2F09akPi0dDQ=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOl8px894J9oUb27nO1mR8u5X/8easqtnDi9fZXpZ90vp
 w5dmFoo2lHKwiDGxSArpshS/Vj1uKHhnLOMN05NgpnDygQyhIGLUwAmwsbFyHDmdOb9Q7ce5vbI
 LQmz58pYm880t+XY88/pdjYPP5lp3HnM8Feo97H9l4iDubM4/p5fuMzg5qV5hxe+LBX0qjtm/sL
 T+gUzAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/staging/gpib/fmh_gpib/fmh_gpib.c:970:43: error: variable 'residue' is uninitialized when used here [-Werror,-Wuninitialized]
    970 |                                 (int)(*bytes_read), (int)length, (int)residue);
        |                                                                       ^~~~~~~

residue is never initialized in this function and it is not used outside
of an error print. Just remove it altogether, as it is likely not
necessary in this function, as this same exact statement in present in
fmh_gpib_dma_read().

Fixes: 8e4841a0888c ("staging: gpib: Add Frank Mori Hess FPGA PCI GPIB driver")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/staging/gpib/fmh_gpib/fmh_gpib.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gpib/fmh_gpib/fmh_gpib.c b/drivers/staging/gpib/fmh_gpib/fmh_gpib.c
index 07c75ba8df7c53041e3cf013bb769677ac205381..0e27b3ef1a1df217b05de710412a683d5d381a25 100644
--- a/drivers/staging/gpib/fmh_gpib/fmh_gpib.c
+++ b/drivers/staging/gpib/fmh_gpib/fmh_gpib.c
@@ -922,7 +922,6 @@ static int fmh_gpib_fifo_read_countable(gpib_board_t *board, uint8_t *buffer,
 	struct fmh_priv *e_priv = board->private_data;
 	struct nec7210_priv *nec_priv = &e_priv->nec7210_priv;
 	int retval = 0;
-	unsigned int residue;
 
 	//	printk("%s: enter, bus_address=0x%x, length=%i\n", __FUNCTION__,
 	// (unsigned)bus_address,
@@ -966,8 +965,8 @@ static int fmh_gpib_fifo_read_countable(gpib_board_t *board, uint8_t *buffer,
 		unsigned int data_value;
 
 		if ((*bytes_read) >= length) {
-			dev_err(board->dev, "unexpected extra bytes in rx fifo, discarding!  bytes_read=%d length=%d residue=%d\n",
-				(int)(*bytes_read), (int)length, (int)residue);
+			dev_err(board->dev, "unexpected extra bytes in rx fifo, discarding!  bytes_read=%d length=%d\n",
+				(int)(*bytes_read), (int)length);
 			break;
 		}
 		data_value = fifos_read(e_priv, FIFO_DATA_REG);
@@ -976,8 +975,8 @@ static int fmh_gpib_fifo_read_countable(gpib_board_t *board, uint8_t *buffer,
 			*end = 1;
 	}
 
-//	printk("\tbytes_read=%i, residue=%i, end=%i, retval=%i, wait_retval=%i\n",
-//		   *bytes_read, residue, *end, retval, wait_retval);
+//	printk("\tbytes_read=%i, end=%i, retval=%i, wait_retval=%i\n",
+//		   *bytes_read, *end, retval, wait_retval);
 
 	return retval;
 }

---
base-commit: e0eb7cc4d70d672cf9344916aba58136fd6e495e
change-id: 20241015-staging-gpib-fmh-fix-residue-used-uninitialized-b8bf21d9266e

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

