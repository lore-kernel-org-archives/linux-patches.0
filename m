Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D9D1AAE00;
	Mon, 14 Oct 2024 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919335; cv=none; b=SoLWFwrnwbQx/60cACdZMSatKQJS+bwJrS5RgqbmlqVbV3kB29W8VdxQzIR3TKBjfdw6yfjPIzMTtuQBqQxXgGNW8e0riUbqWQX04AXnQCR7U+zD3BxHM2G1QR6N9TIRDSB2kYphjDDLTwUFENGrQbWYoSb6yx1bugGhXe1bKlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919335; c=relaxed/simple;
	bh=uafQFmMrqQ+JPohL5kY0p2T7wd/FsLy7UDxkcwNpWi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m00FdfyFwL8OhVgpNtAPE7Q1eslIyRdxwo/XUN0JaBi2QH0Qnd9zKEzpWU+MdZS3cOFBbtWg8rX5p8b/HLfRGakNFMzLi4WeWYV33hP5e1wAviDhX2PKGL0iPdlHDXXJxOmJdvWXIWXrxfLtjR+FgaOhANAZh85BrRynqG4ali0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pALH6mX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pALH6mX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51C3C4CEC3;
	Mon, 14 Oct 2024 15:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919335;
	bh=uafQFmMrqQ+JPohL5kY0p2T7wd/FsLy7UDxkcwNpWi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pALH6mX2DVO63MJcrt13HObFvM1Ew29iSmAJ9dc8lWtkmINc9NrPExEMLX5PfLXI+
	 X6jle/Z0fA6Uuq0W5SVl2qC4ZFa+SKAvF8uIL7Wes/m+11x7Ge4eeHW6K2qO2LSWPc
	 gOJUFsiDkdYTdptAGkW5RdF1HuaRQiQoU7CQZuiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Beleswar Padhi <b-padhi@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 581/798] remoteproc: k3-r5: Fix error handling when power-up failed
Date: Mon, 14 Oct 2024 16:18:55 +0200
Message-ID: <20241014141240.828125269@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

commit 9ab27eb5866ccbf57715cfdba4b03d57776092fb upstream.

By simply bailing out, the driver was violating its rule and internal
assumptions that either both or no rproc should be initialized. E.g.,
this could cause the first core to be available but not the second one,
leading to crashes on its shutdown later on while trying to dereference
that second instance.

Fixes: 61f6f68447ab ("remoteproc: k3-r5: Wait for core0 power-up before powering up core1")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Beleswar Padhi <b-padhi@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/9f481156-f220-4adf-b3d9-670871351e26@siemens.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -1324,7 +1324,7 @@ init_rmem:
 			dev_err(dev,
 				"Timed out waiting for %s core to power up!\n",
 				rproc->name);
-			return ret;
+			goto err_powerup;
 		}
 	}
 
@@ -1340,6 +1340,7 @@ err_split:
 		}
 	}
 
+err_powerup:
 	rproc_del(rproc);
 err_add:
 	k3_r5_reserved_mem_exit(kproc);


