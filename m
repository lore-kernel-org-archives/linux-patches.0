Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5310F4CDDF7;
	Thu, 17 Sep 2026 15:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658865; cv=none; b=n+wmbjGFDwTqKN9x/KGQTglDPTd0Otbozys1nCL/GxK78Mo1PfRJ6S+u5xUdRviYb1D7poa8QTrAjIy1psu4kP9WsbYgk3Gqnd82cJBrPPjK7whGOajxtwsNK/TQIMCrQSpMni1FhhubvPwZqja70/KpK8SusRhbyWhpizfEN1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658865; c=relaxed/simple;
	bh=rL2f50p76CMdIhiUtFcdKudHrGCjfE+0T8BUq89k4I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqwnN2/h+sHclU/sTn8C34OMlr6LJdnWhwIYFU5tCgryDMjOU+dJzLvH/vVBWERfyWhmU7nnRM9N6+a4NoIZpmE1odbrbjWM9bXcFN6vp7BrfRVLNt8EDu76LmUzqevhZC3dmfjN3XkDGib/EZm1YpjJpjxfaFFn8ZC6gxgy5DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMS0Ik/3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMS0Ik/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145B51F00899;
	Thu, 17 Sep 2026 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658853;
	bh=sGTUiccBJenbO9Rbv3Fc4nX3JgNMi0d5zvVRkwmEr6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMS0Ik/39WN10zuqVtMiUvYM0cVu2J3Fnxvss5r69oX/lMIDzpn1IJjddYfPER4xA
	 s1pqJsGcJoddG4qNJ8YaYZNtJ1lEROsaekZ1rv2+TZgeQmoeSa0ufZ69sb97XRm7Nf
	 SFdEzODPT+eitXhOHAg+28Ou6UcF0KHT2XFuZ4i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Milan P. Gandhi" <mgandhi@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 061/733] scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()
Date: Thu, 17 Sep 2026 16:06:09 +0100
Message-ID: <20260917151352.343279264@linuxfoundation.org>
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
index ea2c04384a0e1..232af978d7372 100644
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



