Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418163B9D96;
	Fri, 15 May 2026 16:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862596; cv=none; b=fBh4k3iydyuH1LssnjYJEwM2Xj2EenYpCXvtP7+jPOOEMuXWiOEMEMN9EEVh2eLVP+E8V2pPWXcjhthyHTW46Ww11k0w9pNdf/YEGA7Wq4SM64PDmSq4wV5HbA/lONEnlx9F6tB8OKTvI1PvaKKsMHc7IUSYOZAsBoR8NrblOaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862596; c=relaxed/simple;
	bh=Z4UqND0/Y+pf2QSBexcu/pFD/lk08JuV1rt4ELrJzXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZX7jaJuFdokh/T3aVlL9+KPsCXL6xiOIFW44ijuRqO0RipaZhAm9Hh2b2Z/we04c8KkJOJMLUtMKP9uI1k+AtcvkjixKcd52C9ttLLHAn/0wh/m2Rs3YQdE5MUoJiB0vRm3DU3nNNhQMMF+6CNW0iqc5HQi9u3yDjN7RUbpiMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtgglOd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtgglOd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1452C2BCF5;
	Fri, 15 May 2026 16:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862596;
	bh=Z4UqND0/Y+pf2QSBexcu/pFD/lk08JuV1rt4ELrJzXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtgglOd/MBNCnSEup2vO2pE2oGQUC5iMjBdLaHnNUoJGPKv8u07UjoAOCR5MUSipm
	 DnYZtzMXtxQTZ+XFbzt4N1krWytliFVaKc5kEe9NcLXbqa6SnOZH+O8b6ag/F56W7u
	 4N7ZfJhBljEd+9OPuHaLnnm+6RlV5fnbOK05n3NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mason Yang <masonccyang@mxic.com.tw>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 109/201] spi: mxic: fix controller deregistration
Date: Fri, 15 May 2026 17:48:47 +0200
Message-ID: <20260515154700.913104466@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit adbc595e272052181d40ec307a4c5ba98571b0fe upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks (via runtime pm) during driver unbind.

Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
Cc: stable@vger.kernel.org	# 5.0: cc53711b2191
Cc: stable@vger.kernel.org	# 5.0
Cc: Mason Yang <masonccyang@mxic.com.tw>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-6-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mxic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -832,9 +832,10 @@ static void mxic_spi_remove(struct platf
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct mxic_spi *mxic = spi_controller_get_devdata(host);
 
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&pdev->dev);
 	mxic_spi_mem_ecc_remove(mxic);
-	spi_unregister_controller(host);
 }
 
 static const struct of_device_id mxic_spi_of_ids[] = {


