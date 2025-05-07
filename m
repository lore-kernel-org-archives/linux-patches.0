Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6961CF5C6;
	Wed,  7 May 2025 18:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644182; cv=none; b=W6VyxQ6kZweJ8NFwCu+mWFgSHKZGDkCfEzxAwa9rSvAmk5Xz2powKk5s2VbXvAJAfoMc/GAt5eZLUQyh0zj1EWeOivzuO3+ySoBzDxDhManibDil7NNjHPpUgqOfILT09rff0LpD4C4K7XmVPNfC3qdKaoCyIG0UB1VXBQFhzc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644182; c=relaxed/simple;
	bh=q1w+9AjYB8OJIdsqj3j6jE+V8w9tfexaQSaSYOKcE2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lr1c4YKgxc6p1H0ZwAmdCdNThnkjbCPgszBmw8LxPtFlKNCQI5Wamd3BzC1FlYLcd3RZdLGE5GzuVQBdT8V8QiEZnZU23agcYwP1+uV+rgZFjy1nGRB4j39n5KAm9lB+npMku+KWk+ve7optN6Ktl6UUHk/17+EA/EfOfg+cjkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obvj2MWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obvj2MWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEDCC4CEE2;
	Wed,  7 May 2025 18:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644182;
	bh=q1w+9AjYB8OJIdsqj3j6jE+V8w9tfexaQSaSYOKcE2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obvj2MWHxjfQML1kYiXWurx6GplR2eFgdyM57pJlvgNUPE7terlwZSHNbTgJxajXr
	 m4/tmeh67K3km4T2pkQ5eRh3sxpaPl5QMO06r1WKg8lCZOyJWnpxlO9myfL3hc1RYt
	 WtRHl69qhFJnSLrVRWrm/iiVjpsf9Wly5Cnps2Qo=
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
Subject: [PATCH 6.14 115/183] idpf: protect shutdown from reset
Date: Wed,  7 May 2025 20:39:20 +0200
Message-ID: <20250507183829.483356254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index bec4a02c53733..b35713036a54a 100644
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



