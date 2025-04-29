Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5169126BF7;
	Tue, 29 Apr 2025 16:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945386; cv=none; b=IfqiMQE72MrEVBZ79wl+chAcVUaJbp0W9DwMT9QXnLjeMsiBFTyK3Iuk+QCewutJ648jlhwVacfteiQetVMKER+0kFSKG/JV/HN1Nf/xQwX/QG+YV2BTk6QxcoFSPNevERRbxy2f/OicfJauiurutHLisXpR72HE63nLCYfcPYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945386; c=relaxed/simple;
	bh=LEcodZIHVVm0l6NGoiBhIxgh9T/FXolujw08J5vlH74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EIFN7ev1K8tlNhs621x6KtkH3/tx2gJPKS2IaOLY6yztqhOPCS5prvIkuv2N+V0KgeU6eUrx5rmpIxOza1o6uMD8pH3s1flmT8EnU3hHuTYlv3R9tuiSXPnOHXv5lwsFCvYwJ3nSu8Ba9w3RlXAPQwtaWx2esWGmSDtBntiS730=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giBaRE8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giBaRE8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384FAC4CEE3;
	Tue, 29 Apr 2025 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945386;
	bh=LEcodZIHVVm0l6NGoiBhIxgh9T/FXolujw08J5vlH74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giBaRE8HfDfR+fXay6mOi3qQK8xdwIUzooDJfnDZy6pI1BVFcVpCUgyJMP+FD/d1h
	 s4mYM6Y6oxowZNwQis3gBmNAE6uPs3hXlb7CE0ItnxY9iRyfXu9wwNO7cULw+CuFCO
	 I+O6VoO/FNq03PZPtwkm8CwCDvvADFcc6uBZCuVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.4 095/179] asus-laptop: Fix an uninitialized variable
Date: Tue, 29 Apr 2025 18:40:36 +0200
Message-ID: <20250429161053.241800818@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -428,11 +428,14 @@ static int asus_pega_lucid_set(struct as
 
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


