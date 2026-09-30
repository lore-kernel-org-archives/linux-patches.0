Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B073CEB9E;
	Wed, 30 Sep 2026 19:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794964; cv=none; b=VoA3gJkPqh03K0ULiptM2Vz+rqGb5PCdhFdqDMlSjoRMKOQJ+Avia6s0JYG/cdnRQRkm4BvUXYu/n4vKMdAzumMCL4UgXpfMHg3W2NiaP6jIKPxHjJcFJL0t412Os769886RGKV4/eb8pnDtHRmMvqzylKbIgdh+kwkHvhI+w4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794964; c=relaxed/simple;
	bh=hwFzW+rFUg6t63M8D/ivg958j2UGl+KD6fia7VrWcCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGJd5j4tR+U+PaCdgcSH6fnwdzUA3YHP4iu/2KL/o6vDPgSkWjFHBZIuGTCyM1pSSS4Q/COPLV0klLSl4tF7scksXDv5dYHlC0+3HN0vt+KeSP2QPMrksE/FHBQGyeTRpejEQhVMB0kNv3pGvjXI2HRgY2ZEXDfRCoP7HgrrlKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLJ61ujz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLJ61ujz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2541F000FF;
	Wed, 30 Sep 2026 19:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794963;
	bh=pwgEthiAimz0ei/a1c6r1XqhGm/fwGbs6hn13h5XLNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLJ61ujzRubiX8BU9RlGe4p/Z99lJouYsXzBygcW1+5BdPvt7i+wPBj+Z9NQ8P6sD
	 DrQlJ4+/rL9Jyk2mqYUUWr292Y2aWJjUZdd9MEwvaYqPKwpLMHk1pA/+mrYwJK0lte
	 +lVaEEpUQhCT0mSP5qRDP89sfDiOkLen3LZpThS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Milan P. Gandhi" <mgandhi@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0395/1193] scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()
Date: Wed, 30 Sep 2026 17:17:59 +0200
Message-ID: <20260930152442.963354305@linuxfoundation.org>
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
index 0072bbdb265b8..a43d0a4076094 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1404,9 +1404,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
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



