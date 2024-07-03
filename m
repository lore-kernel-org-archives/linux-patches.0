Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1AF142903;
	Wed,  3 Jul 2024 11:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004608; cv=none; b=kbRzqTSsyq+0WKpRc9dZXWAfDPLVU1xqPeIjBuZGNtBKRmW/NxGHrNhDaa3yW/0MHRAfExmWk4xCxdiHjWgP2SXwYtJAPNoiqlX0hmVTchLG3RHyDImNDjQ+iAtYOI7fFn+QzpQaBqjCp/CQXcfXiJ+qdUrmQkE5thkmKuOjL9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004608; c=relaxed/simple;
	bh=WxPTdxX3Vnoc6Omhyru6eQQ/50V1p6S88FDaHUac9/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckEggiHTQrw3QvIwuPJtl848w69VQdOcE2Uwau7iqcyp0Oej2sBeUkEqidcb/SzpQ4g48r6EzQXBpPboKDioJeVZzja4dn65nMgIwjmuQzorP1ARIBMfXHinxrujttGfZRQ34qcDYIUyORpT8TC7U4XMZKw6rsiGlU2n4sTVi6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxroMoME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxroMoME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36B3C2BD10;
	Wed,  3 Jul 2024 11:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004608;
	bh=WxPTdxX3Vnoc6Omhyru6eQQ/50V1p6S88FDaHUac9/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxroMoMEar+S0ztI9kPdGr+HOIYsQrgbaUgsPUV2R7fIJYomxIT7FvZAgOu8SW367
	 sESHOhfE0lWt8RMPL1YNPv+WwYpSb+IkiFV8aKuL1iOpzkqfFznvkoZQv8fpQ5RGrE
	 /95b22lOOvuwzANOklgukq0KGp9hU+YvLYa1Mifg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 099/290] remoteproc: k3-r5: Jump to error handling labels in start/stop errors
Date: Wed,  3 Jul 2024 12:38:00 +0200
Message-ID: <20240703102907.933084498@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Beleswar Padhi <b-padhi@ti.com>

commit 1dc7242f6ee0c99852cb90676d7fe201cf5de422 upstream.

In case of errors during core start operation from sysfs, the driver
directly returns with the -EPERM error code. Fix this to ensure that
mailbox channels are freed on error before returning by jumping to the
'put_mbox' error handling label. Similarly, jump to the 'out' error
handling label to return with required -EPERM error code during the
core stop operation from sysfs.

Fixes: 3c8a9066d584 ("remoteproc: k3-r5: Do not allow core1 to power up before core0 via sysfs")
Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Link: https://lore.kernel.org/r/20240506141849.1735679-1-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -484,7 +484,8 @@ static int k3_r5_rproc_start(struct rpro
 		if (core != core0 && core0->rproc->state == RPROC_OFFLINE) {
 			dev_err(dev, "%s: can not start core 1 before core 0\n",
 				__func__);
-			return -EPERM;
+			ret = -EPERM;
+			goto put_mbox;
 		}
 
 		ret = k3_r5_core_run(core);
@@ -547,7 +548,8 @@ static int k3_r5_rproc_stop(struct rproc
 		if (core != core1 && core1->rproc->state != RPROC_OFFLINE) {
 			dev_err(dev, "%s: can not stop core 0 before core 1\n",
 				__func__);
-			return -EPERM;
+			ret = -EPERM;
+			goto out;
 		}
 
 		ret = k3_r5_core_halt(core);


