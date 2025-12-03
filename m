Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B051342526;
	Wed,  3 Dec 2025 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780853; cv=none; b=fnMWiEd0L0FiBLK3M90YYkT0CtfKjkjQBAj33T0tXNxIgzjBhGacy+w/I9pcuAX8E/azjzIrnwhDFTbsphdmO4Pt+8dAp9/OWcXJQ6ESi/FhUnStsYQ1WdJAg2ukE3QhFoRSD8Xsgtsn2DMITj6RsIQJKQmbPk6aw9skKvYX4Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780853; c=relaxed/simple;
	bh=lGXKgEkgGxKzES6Ml9fp5joYnKuB3nh4HUCiZFZf4KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utdfBoadLcmfQGvlP6bbc6Cunq4XF9gIYfTKzOXeCQBV6h2i8dsDJt9ZJ54tH2QEWFMDrbaQM0RppNX1rEdLQxLWRp2Ss4pWBMI/qJhAnGOhxSNtZrqf5u7xpepUUVhbLhkK3f/IDjj4ZpuqgykWi4BJSf6cbd1XmeU4rRNbcSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFdu0XsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFdu0XsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B33DC4CEF5;
	Wed,  3 Dec 2025 16:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780852;
	bh=lGXKgEkgGxKzES6Ml9fp5joYnKuB3nh4HUCiZFZf4KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFdu0XsVtzZrNkhalOrRni9aciICw8JkT8HfpTyq0O7wsDtQ2EivQ2+MV2dM8e1bJ
	 W7Y62zpCCk4l0TE2BWE3WIEM+43efA6YEdK4ECUJJUQVas09EOszt+6BXeLH1d42F1
	 Vrs1ueOgDZzXnG0Cwejj67FRgnFG3yFRbknknJB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 110/132] net: dsa: microchip: Dont free uninitialized ksz_irq
Date: Wed,  3 Dec 2025 16:29:49 +0100
Message-ID: <20251203152347.358995105@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2592,7 +2592,7 @@ out_ptpirq:
 			ksz_ptp_irq_free(ds, dp->index);
 out_pirq:
 	if (dev->irq > 0)
-		dsa_switch_for_each_user_port(dp, dev->ds)
+		dsa_switch_for_each_user_port_continue_reverse(dp, dev->ds)
 			ksz_irq_free(&dev->ports[dp->index].pirq);
 out_girq:
 	if (dev->irq > 0)


