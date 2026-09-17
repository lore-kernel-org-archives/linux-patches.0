Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EAF4F4CFE;
	Thu, 17 Sep 2026 17:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665199; cv=none; b=kpE9j1kGUfZ6LikaAVsXN6NK82wTi3RjhDCjVHYw6EGmQ/hibJyRlikNXZyhQSb4UWkruXV7ODy3JSKvHJocZFROGh3uJInZe6cHsI0ow4juVchzx2967y3Ddv/ZvneyIlajpOFo3NOkz8qKaGIsXl60L/J4082Mx1nW/o1dvtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665199; c=relaxed/simple;
	bh=IodtzkzOK0nHtKoRO1dYp7zBPNxQofKiW3pF/JwY7yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udczvVuvnd0lTNoRurIHWanXYAyG+xauu1LKNbqsCCsZwvApDzcCzJuwWcGiEpZ7ljXQmCHH2i+WoxmEQk/CyOxxmftGXvlyo3Ft9TCTVYN1gtPjK/QaleJmOgyMebJb/QJGHV51RxspMJ4Mi7xgvYyq/tSLXAArYC0Cc1EEzkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pww6xD/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pww6xD/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876DD1F000FF;
	Thu, 17 Sep 2026 17:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665198;
	bh=BoZqXpMAqlu1QRxB9xuJam7s0YrpIZnk/qRi0DMxJZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pww6xD/g9handjDItQR+darnDCsEaOUotNf/mZpaH+3GWz7F/NNwkEczxkTZ3RFwn
	 W3Lyj/TvndGfRDBdGhEVYkEjSwNMX9MDUF8bgW0kwQd9jq01Ug/DkJIqzZDGjAtxqk
	 wiP3aGnzZpyQNPleVm0sw1Z2WZZhYZ01fzCUjvCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Milan P. Gandhi" <mgandhi@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0625/1250] scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()
Date: Thu, 17 Sep 2026 16:07:00 +0100
Message-ID: <20260917151608.818610150@linuxfoundation.org>
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

[ Upstream commit dba9e2181ca5e875f98b8b9b4535cdaab87dcb0d ]

sas_port_alloc_num() can return NULL on memory allocation failure. The
return value is passed directly to sas_port_add() without a NULL check,
which causes a NULL pointer dereference.

Additionally, if sas_port_add() fails, the allocated port is not freed
before jumping to out_fail, leaking the sas_port structure. Call
sas_port_free() to properly release it.

Fixes: e22bae30667a ("scsi: mpi3mr: Add expander devices to STL")
Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Link: https://patch.msgid.link/20260812103344.174247-2-mgandhi@redhat.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index d70f002d6487d..4b917659a16c7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1430,9 +1430,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 
 	port = sas_port_alloc_num(mr_sas_node->parent_dev);
+	if (!port) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
 	if ((sas_port_add(port))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
+		sas_port_free(port);
 		goto out_fail;
 	}
 
-- 
2.53.0



