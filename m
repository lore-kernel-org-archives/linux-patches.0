Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9603129A0;
	Wed,  7 May 2025 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644626; cv=none; b=Tf9inzKWGWUrqKpd34A9niphzBlfTodbZ5lk0RSYtqdVH3xwuOgqFw0jJv8G1W+t32DeUVlyH2uBTyCF4ajQfOzcYNzK/2FJTbN8Wlaghxu2Age79Zb+rXBx3V35XlXglmfbhmpQrYwAfYeDVO4z3pWUhS2SWhfKS33CIgaGtjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644626; c=relaxed/simple;
	bh=J05Llo/pFcjScQZ48tRSTk0QUNXg6DmLClf/iRbfnAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFNNrWttAsWaRcaz+KogAidd5AmI2tXmpU/DSQJPGGXmhRusXhZjm18jJhLGK6xxDBvlGEkfys1PzPkWHlrvpcPATuXVtD+l7M/rEdQzWdWCmVUMfDYDN4LOg34cXIGqTFZly734friSTwJe95Q7SXdjDj7Jmj6pjP7Suy3t0Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gh2ZqHzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gh2ZqHzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26262C4CEE2;
	Wed,  7 May 2025 19:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644626;
	bh=J05Llo/pFcjScQZ48tRSTk0QUNXg6DmLClf/iRbfnAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gh2ZqHzmVHQmwxYRCkPEzr07w04yFR30RLF9SV3mR5GRe4YzrTNG+Pc48Muc+uL+U
	 SvS1hiCNGEzq23PO9JdVnCevd1l5IFobtO8GVDj/iuoQu2s3B4qz968ze1OAX6k/a1
	 hIFGFJ/COuTGNhz/LxQtTortytcWqnH/5E5lhpWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Simon Horman <horms@kernel.org>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/164] idpf: protect shutdown from reset
Date: Wed,  7 May 2025 20:39:50 +0200
Message-ID: <20250507183825.225776109@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit ed375b182140eeb9c73609b17939c8a29b27489e ]

Before the referenced commit, the shutdown just called idpf_remove(),
this way IDPF_REMOVE_IN_PROG was protecting us from the serv_task
rescheduling reset. Without this flag set the shutdown process is
vulnerable to HW reset or any other triggering conditions (such as
default mailbox being destroyed).

When one of conditions checked in idpf_service_task becomes true,
vc_event_task can be rescheduled during shutdown, this leads to accessing
freed memory e.g. idpf_req_rel_vector_indexes() trying to read
vport->q_vector_idxs. This in turn causes the system to become defunct
during e.g. systemctl kexec.

Considering using IDPF_REMOVE_IN_PROG would lead to more heavy shutdown
process, instead just cancel the serv_task before cancelling
adapter->serv_task before cancelling adapter->vc_event_task to ensure that
reset will not be scheduled while we are doing a shutdown.

Fixes: 4c9106f4906a ("idpf: fix adapter NULL pointer dereference on reboot")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Emil Tantilov <emil.s.tantilov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
index 7557bb6694c09..734da1680c5a4 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_main.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
@@ -89,6 +89,7 @@ static void idpf_shutdown(struct pci_dev *pdev)
 {
 	struct idpf_adapter *adapter = pci_get_drvdata(pdev);
 
+	cancel_delayed_work_sync(&adapter->serv_task);
 	cancel_delayed_work_sync(&adapter->vc_event_task);
 	idpf_vc_core_deinit(adapter);
 	idpf_deinit_dflt_mbx(adapter);
-- 
2.39.5



