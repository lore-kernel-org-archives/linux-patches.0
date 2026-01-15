Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD822C11EF;
	Thu, 15 Jan 2026 17:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499678; cv=none; b=sEU/qz3OwPn+xXmCE09EfKhtW5raOtg8kJj/Umx7uND2ZwGCvyXgfWhdvSud98E2zEWgK506l+PwcvmVBJixoFTcngJ/K7hvlmuvPplOzwL636Fv0HN1kFremn9slD721enHP7YNzJeY8h5YEcvOLroVGQSVPRxVjZEv0PHKNXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499678; c=relaxed/simple;
	bh=jy2ad5OXUY6QtH0G8bE7v896UDll6HejA1eM4bfwRMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taOg0MSfeB4r6WyVSKi6PuK2sQvtuvAJNRW5n+mHXgkJfxWTtCwPmS4IEjl16PWrkQiAT0XULb4Ntqi16YHWLzfshQnmG3K8S3M1MF4qlp/WRP00B+s4tPhMFiuXCHml+J6OKPWIjZllSGsESATI8t1nNa9kzk4hXaDeh9p4xbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1yxgpzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1yxgpzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D17DC116D0;
	Thu, 15 Jan 2026 17:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499678;
	bh=jy2ad5OXUY6QtH0G8bE7v896UDll6HejA1eM4bfwRMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1yxgpzXt3RXxbzEfJEJVHV1fK4SmRtGLT1GNHOJvP69KJSCF9Vhpg3CJ19Si24jz
	 7D/RS8gXFN288/EV4MY+AFb0xKd2/H20xfpHQ5cpoFPEpYKaPhOV+N7NcJrKz9Ncaf
	 vDL4EaIFBwoLOwlcocS8vOdB00JmPc3LR3/7WXTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 312/451] mfd: altera-sysmgr: Fix device leak on sysmgr regmap lookup
Date: Thu, 15 Jan 2026 17:48:33 +0100
Message-ID: <20260115164242.186413464@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ccb7cd3218e48665f3c7e19eede0da5f069c323d upstream.

Make sure to drop the reference taken to the sysmgr platform device when
retrieving its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: f36e789a1f8d ("mfd: altera-sysmgr: Add SOCFPGA System Manager")
Cc: stable@vger.kernel.org	# 5.2
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/altera-sysmgr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mfd/altera-sysmgr.c
+++ b/drivers/mfd/altera-sysmgr.c
@@ -118,6 +118,8 @@ struct regmap *altr_sysmgr_regmap_lookup
 
 	sysmgr = dev_get_drvdata(dev);
 
+	put_device(dev);
+
 	return sysmgr->regmap;
 }
 EXPORT_SYMBOL_GPL(altr_sysmgr_regmap_lookup_by_phandle);


