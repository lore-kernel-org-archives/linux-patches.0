Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2A225DB1C;
	Mon,  9 Feb 2026 14:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648331; cv=none; b=XZkBbAgCxXjOLzuQFxdD6bMO42oTRHJ8BHrKiJwqKC+mtOhhvTLmqVlydbi/9vbReyZ3QytTV+l4gbVurgcqCvfti1UcBPS0uCIdSBllEg7Bx8wM21eDK+/E4w/5kW6NQrEvEfA6R76P8SLGxbQN9XcgVgfCPNahYU5i4k7Fg5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648331; c=relaxed/simple;
	bh=rXkrzjl1z6Wb2RAZW9bMoLsMFe3GTekuugThi9zK4dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ea2xfQQjPv4951/BJoUFBmTLxwkK/ApMSPsRtpPsg5nvHz/MGu2SdZGEs3z/WWtIEe+JG53VSYzjWuTTyS679lRxIOzZpWMrxPdZ4Zc6M/YNTB+Iy8DiaEKrLv1/d2/a6DRArtkM7KqAUVwKQhuHP46I3ZMymLN/Hywau1NXd5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5qp6lNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5qp6lNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE08C116C6;
	Mon,  9 Feb 2026 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648330;
	bh=rXkrzjl1z6Wb2RAZW9bMoLsMFe3GTekuugThi9zK4dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5qp6lNVv3hQoCX+k4ngUua8bn322rmylk/Ccw0XGo7ljBoQqhN1JZzt1Xby0opld
	 Bi9cEiZ9a2T1BgQ2nsezPls2017+udlfmi4n1P9vV9fS3x6R3M8QinGA1U8IX0l3H3
	 O3vmZxP8wFrMarp5JCWINpUTy5WxBF71sX/zLUNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Zhaojuan Guo <zguo@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 43/69] scsi: target: iscsi: Fix use-after-free in iscsit_dec_conn_usage_count()
Date: Mon,  9 Feb 2026 15:24:11 +0100
Message-ID: <20260209142303.472810648@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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
index 61bcdc33f1230..438f6448cd67a 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -857,8 +857,11 @@ void iscsit_dec_conn_usage_count(struct iscsit_conn *conn)
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



