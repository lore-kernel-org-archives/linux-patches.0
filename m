Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9436D547067;
	Thu, 17 Sep 2026 18:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668730; cv=none; b=TqQfz+W1vwgNbcmAqni0IISUWRPJ27c9dtPyPYRPFAvaIrEa0L1vkPwjcj7BSwFkdi2FkIjtEWqDnBzBctvRBXanLQhr3i7w3FdrNkMaGlyGdpjsRA+d20NbNKGa5zUAMJMRPucsIneowtos4kJnDGNCMopKJywZpn2wz/gsS18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668730; c=relaxed/simple;
	bh=ZdPgbSL9L2gs26fV5RJJQVGxk45YFnOj03HDw8W8Hpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PONhj4w5edYgfoB6mDzAAIz93RM/Jiu/M1hG4jhPTRw7EYUiAhbyY+jdxGmMcY+O7O42y14HnjT5Earjc2B/Sqb0HlD5q9E9TGHFXzYIBp9j2mZg3g6qumuWB4BST0dXq9q2L2UkzpyFdsWjIQds6TbCP/LZCK4yLrBqa9D/OF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTrMBS7h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTrMBS7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF1A1F00893;
	Thu, 17 Sep 2026 18:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668729;
	bh=/2XNzoy81F2G8eLYMGiwMCQKYNxhjxgVvQqIm+LdP4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTrMBS7h3mESy4x5IyY7KkFNJf0WjE3SJSD35DjoqyWQ+tg6bCia9yxFoSddjMUnV
	 8pTKIwZr1XpjT9+IrOWTngDGwfRguvJL5+yH/M4E33AujboFLL7+77iimGl+uLkKc6
	 l2GW+k7sRqgG+X/kTWQVKfA0zhP2JC5/rW38XoE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Milan P. Gandhi" <mgandhi@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0523/1102] scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()
Date: Thu, 17 Sep 2026 16:07:46 +0100
Message-ID: <20260917151552.914328967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 7331237f7506c..c0364fb5b0c5b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1507,6 +1507,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
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



