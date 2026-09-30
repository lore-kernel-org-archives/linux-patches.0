Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FDF4E7802;
	Wed, 30 Sep 2026 16:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784953; cv=none; b=ck5aveAP5tarbH+8lrUaQQGee7uE2k5J1Gy3UHSmIuS7U0+Kwb4Io4OHW/4gA/FWJJKjFUj0gJRCdMXn1ztdKlNUg0ja1cBKv/o4qjFZzC8b/yHrQsAFTYol0jRvvsZGC/piyYg3P5EA4XN0tBaDPiquQnb9Jds7hHdj7sp2jxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784953; c=relaxed/simple;
	bh=MuBFTvwNZAQmaGa5+Hin7Yc1Rhoc7yFFFgIQqDGzhho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caLC9VrtMW9jvncmXeVn9viM/ZMAajLz4SvrRd4kJmnklNeSvIuaU3nMAC62Zg3TK4XRnhmWLpAz0Mp+Kn/SneUbx4kT9xiGO3Bn4sakH6ze1gUcvKJQylmtm9jnexTQwVM8OAqlvdAKf/OtEJIg8s2hWTXSHiUbmIHpWDhyVTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzkzRgcb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzkzRgcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C1A1F00893;
	Wed, 30 Sep 2026 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784949;
	bh=dFElVqNyN9B0rnW7k8hdbSOw1WdLABsT2KlmFhj4R9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzkzRgcbDMoV/Bod/KQUcon/9a1EmqDdkigHs8zVlQjilx1bViawThSW21QtacCm0
	 R3/fYyOU7iXoStPmjjf/9tW9D7gFGOdNdq9/FSvrXDAFq8M2YZmMovXrdf4/o3ymbT
	 +7pRQhFkmskfiIwfiPvO/rPwZqnSZlyq9kodgEKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Milan P. Gandhi" <mgandhi@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 335/982] scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()
Date: Wed, 30 Sep 2026 17:17:51 +0200
Message-ID: <20260930152424.015929222@linuxfoundation.org>
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
index f5001fadd5b12..b56fa01894f46 100644
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



