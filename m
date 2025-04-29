Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960DB27453;
	Tue, 29 Apr 2025 17:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946899; cv=none; b=kK4APVeZB4wsCqcUAttP9Cbh6bxPe32kZsVoFPnvhdv4V7GyBPoXdv9JRoiMKRBYXhzs1w2MoDTJSUqBfknV7s7IeXetXqM1ZxhxcqHN3mXaUQDUFB1bTChh63BFCnA+zN0vAULUA3HpDg2YseBIhCvPTqwswgMx340vcqNhZgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946899; c=relaxed/simple;
	bh=0YU0C3/8waK5aMw92QLH00Vpw4ICFQeb14+eOQZnGxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTzrWIUU+jFwny78IyY6gVYVimWI4QYvd2XX/kUMKt85yjdz6rV5gi8e3Z4z1iQBdlRQUH7lDJZjWVFqVs6RVypfTx17WOrZF12CBQy8q+rZf0O61k3vv3YywG8FHrydwdTDke7p61ZokDZKu25f9xtfEItTRbRLn5/p6zq3h24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPnFwebL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPnFwebL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103F8C4CEE3;
	Tue, 29 Apr 2025 17:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946899;
	bh=0YU0C3/8waK5aMw92QLH00Vpw4ICFQeb14+eOQZnGxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPnFwebLsiizLdbfa/LbYvN3Ns75U6A9jzcKYXUyjkkskHkQt9/PlqjlE/UL5YziO
	 siPD03TrWkK3fUiLkfQNS+Er4UZEU/pGzXw6XzH6WKF2C49icrx3sEsVZv+sbZobfS
	 wrrqex4jgxs//DJSlfMNPNFTqLOjEArjXFqPoCSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/286] scsi: iscsi: Fix missing scsi_host_put() in error path
Date: Tue, 29 Apr 2025 18:40:10 +0200
Message-ID: <20250429161112.216188271@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 72eea84a1092b50a10eeecfeba4b28ac9f1312ab ]

Add goto to ensure scsi_host_put() is called in all error paths of
iscsi_set_host_param() function. This fixes a potential memory leak when
strlen() check fails.

Fixes: ce51c8170084 ("scsi: iscsi: Add strlen() check in iscsi_if_set{_host}_param()")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20250318094344.91776-1-linmq006@gmail.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c636a6d3bdcc1..548adbe544444 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3185,11 +3185,14 @@ iscsi_set_host_param(struct iscsi_transport *transport,
 	}
 
 	/* see similar check in iscsi_if_set_param() */
-	if (strlen(data) > ev->u.set_host_param.len)
-		return -EINVAL;
+	if (strlen(data) > ev->u.set_host_param.len) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	err = transport->set_host_param(shost, ev->u.set_host_param.param,
 					data, ev->u.set_host_param.len);
+out:
 	scsi_host_put(shost);
 	return err;
 }
-- 
2.39.5



