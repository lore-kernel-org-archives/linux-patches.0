Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25360285073;
	Mon,  9 Feb 2026 14:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648488; cv=none; b=Fe77FrzV2q6FGF+6LJnvTMmvkeDgGgRwBZ18alAMrJQ3dz6Ea8HWRe5a9395/yYAsBGaF6ghdd0AtdXoY98amWD+WrfgKOg5WKBEx5npiz51r7nIeZQY1POps4SCn14tH8bd/IgDzSk9THL0tNcALO+0zdGx78RbeCnIczwxSQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648488; c=relaxed/simple;
	bh=QTVf3NzIsknEa8kpSYKaIGOsktXsrBruv97HOr2iPKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KI75rmqJHK/O9KgEeVa/zse+xLB3g0Z5JXo67PafRj8JOhQNgZgCY8tcrgrXo7CvFnYnaS938KOja8G5t3oAcEDsuO4nh1nslId+VmvUg7zTPVTMUca58ZxkhVKvLLAGS7QGsEzZAdainon4CfaYhznt6txcOicqgCUiInIuG48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WZp7GT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WZp7GT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D220C116C6;
	Mon,  9 Feb 2026 14:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648488;
	bh=QTVf3NzIsknEa8kpSYKaIGOsktXsrBruv97HOr2iPKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WZp7GT72fIXuIBqoTErXwLJzmWt3W9RcgLpUrFRdYVyeIVFa6QbfxO3Qh7QEgBL4
	 6hNMgbIzDwPONon458WA2QQTtno2BsifoOEcBB+LW/ruqfyqOWUCE23/tuHwJYntjJ
	 lv2eoJJRN/1gI0Jxlbf4Lnz9JbdQdLN9l17v1ZaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Zhaojuan Guo <zguo@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 51/86] scsi: target: iscsi: Fix use-after-free in iscsit_dec_session_usage_count()
Date: Mon,  9 Feb 2026 15:24:14 +0100
Message-ID: <20260209142306.618079477@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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



