Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D8933BBD2;
	Wed, 21 Jan 2026 18:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020602; cv=none; b=qK8SYQmgRH3H0aCjCZhohYo7Z6P4DCSiRc8ZzPlazosguOgfnt0Yx20PTY5n/5g7+/OQ1DHucCe175EsHeiJubhzBDtO+HB9jihCXbuuKKk45n/A9B0HcI6X40+Y5ZDPd5LkQwX8ac4aa13gucr1AK8uQVqz4NMz0XG0RI++ino=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020602; c=relaxed/simple;
	bh=LXk5tu0nUgu0WzJQXXvwArZpYWojl2kPu8215/pllQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WszbneCqKsQVmEU1A+Y+YuVWpP73NL4HCEFSvP1/i4KSkjTHR8ONReQj7s4C5y0noQ7Om09eOg9vRk1Yy8ckqy1pDUe0gZ1BRYWaPOvreirb246dTyLerphz7vCuBdy0DwY+ZxuzIOE+PX8PLlIPSJKD0oL+wWMSw1S+qjG09YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwaznLf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwaznLf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1201C2BC86;
	Wed, 21 Jan 2026 18:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020602;
	bh=LXk5tu0nUgu0WzJQXXvwArZpYWojl2kPu8215/pllQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwaznLf61ORj7jBCdGH/zszmCkjKT0bAuUi71VvzrFf7PhfyousYDuuNSOP7nOWw7
	 3yHuBBrmhSVCMUTy7IX0Dxvmv8dHLSWCtobZaBUG4RuyS4QzX1fRlMxuq1dhX6OZ6t
	 aEW8MNwpKsYDkJ3owSRdT0gVJduEfGuJJkJM0nZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 171/198] dmaengine: dw: dmamux: fix OF node leak on route allocation failure
Date: Wed, 21 Jan 2026 19:16:39 +0100
Message-ID: <20260121181424.701300107@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ec25e60f9f95464aa11411db31d0906b3fb7b9f2 upstream.

Make sure to drop the reference taken to the DMA master OF node also on
late route allocation failures.

Fixes: 134d9c52fca2 ("dmaengine: dw: dmamux: Introduce RZN1 DMA router support")
Cc: stable@vger.kernel.org	# 5.19
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20251117161258.10679-6-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw/rzn1-dmamux.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/dw/rzn1-dmamux.c
+++ b/drivers/dma/dw/rzn1-dmamux.c
@@ -90,7 +90,7 @@ static void *rzn1_dmamux_route_allocate(
 
 	if (test_and_set_bit(map->req_idx, dmamux->used_chans)) {
 		ret = -EBUSY;
-		goto free_map;
+		goto put_dma_spec_np;
 	}
 
 	mask = BIT(map->req_idx);
@@ -103,6 +103,8 @@ static void *rzn1_dmamux_route_allocate(
 
 clear_bitmap:
 	clear_bit(map->req_idx, dmamux->used_chans);
+put_dma_spec_np:
+	of_node_put(dma_spec->np);
 free_map:
 	kfree(map);
 put_device:


