Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BE521ABC1;
	Tue, 29 Apr 2025 17:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949004; cv=none; b=pgI2ckMzdWQtiLuxzaea1e61/563o/K+l0y08OgsZDJq9OYdOMce1qangMma0SNt76Mfjrv/6oUykvC9Uom6/MeMlbx/OqUJJAvfVZmX9goAFnhy/ARog7IzcWkOYN6i3/kwK5v+JB6Sn/2wPaist0kYNqUJPYFvlDcBQxHT1XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949004; c=relaxed/simple;
	bh=a6eL0LCyrLUXPOviMqsAxmcK2p3fu/QAoZTg/9v055c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i2c/mWrkF+pWfM4VzXnVJiecofQRvZMrCjimN+IGzPsm3Wj1UOOjumIXXI0GsZcI9oPSmYt0ybyu6osTPrkQTTa4QFl60WXOghOCaOcB857iNPC+gj9HsOa+FtCYiB3j1LqFtpH2Dov6lMFWHV5EdXMnfoHNDl/9xWRx5mZuMTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcXQEy+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcXQEy+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ADCC4CEE9;
	Tue, 29 Apr 2025 17:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949004;
	bh=a6eL0LCyrLUXPOviMqsAxmcK2p3fu/QAoZTg/9v055c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcXQEy+iX1bmhIePlNQJqwo3c9NQWAX0S7UtwfyrmEk5cTREZ/JAkwMymeEViDCfx
	 7L9FWsVeG5eiFYGIznG2XoSJn9RZOmj59KxCOnqpcvsWQrq50vHec7Lr4E7d9ZDx5F
	 PK4mZD4ygkzoJvp25oNYdxZU1SMwd6e2WyHxZJQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.15 158/373] asus-laptop: Fix an uninitialized variable
Date: Tue, 29 Apr 2025 18:40:35 +0200
Message-ID: <20250429161129.644008753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit 6c683c6887e4addcd6bd1ddce08cafccb0a21e32 upstream.

The value returned by acpi_evaluate_integer() is not checked,
but the result is not always successful, so it is necessary to
add a check of the returned value.

If the result remains negative during three iterations of the loop,
then the uninitialized variable 'val' will be used in the clamp_val()
macro, so it must be initialized with the current value of the 'curr'
variable.

In this case, the algorithm should be less noisy.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b23910c2194e ("asus-laptop: Pegatron Lucid accelerometer")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Link: https://lore.kernel.org/r/20250403122603.18172-1-arefev@swemel.ru
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/asus-laptop.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -427,11 +427,14 @@ static int asus_pega_lucid_set(struct as
 
 static int pega_acc_axis(struct asus_laptop *asus, int curr, char *method)
 {
+	unsigned long long val = (unsigned long long)curr;
+	acpi_status status;
 	int i, delta;
-	unsigned long long val;
-	for (i = 0; i < PEGA_ACC_RETRIES; i++) {
-		acpi_evaluate_integer(asus->handle, method, NULL, &val);
 
+	for (i = 0; i < PEGA_ACC_RETRIES; i++) {
+		status = acpi_evaluate_integer(asus->handle, method, NULL, &val);
+		if (ACPI_FAILURE(status))
+			continue;
 		/* The output is noisy.  From reading the ASL
 		 * dissassembly, timeout errors are returned with 1's
 		 * in the high word, and the lack of locking around


