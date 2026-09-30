Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942984E0B70;
	Wed, 30 Sep 2026 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784959; cv=none; b=B4+bDGYI2VpkySBMpy1qwm2X9QanWWRyolAqmaBBk7X+VteDuga4F2woQfr60iFZQF050OTg9s+5eR16Ry4zoIl9yR+7DJUhp1J4kP3+zPmqIWBx0xrVcrocJbZTqPUB0yCNS7YBgVzJg3iiIEGVkvMxwmqt6nTjz/R/XtNjwlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784959; c=relaxed/simple;
	bh=ANZCBEujKI6tDdnzr3iGoq1V793PxZhsGnzqSbDA18Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuu3ulv2tLHi9lJL0KSMUFs4HCWQsjI6MYWPxdNflwxx8oSgEcy8bAwvv7pl7KGuPiUr2HKQSuV4iBJy9P5YHEo3g9utE2j4jvWqeCfyu2HXWu4h2zWLX+/I24VmjbHSfB8qXVRn+6iEiNv+aEEaj5a10CSnhlb1kAfxu3+Szog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j72jg54q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j72jg54q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EE91F000FF;
	Wed, 30 Sep 2026 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784952;
	bh=si4wTbgT1+f45QbonRHkdrIrOF4iRrmAvPlr4jLPxQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j72jg54q2AJnC6CV/UTT5tDHLz6tP+UFawhiw+Y1W2cnYUpguyAOEN+MjINNXPiAL
	 RaLB9azCE8cZXbtd18A3qEbQa9VXKldO2JJHxBNRc+XP77aenNIdSoVRtwEZCamrSz
	 1EocJVekvWQTfGBUYdTn44hpSN4Tq3hJ+UZ4nsCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Milan P. Gandhi" <mgandhi@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 336/982] scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()
Date: Wed, 30 Sep 2026 17:17:52 +0200
Message-ID: <20260930152424.037261371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milan P. Gandhi <mgandhi@redhat.com>

[ Upstream commit 419d129f970aaa6567dbac366b0c93784bf9ec97 ]

mpi3mr_get_tgtdev_by_addr() increments the target device kref when it
returns a device. If a subsequent error triggers a goto out_fail after
the tgtdev reference is acquired, the reference is never released
because the out_fail path does not call mpi3mr_tgtdev_put(). This
prevents the target device structure from ever being freed.

Add a tgtdev put in the out_fail path, guarded by a NULL check since
tgtdev is only acquired for SAS_END_DEVICE types and the same cleanup
path is shared by earlier error cases where tgtdev is still NULL.

Fixes: e22bae30667a ("scsi: mpi3mr: Add expander devices to STL")
Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Link: https://patch.msgid.link/20260812103344.174247-3-mgandhi@redhat.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index b56fa01894f46..9a25d819b417a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1483,6 +1483,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
 	    port_siblings)
 		list_del(&mr_sas_phy->port_siblings);
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
 	kfree(mr_sas_port);
 	return NULL;
 }
-- 
2.53.0



