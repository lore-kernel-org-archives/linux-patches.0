Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401FD2FFDEA;
	Sat, 12 Sep 2026 13:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221466; cv=none; b=p5S47XleF7+5/42FvElm2HYGV6qfr5x3yj15apknI8ECbAikg0hDoxHI1PDw4LFd0/4CWpSRjsU+fFkkrTXScQkjiV8XIIQVi66K/bvDdCcQEeybVcQm5bVmq8WYBaRgJZCOkAhHhaxUKusp3OUTZitg368lkP9dSm1gQ7NHdc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221466; c=relaxed/simple;
	bh=zOGtTWXLxIyDFtp3GYWsmLt0R75iwTdYYfE/9fzBI9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qe4AMAzY1yqc2otG31Dx6JiGEkfGlXnNM+HrmkzgUm5I//i5XIl3Gph8+cuTKIvEgnZw6z4JIZRkJq6YY1RbjWS5eCiHYs0/7AMJDy4QShUeLqxb/MrHeRJxBWMUNZNuEw5/Hb+aY/DT32tkyX0oRgDX3qdkmg/fFe5qWLVP8ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DR4v/OYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DR4v/OYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB401F000FF;
	Sat, 12 Sep 2026 13:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221465;
	bh=zedZWrVXQvcamQDLJikXHKHL4iuMt+gS4qouUiaWUGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DR4v/OYA3CbQr9qQvrzeiK0T6gRZaWWdwGc21mkbIFCenUOj7U+nY/kjr/gqdJzZ1
	 aRhJ90OsykhkdGXMRr0lrw1x+lrcByU6xiVXPzkc+LUm3JyJ0ohM2zO/jQySDd21wu
	 RPvzThwKIVIKUVdDBEiLYTqfusAeEEom0LGBNuOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.6 0386/1424] s390/vfio-ap: Fix control domain removal in vfio_ap_mdev_cfg_remove
Date: Sat, 12 Sep 2026 08:46:58 +0200
Message-ID: <20260912065615.936923528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Krowiak <akrowiak@linux.ibm.com>

commit 6b8a02e216f6b520cc029e43ddc83956605135d5 upstream.

The vfio_ap_config_remove function uses the bitmap_andnot function to clear
bits from the matrix_mdev->matrix.adm bitmap (specifies the control domains
assigned to the mdev). This prevents the explicitly unplugged control
domains from being removed the KVM guest. The bitmap_and function is used
instead.

Fixes: eeb386aeb5b7c ("s390/vfio-ap: handle config changed and scan complete notification")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2365,9 +2365,9 @@ static void vfio_ap_mdev_cfg_remove(unsi
 		do_remove |= bitmap_and(aqrem, aq_remove,
 					  matrix_mdev->matrix.aqm,
 					  AP_DOMAINS);
-		do_remove |= bitmap_andnot(cdrem, cd_remove,
-					     matrix_mdev->matrix.adm,
-					     AP_DOMAINS);
+		do_remove |= bitmap_and(cdrem, cd_remove,
+					matrix_mdev->matrix.adm,
+					AP_DOMAINS);
 
 		if (do_remove)
 			vfio_ap_mdev_hot_unplug_cfg(matrix_mdev, aprem, aqrem,


