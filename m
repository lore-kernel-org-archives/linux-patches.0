Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E28188A1E;
	Tue, 10 Sep 2024 09:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962360; cv=none; b=CNBfIOqschBUq9mKAR4C19smaKm0vbe6eqDoxTCqBmS8F4ChNe7jMCHy4VyWAHGHb8XB8v9/XU2vvXdgj32LJehvxn+U0Nb6mWtlVdx6xRusIRljbttaQoLYWYBpxHN/0JnQHSxARcR47Xz9LNT8tIdMAIQmnAm9rYCwUTF6n7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962360; c=relaxed/simple;
	bh=yv31dHj3CY/5dLt+GxiBCP15vhsFOE+bVsJB3s7DgHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSlildP9UaYGwEUqKOkHxyfn610C2RfZQGP6RPxfRylCg/XwY4c9GI94580ds79kpz1Fg5XjsKkBM0q5VyWl/A7Vz6z3ZwkHPJGr3rHcWJVbv4M4gxzhPWFZdHXaB3bE2qyifw6jUPvJR0KVKI2rIGKJbjAvilkI2L31c9sDhwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXOYQ1IW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXOYQ1IW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06713C4CEC3;
	Tue, 10 Sep 2024 09:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962360;
	bh=yv31dHj3CY/5dLt+GxiBCP15vhsFOE+bVsJB3s7DgHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXOYQ1IWp3S5qCdj2kVUSY+OUuSKckz1PLeR/emUxbMKuki/cCJWPbRouy63dA2B8
	 8l2ul+YA3WZFSUZwwjUPTHzCJzRWt3nMin7zLaX/zkUHIj1ebg+bkRMv6FacWxYF/3
	 di18A9o6X6Zv7C/usRHCX/t5hxAeJdqOHwvtwqPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 368/375] nvmet: Identify-Active Namespace ID List command should reject invalid nsid
Date: Tue, 10 Sep 2024 11:32:45 +0200
Message-ID: <20240910092634.985048567@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 899d2e5a4e3d36689e8938e152f4b69a4bcc6b4d ]

nsid values of 0xFFFFFFFE and 0XFFFFFFFF should be rejected with
a status code of "Invalid Namespace or Format".
See NVMe Base Specification, Active Namespace ID list (CNS 02h).

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index f7e1156ac7ec..85006b2df8ae 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -587,6 +587,16 @@ static void nvmet_execute_identify_nslist(struct nvmet_req *req)
 	u16 status = 0;
 	int i = 0;
 
+	/*
+	 * NSID values 0xFFFFFFFE and NVME_NSID_ALL are invalid
+	 * See NVMe Base Specification, Active Namespace ID list (CNS 02h).
+	 */
+	if (min_nsid == 0xFFFFFFFE || min_nsid == NVME_NSID_ALL) {
+		req->error_loc = offsetof(struct nvme_identify, nsid);
+		status = NVME_SC_INVALID_NS | NVME_STATUS_DNR;
+		goto out;
+	}
+
 	list = kzalloc(buf_size, GFP_KERNEL);
 	if (!list) {
 		status = NVME_SC_INTERNAL;
-- 
2.43.0



