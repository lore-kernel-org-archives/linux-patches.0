Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25497398911;
	Thu, 17 Sep 2026 15:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658865; cv=none; b=tE0cmtsIjEXis0VOyFBIha8BEw/s4sFZ9Ksyy1MK4zwybdrvRL7+xRQpz3VdgvZSjzv0NrELPOkSuNupk/cPjxtnBznP8UwKPYtu2RVyNXrnY6twFX2WSOXClCkAD4bny8Kj+EtHjPVFnJ5oQ6M7tGWKG0dCZ0nRYisyr6t0iKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658865; c=relaxed/simple;
	bh=TU1bpUc3U6jyvxtQbJjNIlkDpg+hIRDLeK4ml5limCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNrXUL+Uvc6tG4vK3UoIhZTE42nJD9uXq9ZQ61w9EaUVAaXaRzQ6rzia2llnqHXqC6ImCIdJlGbxIPmOedcq3cl9gAiWg9MvxIb0tTJ8rilLtO8mCwLgc8yy+v7r7em+/GtT+gaVewAXEu4T1dtZjHPSiko4jLESmutdf1oV9RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAyiiYPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAyiiYPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167D71F0089B;
	Thu, 17 Sep 2026 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658850;
	bh=BTMoHFcllgVt7Jj2fF4+eBv0rGlfepIfyBQ+iDjfmuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAyiiYPxdgSU8aypevQ7zru9N/5hYXm896zuUrfOCf3hmdk7uYUHr0RSXiBrxbRTw
	 Po9EHj+72Ke5zQhXViz/crZ/kyL2Vn9KjcKn6/1YYfjLVYTqsUMX9K/ezXA++27dqE
	 CSxo2MXKQHpcIaWZhB/d4S3npytZwMuo4SVbgMyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Milan P. Gandhi" <mgandhi@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 060/733] scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()
Date: Thu, 17 Sep 2026 16:06:08 +0100
Message-ID: <20260917151352.315399042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 240f67a8e2e3b..ea2c04384a0e1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1428,9 +1428,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
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



