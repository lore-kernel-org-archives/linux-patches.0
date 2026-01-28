Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9C12C237E;
	Wed, 28 Jan 2026 15:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614566; cv=none; b=mVAT3nVnOj1YH7jbC4nsZypIIXcey9qAkXz364Gwj8+0tzGAqhUy4GjmHMeEMhB3T34H44Ar/bZwVSQjIQLBJZJELUQHzzAEuUO4iN1bo0mHs+UP8djOGwDMFaG0ISzjK0ugsiJ2gtBezXh+KhhSLBlpZJ8o8lg+9L+zQjxu/vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614566; c=relaxed/simple;
	bh=yU3nvLOaXAXnR/QFYVJkuuJzdmMTJrvqiQiO+1X+c6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIxSK0A55Edf/PwiqtSduHQZFs9cYtdiBrMqpMjRuyB78OfdHDtNoL+yFJAUExoh3Xy1T+01ncLGgFsIsDgj4xdDHswB+SP3ikz2bya1IYCDAmjO9gEBR/TqzMyadvJwTJn7w0WTnGuo42XkSVDyBpfA6k0PoC+XcrIUGVi003I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwwnWb4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwwnWb4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E8DC4CEF1;
	Wed, 28 Jan 2026 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614565;
	bh=yU3nvLOaXAXnR/QFYVJkuuJzdmMTJrvqiQiO+1X+c6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwwnWb4D4k9Zt9LDR0wQjW2aCDUV0nKAlzVQt1kZx3AN7UzXA0RNfaFjJPxgxgMg6
	 Z4nfakMwhVW6eTDiEq5lEvZTRAofqrE4sEIFRIVWIEC3wPIrsIv5lQ3emr72lttLsE
	 tJWP1+wURwbMblvUSmh3lrOgm1RpWSV/B1Dg0V9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 143/254] scsi: xen: scsiback: Fix potential memory leak in scsiback_remove()
Date: Wed, 28 Jan 2026 16:21:59 +0100
Message-ID: <20260128145349.961528019@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 901a5f309daba412e2a30364d7ec1492fa11c32c upstream.

Memory allocated for struct vscsiblk_info in scsiback_probe() is not
freed in scsiback_remove() leading to potential memory leaks on remove,
as well as in the scsiback_probe() error paths. Fix that by freeing it
in scsiback_remove().

Cc: stable@vger.kernel.org
Fixes: d9d660f6e562 ("xen-scsiback: Add Xen PV SCSI backend driver")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20251223063012.119035-1-nihaal@cse.iitm.ac.in
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xen-scsiback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1262,6 +1262,7 @@ static void scsiback_remove(struct xenbu
 	gnttab_page_cache_shrink(&info->free_pages, 0);
 
 	dev_set_drvdata(&dev->dev, NULL);
+	kfree(info);
 }
 
 static int scsiback_probe(struct xenbus_device *dev,


