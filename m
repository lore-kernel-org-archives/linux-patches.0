Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8313C1D66;
	Wed, 30 Sep 2026 19:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794967; cv=none; b=Ku1kvD/pbzTPvwGg5GfpC0jgLyjwbE/ERVZxBKSClvAQ+NU9SuHk62kYofFhjh1ss7dgUiMKXziDrea/9gnfXyaDBtPVnBzCspiK9koKMp+6NxiGkYhf6N4QWfhvxZR6eG/OKTdKvQMRBRE/WCpuQRqCPY+YrLMH6wLl5MOYILY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794967; c=relaxed/simple;
	bh=K2n4qXBo4Mzoifj+LRLBuKgtYEwemfFOKhehuPi4jGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4UaynhK0NztO4l8ZAjBsJepeKopGgmphiNfnoDM9Pm7iWMBNPmstGWzK643y0X1RnQ8SfTUPFpCj/0sYVPiNfpv+kJgi80416FBbxpXk3Y91J4oN9f00MT0mEXeuCQ8Qt0wFLozkwc0ugrGUxQC/W3BgnQY/Oo2WnmSrjS6bes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DO6HYi3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DO6HYi3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54D41F000FF;
	Wed, 30 Sep 2026 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794966;
	bh=32fnGWlu34ZCwDd26f+IGIwTFiNIjPYkDjs0DZrm6LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DO6HYi3PbITHTZOEKOhW9JedYi6BxcqHSN3aTokcJLWJeVr3YvHXL25+R1ohp7s5Y
	 0KMOT2Ftwnvhv0i0OPACq2mGcbOZuT0fOEsW+UwwenxiBlZVcKIdH9SvzaNEJQ1VKh
	 t+R3VWqMnXGo5mop0yMgb+0OIGtRf3JLNajRwuuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Milan P. Gandhi" <mgandhi@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0396/1193] scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()
Date: Wed, 30 Sep 2026 17:18:00 +0200
Message-ID: <20260930152442.986169490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index a43d0a4076094..5c10713a9dabc 100644
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



