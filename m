Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB224F4CFE;
	Thu, 17 Sep 2026 17:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665202; cv=none; b=I4UJsY7eZK2pRlBxxaPAMnHLxZiBp4PNVwyc0W8Jf/amP3nJHpA0LxK81afTwqsHFH7Y6fUnXDZSQ1ASXLE7W/FNV99VroVi2ZQZ3DC2+NlmVAjdWJskaEgmBSrTCDT+pCMZV3HA+xiQDHaCHXjT3po5oCcbT945f5DAnUCoOJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665202; c=relaxed/simple;
	bh=KJdCeqZfkh4bSKYzVCodwmF9j1+R73g0OiYTdfU8UwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsjbGvMSq8gLJblzgtG2031BDA8n2AGK8CzubLMyQio8l48YL95+BtjkZMPUjtyGU8usvfmqslDDipHv7Y/xf8r0GweNHL8wFgLIYHk2FVDkVQ5rjlDqTcN/1glbf6KhTgoBU42d6a1MVyS8p6XJ913bw12WDOuWc7JeddnM8SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOjtNOln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOjtNOln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790091F000FF;
	Thu, 17 Sep 2026 17:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665201;
	bh=iTh+lKYkRZKSNpYpWAwV6+EsLdEoaWrxFPnzFA0EIL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOjtNOlnUL/sIUIcNT9l7KtM+CaaqBPJGDGNNcjPfGKyJTuPbJLxshDWO//NrLxyu
	 Kii1xjoI/RYPlDiyA8poLN3D7C8YHyu22gxQhpcF74nndJK2NYBFoH4+YiUZKWDmHs
	 pn0G5xhzRPdnK2zVRWW/6wuf5TAeUn4CnP09C0E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Milan P. Gandhi" <mgandhi@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0626/1250] scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()
Date: Thu, 17 Sep 2026 16:07:01 +0100
Message-ID: <20260917151608.845559528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 4b917659a16c7..a34b0f2e1f5b2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1509,6 +1509,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
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



