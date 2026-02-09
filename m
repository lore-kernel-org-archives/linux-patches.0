Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E96836828A;
	Mon,  9 Feb 2026 14:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648027; cv=none; b=eqTdhzjitT0FONJEdaBSvBj/r7g75uKZ9BUTDcvVIa1kRSpLXwJTqRUAFnn9ma7/D+/RvYSigqUk645RpLNQnOQDxEqF/R95A3QyxkIXW9bdS95ncpFX5NuZu1yXIo+66mn2Dckrkb0PJKSrvnvN+kJ35dcd8BXr5hiKQh3SdjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648027; c=relaxed/simple;
	bh=LTd8beAHCRgV/JGHspvTzFEgLEdwKhiV80R8S0poiMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+Jl+cmCNcjtEl4vqWWtpcsuM5t6gNH7CD+9tF/do05AwBBVm4Iry6CxS8m0rMIh9FItzBBFFVOVgX5PAQOfSqGMOjpXg6yVNB40peHGfoE2R7SM6cRmpYqs3c9y+jL7uCVQjYkMc5fm596E5I37pkc4QJJ45AsSElciN8M+1ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyqJFHwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyqJFHwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC06DC16AAE;
	Mon,  9 Feb 2026 14:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648027;
	bh=LTd8beAHCRgV/JGHspvTzFEgLEdwKhiV80R8S0poiMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyqJFHwgho0MQ9TpcwMvgrfrGZ1Q+0Mp45eZMNd2qbwp1BqKLIzYm7McNO9icc3uO
	 IgF6caUO0ze+ytJKR6Mdn0mFR4dg01+oBC7W0GPbb79F4BpkZ2DKhu0xcnrjuRbTot
	 e4fjUq6tLoBqB8PU+deoXmUyV8eg7Nm49Hxrg+Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Zhaojuan Guo <zguo@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/113] scsi: target: iscsi: Fix use-after-free in iscsit_dec_session_usage_count()
Date: Mon,  9 Feb 2026 15:23:35 +0100
Message-ID: <20260209142312.564484217@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 84dc6037390b8607c5551047d3970336cb51ba9a ]

In iscsit_dec_session_usage_count(), the function calls complete() while
holding the sess->session_usage_lock. Similar to the connection usage count
logic, the waiter signaled by complete() (e.g., in the session release
path) may wake up and free the iscsit_session structure immediately.

This creates a race condition where the current thread may attempt to
execute spin_unlock_bh() on a session structure that has already been
deallocated, resulting in a KASAN slab-use-after-free.

To resolve this, release the session_usage_lock before calling complete()
to ensure all dereferences of the sess pointer are finished before the
waiter is allowed to proceed with deallocation.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reported-by: Zhaojuan Guo <zguo@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Link: https://patch.msgid.link/20260112165352.138606-3-mlombard@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 91a75a4a7cc1a..ee0cf2c74952a 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -785,8 +785,11 @@ void iscsit_dec_session_usage_count(struct iscsit_session *sess)
 	spin_lock_bh(&sess->session_usage_lock);
 	sess->session_usage_count--;
 
-	if (!sess->session_usage_count && sess->session_waiting_on_uc)
+	if (!sess->session_usage_count && sess->session_waiting_on_uc) {
+		spin_unlock_bh(&sess->session_usage_lock);
 		complete(&sess->session_waiting_on_uc_comp);
+		return;
+	}
 
 	spin_unlock_bh(&sess->session_usage_lock);
 }
-- 
2.51.0



