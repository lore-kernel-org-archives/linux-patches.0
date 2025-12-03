Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560BA33A6ED;
	Wed,  3 Dec 2025 15:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777283; cv=none; b=IyrtZgkpELcBVUUsth+a0S+gsIgK3YobB4PBfaSKiOqj4Z8OVlwcFjfkj9QWFUM+0XVzY/gqrr/Hwt+oVH83tf53k+iOYR0wR2WDQAyKfx4wC8FO3xCKbDtkK/WMfdP/eJrKNuW4M0kWa98e35/If6jVCNkwrEpDQ7ubcDlqfQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777283; c=relaxed/simple;
	bh=7AHVKzH5XrhzmeMtmFfRLpHliKE2Omvb2U3WfdMDbmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJQKfwTbReS9NHQ9/8VNJeENGHCaJq1ZicebRBzXnR0V7CoX2Eiqlta310PKaAKWza2tKUbS6A5kqFlHZEul4Hah9VYTPhFqsviLhbV4KFKAT62L/qq6spSEyoSopSyisOnkCiD3O5FxxqJjUhA+/8LC5EaKMfPdCBF/G09eCjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqvcZ9IG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqvcZ9IG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AEDC4CEF5;
	Wed,  3 Dec 2025 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777283;
	bh=7AHVKzH5XrhzmeMtmFfRLpHliKE2Omvb2U3WfdMDbmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqvcZ9IGAxrcf4oxEYPfvY4IL6E0irSJnYCAEe5lYQVvyiGtw3jstDvukLCMTVV2b
	 r52cUpb2qB45A4/pAubW9sPXp0d0x4O96MmHlNwV/US5OOI7l+Fk748oJrHCp33e/F
	 QYKyyaXL7r0Bwd8mfdlJIh2YCtED1DAYtSJt2G40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.17 136/146] net: dsa: microchip: Dont free uninitialized ksz_irq
Date: Wed,  3 Dec 2025 16:28:34 +0100
Message-ID: <20251203152351.451517895@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>

commit 25b62cc5b22c45face094ae3e8717258e46d1d19 upstream.

If something goes wrong at setup, ksz_irq_free() can be called on
uninitialized ksz_irq (for example when ksz_ptp_irq_setup() fails). It
leads to freeing uninitialized IRQ numbers and/or domains.

Use dsa_switch_for_each_user_port_continue_reverse() in the error path
to iterate only over the fully initialized ports.

Cc: stable@vger.kernel.org
Fixes: cc13ab18b201 ("net: dsa: microchip: ptp: enable interrupt for timestamping")
Signed-off-by: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
Link: https://patch.msgid.link/20251120-ksz-fix-v6-3-891f80ae7f8f@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -3082,7 +3082,7 @@ out_ptpirq:
 			ksz_ptp_irq_free(ds, dp->index);
 out_pirq:
 	if (dev->irq > 0)
-		dsa_switch_for_each_user_port(dp, dev->ds)
+		dsa_switch_for_each_user_port_continue_reverse(dp, dev->ds)
 			ksz_irq_free(&dev->ports[dp->index].pirq);
 out_girq:
 	if (dev->irq > 0)


