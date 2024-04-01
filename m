Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE67B1CA8F;
	Mon,  1 Apr 2024 16:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988776; cv=none; b=WLE8FoifNdujH6tZPvBOTzpkjNDBQiR7m0Wc+9lYEWb2FOefkocyg0JXPEgk7zWWghktx9ojrxgsamfPx39QPWT5dr5uKGg2AEqpyQl9AX+aqNeA89Qz/T77oLimHab8xSN0ByMFuGGeay6Gdo7nyprwrWLXRNdoRhvmQcD+QuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988776; c=relaxed/simple;
	bh=Ei6nnOkn//wCjo/dKBDEJbfcVCp+x7WL53wOLVQwOQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyDuwFDHRFCDysBpgKvoY4HSBso05UbO0IHnG9jMhA9gRoDSnrowYCz9srOdgn+8Q6VP/hSTV96r6xuNpm7Z7jUD/Bn60e0HCFpGl/EvVd5azUagBsr+vaE1oAlz5YMFjK6YgJ4i/CZKJ9xH+XFunTkkgXSWnMr+tu+DS0cxGaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9OV7C5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9OV7C5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C51C433C7;
	Mon,  1 Apr 2024 16:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988775;
	bh=Ei6nnOkn//wCjo/dKBDEJbfcVCp+x7WL53wOLVQwOQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9OV7C5bKkjdsWmUwu/S8lyrUoA6dA6MmlfqO4UZ0TZrrZW7YgWckiDmGndu0H+Yd
	 FFZ9BHDBtz6yMOSpfmhi17UMJulVRGCRGKzSDlWzJ0s9f1YMhhIcJ4ZnHH27F2veLY
	 wCMnp7hvxCsW9vD00TDD91QiYoW8QbCnvR/W6/20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.7 284/432] i2c: i801: Fix using mux_pdev before its set
Date: Mon,  1 Apr 2024 17:44:31 +0200
Message-ID: <20240401152601.644078484@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 09f02902eb9cd41d4b88f4a5b93696297b57a3b0 upstream.

i801_probe_optional_slaves() is called before i801_add_mux().
This results in mux_pdev being checked before it's set by
i801_add_mux(). Fix this by changing the order of the calls.
I consider this safe as I see no dependencies.

Fixes: 80e56b86b59e ("i2c: i801: Simplify class-based client device instantiation")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-i801.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1740,9 +1740,9 @@ static int i801_probe(struct pci_dev *de
 
 	i801_enable_host_notify(&priv->adapter);
 
-	i801_probe_optional_slaves(priv);
 	/* We ignore errors - multiplexing is optional */
 	i801_add_mux(priv);
+	i801_probe_optional_slaves(priv);
 
 	pci_set_drvdata(dev, priv);
 


