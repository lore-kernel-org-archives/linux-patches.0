Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DC921772B;
	Tue, 29 Apr 2025 16:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945444; cv=none; b=HBipfuIJvjlfkOxEJGdAhBptePExF6De5eBE5mlHv0EQO6brYMrRYJ8uvPoiRJVCdIdMg82FRWzZAR0nVJZjw9I1GxGrGxikHzFbvP6MUJT1KQ+BRXo3ckoRhIDUmvFWaiu3jao4nQ1Ef+8PuuMMssfewVO8KkPK3uFjjzHbyQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945444; c=relaxed/simple;
	bh=8VxMrqlhw7fWFHUTQARcemdzpojW7gt7JnUI38s6oGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8aHmpN3HGZHasG12SchbAUpXEvy8M1S9fsNH8s44IZtlR272qu5leItkEUB69j207jBZl6qN39jVumCxKIvUU/biRd7xUE8v3tLtThxaByD1Z5QDeYONOuy7dtIixo4SUxux1eeAiF16k4tdt4ZvAOz0/kqRbx5oPw4UfRQXws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7nNAvLj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7nNAvLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E546C4CEE3;
	Tue, 29 Apr 2025 16:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945443;
	bh=8VxMrqlhw7fWFHUTQARcemdzpojW7gt7JnUI38s6oGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7nNAvLjV+l9pAMvCFhtqXlgqQ7KapIRfaQP2TPrlLrrk5Z5am8D8Z09pkdRajRTb
	 QoanhzhXG2wtz4/c51ydeyJpMPvtj7pvXqtT+LU/qaWWYSd6eU/dx7nCDD9G5dSH0T
	 dYZfKJiHcpBndTiw7vHhXPwO3Hcsyl1XrP2VG5Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/179] scsi: iscsi: Fix missing scsi_host_put() in error path
Date: Tue, 29 Apr 2025 18:40:28 +0200
Message-ID: <20250429161052.922611570@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9ef242d2a2c9d..d75097f13efcc 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2924,11 +2924,14 @@ iscsi_set_host_param(struct iscsi_transport *transport,
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



