Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7162C354AC3;
	Wed,  3 Dec 2025 16:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780955; cv=none; b=Y8K3VnCENZ2Z8OUh84/XHad2zqa+a8NK3wlG5G0v5Q3AMGA/TInCCp1mgia1HzxQs8+1z+H65+6S+5YNzLoHA/QPCo3sqDWlDJ+1zKAG5JSp9HclMDeV1D+VzpBNZqNOTHbniajizyuS95uGyeL3G1NNPi3tVIiyonUoo4Wom5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780955; c=relaxed/simple;
	bh=hmnbKLfT1xxZqhZAUbId0puwdiI8+Tx5Hh0LZRJqSoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qmRLx4lRjnv+1aC2QDbfLjtpuCuT1dpf/TbLQiAZ6E4fD8xD+UdG7uESiD7X/4MCnmosk9ktmfDtHZ892oGTumNyC05iMNmhSzzYaeU+JiygZqAOgmvMRJb5twW4exiz0INwnyn6GDil2jQnrK0b09lSWL9YfvtAe8optCzWNXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=km1kByiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="km1kByiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69096C4CEF5;
	Wed,  3 Dec 2025 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780954;
	bh=hmnbKLfT1xxZqhZAUbId0puwdiI8+Tx5Hh0LZRJqSoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=km1kByiScOIN92OJBxZ5RZ6wbp50y17MHaxNyHuModXGSMZaJkefEw7e/mvg/MBqc
	 6SR5ckblZp78kzKniFr2DKrP03/nuYzV1gFMyFZPf5mShWzuSwtUhLpfbKtPXz7wRV
	 665KaVYvIruFE1GXgm2N6v1Fbo3ckuM4m8gfdwZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mark Brown <broonie@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH 6.12 132/132] spi: spi-nxp-fspi: Check return value of devm_mutex_init()
Date: Wed,  3 Dec 2025 16:30:11 +0100
Message-ID: <20251203152348.203827402@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit d24a54e032021cf381af3c3cf119cc5cf6b3c1be upstream.

devm_mutex_init() can fail. With CONFIG_DEBUG_MUTEXES=y the mutex will
be marked as unusable and trigger errors on usage.

Add the missed check.

Fixes: 48900813abd2 ("spi: spi-nxp-fspi: remove the goto in probe")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/r/20250617-must_check-devm_mutex_init-v7-1-d9e449f4d224@weissschuh.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-nxp-fspi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -1249,7 +1249,9 @@ static int nxp_fspi_probe(struct platfor
 		return dev_err_probe(dev, ret, "Failed to request irq\n");
 	}
 
-	devm_mutex_init(dev, &f->lock);
+	ret = devm_mutex_init(dev, &f->lock);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to initialize lock\n");
 
 	ctlr->bus_num = -1;
 	ctlr->num_chipselect = NXP_FSPI_MAX_CHIPSELECT;


