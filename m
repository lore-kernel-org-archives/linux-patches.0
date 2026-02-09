Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5EC29D265;
	Mon,  9 Feb 2026 14:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647450; cv=none; b=oVBtNfUEprvtLmU7CwJ92EnySmiswQ7W/s9l4UlqLZmwjeE5O89Ft5JQi/aECffeYUc4T7xXmHNVi14L8S5G7+QE7yRnFh8B2j050aV/1zkwxbVfdxMKTnlACz5QdNxu1ItwfMzkixRlqJRDkbVamEHFWJbfQ6Wn/ASgF6HWyPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647450; c=relaxed/simple;
	bh=+YeeuDF4R0zXq/p+6aU3R8R0jb/cUmdjtfFGHo5zprI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yqeu4TdvxUofkj7e6pz+XvsAl+GE8syVyhwcNR3SIPdHPRgC7Ve8ySfG2x5FsdyKojU4o2tA/EYzts/+tdKlYkpUgWuaSdjHlPcLJV9yZ/sCNFPauU8e6KYvj5RS4JTKliqVeW2iVdib2rd3BnUl9tTyi0aS5+wdkm6R128rFpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwR3m0Mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwR3m0Mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E438EC116C6;
	Mon,  9 Feb 2026 14:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647450;
	bh=+YeeuDF4R0zXq/p+6aU3R8R0jb/cUmdjtfFGHo5zprI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwR3m0Mk+CcE28kFmqo04MFuUR7bEMBGj8yCev+EE5GTyZZS//3CgMtxuSOxEuM8m
	 Rdg17WqhhLe5jydaZFYtT35+zk4meNAAq90Q0SbDOAUKthVTGphSR2zHSrbDwiTjMx
	 7gjzr9tAHoe2Fn1n1EiEPUsRE9KPGJ/05cD+UtKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Zhaojuan Guo <zguo@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/175] scsi: target: iscsi: Fix use-after-free in iscsit_dec_conn_usage_count()
Date: Mon,  9 Feb 2026 15:22:57 +0100
Message-ID: <20260209142324.156884268@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 9411a89e9e7135cc459178fa77a3f1d6191ae903 ]

In iscsit_dec_conn_usage_count(), the function calls complete() while
holding the conn->conn_usage_lock. As soon as complete() is invoked, the
waiter (such as iscsit_close_connection()) may wake up and proceed to free
the iscsit_conn structure.

If the waiter frees the memory before the current thread reaches
spin_unlock_bh(), it results in a KASAN slab-use-after-free as the function
attempts to release a lock within the already-freed connection structure.

Fix this by releasing the spinlock before calling complete().

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reported-by: Zhaojuan Guo <zguo@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Link: https://patch.msgid.link/20260112165352.138606-2-mlombard@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 262a3e76b4b1c..c1888c42afdd5 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -813,8 +813,11 @@ void iscsit_dec_conn_usage_count(struct iscsit_conn *conn)
 	spin_lock_bh(&conn->conn_usage_lock);
 	conn->conn_usage_count--;
 
-	if (!conn->conn_usage_count && conn->conn_waiting_on_uc)
+	if (!conn->conn_usage_count && conn->conn_waiting_on_uc) {
+		spin_unlock_bh(&conn->conn_usage_lock);
 		complete(&conn->conn_waiting_on_uc_comp);
+		return;
+	}
 
 	spin_unlock_bh(&conn->conn_usage_lock);
 }
-- 
2.51.0



