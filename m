Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5388C1DEFD7;
	Tue,  8 Oct 2024 13:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393881; cv=none; b=L+NU8SDDHHKmvqN7nXTfs7uG7HWYNelV80Sh2d6o3ELRY5ywdH+RSnSh5V2eGSJil8MubRxrGI4e1iFDhL2zAFZUZyxvDr0OzIzDR/NFsNgiCwL/JTaxi+yg0l5L/JOsQbsa4mJDjHUYxGTCCTLjXGDEZ+h1BD8hzZUv9LSfDWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393881; c=relaxed/simple;
	bh=bY9b8JR5oBac3Rv6psrPmBYPThvKYrQX5Qes9wDPAXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A73aISzc618ifUvyEX8/o0ajn5vv69xfvpIHZwgklRMaAC2RMozmyq4Dh+qZMpVxzPihuWloYaEA3IrthyaOPBQkGwbqQfTBsazPXeunrptpcb8VRbFhr5fxJmcMFPGK999rjATSNbGSkwRCrdxPO0jhNIg+EguSCxcjmEbO7U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqL7WPxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqL7WPxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46510C4CEC7;
	Tue,  8 Oct 2024 13:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393880;
	bh=bY9b8JR5oBac3Rv6psrPmBYPThvKYrQX5Qes9wDPAXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqL7WPxCZMBuiSA7FF7APRmFJmm5oRVBhpts54tw623S35OW1oeDUEaDsNEn1A79n
	 r5kaSeFahMNJq9Gmaddo1sXOZIRuZDt4T4XcnM/MwmqRNzj9xaQNAr3MOrflvpcHPR
	 WhkJNR+p4ITCZnjFs1VDkEzDkv1TaR8roAAU7q7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Beleswar Padhi <b-padhi@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.6 281/386] remoteproc: k3-r5: Fix error handling when power-up failed
Date: Tue,  8 Oct 2024 14:08:46 +0200
Message-ID: <20241008115640.446095122@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1331,7 +1331,7 @@ init_rmem:
 			dev_err(dev,
 				"Timed out waiting for %s core to power up!\n",
 				rproc->name);
-			return ret;
+			goto err_powerup;
 		}
 	}
 
@@ -1347,6 +1347,7 @@ err_split:
 		}
 	}
 
+err_powerup:
 	rproc_del(rproc);
 err_add:
 	k3_r5_reserved_mem_exit(kproc);


