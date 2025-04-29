Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0AA242D73;
	Tue, 29 Apr 2025 17:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948833; cv=none; b=XB+a7wYSAZ1k4iSOYeyat8S+VGqBfrH+NTxGbbcp1OG935U+Oi8h5DdUgMb4x91Wefz9fWV05kE/8QuACWwaZy8jQucU5aC7cnZbtWN2EhW9aDbHWHjhYnp8zjUbc2Bq1NDQSokjTNYXJfEy1kpCy+XkSejN7WFaAtrS0Dyb9vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948833; c=relaxed/simple;
	bh=r3Ki7FSyP+qPXGyZZccEvhs8JnLIuqCq77ngTIubUhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhRdNSioyu90kBB8pNQtAeu3LF1Mdbisr73NMz5/nTez1KZtE2G9iGne51Ji7zt/zW0ASjBO6+3vI+igHkHVs3UIX7XkN+7lZvqINVM/yR+y/PD6CInMHE1ewavzC/woUAg4ANNgp2BRiKN8sr6xUZ0Rfk4AKRhp7J1XFai0mLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQF0Y3g9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQF0Y3g9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB58C4CEE3;
	Tue, 29 Apr 2025 17:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948833;
	bh=r3Ki7FSyP+qPXGyZZccEvhs8JnLIuqCq77ngTIubUhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQF0Y3g9qZfTUriUb4ThAMUmtpoM/vgkhCN5LKPOt7BtEhB8mkaLAGANw3KUitgqC
	 c5inhQvqL8I2fPcWi86chnHsRbh9ZTqQHa5kY0VTN0kjwjvWYLEe0Ck3Q9tRWqoCsM
	 vY19WChNK1HCRIHBg7/EtQXXKPzk7fiYdbG08hMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/373] scsi: iscsi: Fix missing scsi_host_put() in error path
Date: Tue, 29 Apr 2025 18:40:08 +0200
Message-ID: <20250429161128.557019048@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f839e8e497be3..8930acdff08c5 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3228,11 +3228,14 @@ iscsi_set_host_param(struct iscsi_transport *transport,
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



