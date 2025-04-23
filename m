Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F84285414;
	Wed, 23 Apr 2025 15:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420903; cv=none; b=Ep4GGXR5G7DTQxxYV8JID2ZxVPO4nieyF0HWkYyyvMkt+GbQWojqrZREQrK0FGSX3FNz4Ymtlt6KpDidftJAZK2i4F5bKr6LtIrRYm1cjjK9Ie6GIqOeIrvWHv76/nCx1Vi+aq5BBDILwuewNUxvISGzhBCOEy+p5T2o3uQnfeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420903; c=relaxed/simple;
	bh=qo2XXHvTGJJhD4UkvChU660G17HtLqFWGAMBCwwehao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tnW72bNTmbysAZucBAI+QV6mzxvchyS4hzPZzphQQUffmdXkULlmsxEnj8SJ45K479NUg/qxbwBtSfATN2fp9Y5BNn5cL0QGHlfTu50Zf+wXjSU54+K8ZX2E0mEIv/fUuiZG6OyquDOiWCNTKUYiOoifBtgGBd1X62w+RBb62QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6exY0B9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6exY0B9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2BEC4CEE2;
	Wed, 23 Apr 2025 15:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420902;
	bh=qo2XXHvTGJJhD4UkvChU660G17HtLqFWGAMBCwwehao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6exY0B9BtIFJ3Urag4RvqlT+lb4s2IIPg/sCKCoKpoige8/Qwpd2HIsXHVJYo1Wf
	 BDlR/uoAxMoZ51RxejMDawggX2qZJRU0NDCRKxgU/4URDlOwGoaOpEgfuy8Ucmfejc
	 24tSuzsTsIOYp2dDg/8eHJOYIU+JQ+04FIBrVhAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 091/291] tpm, tpm_tis: Fix timeout handling when waiting for TPM status
Date: Wed, 23 Apr 2025 16:41:20 +0200
Message-ID: <20250423142628.075834559@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan McDowell <noodles@meta.com>

commit 7146dffa875cd00e7a7f918e1fce79c7593ac1fa upstream.

The change to only use interrupts to handle supported status changes
introduced an issue when it is necessary to poll for the status. Rather
than checking for the status after sleeping the code now sleeps after
the check. This means a correct, but slower, status change on the part
of the TPM can be missed, resulting in a spurious timeout error,
especially on a more loaded system. Switch back to sleeping *then*
checking. An up front check of the status has been done at the start of
the function, so this does not cause an additional delay when the status
is already what we're looking for.

Cc: stable@vger.kernel.org # v6.4+
Fixes: e87fcf0dc2b4 ("tpm, tpm_tis: Only handle supported interrupts")
Signed-off-by: Jonathan McDowell <noodles@meta.com>
Reviewed-by: Michal Suchánek <msuchanek@suse.de>
Reviewed-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -104,11 +104,10 @@ again:
 		return 0;
 	/* process status changes without irq support */
 	do {
+		usleep_range(priv->timeout_min, priv->timeout_max);
 		status = chip->ops->status(chip);
 		if ((status & mask) == mask)
 			return 0;
-		usleep_range(priv->timeout_min,
-			     priv->timeout_max);
 	} while (time_before(jiffies, stop));
 	return -ETIME;
 }


