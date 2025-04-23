Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D00F28C5B2;
	Wed, 23 Apr 2025 15:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421866; cv=none; b=RRlonYaUqfj97NCNrb3mUlFxJCZMA9hy22ffUcOQETVhvuB02+kvYFnEdzhHeKjBJlgzBMjBpLfl4HI86MqWTXklnDytBjLuhdQT1PrwQYjXOB/JnJnjBnk4/PSBLn5WRc1a/KcGRtviZFf1eg/nZsQF6YELsPIWchCfuc1IASs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421866; c=relaxed/simple;
	bh=LQCyjDzI4XJcsikgZvaxnHmtAzvYUZNqAE5FJ288yi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqeTEpqw3y2FiSzo14IRWOFTxBkK8eGjuPBKdkC/cc9RapdAgBWXqkhK7kLCzlawwB6x4CZuxr0Fcj4UFaY8qYW8N6Lr5nZyR1SWVYUZoyFSfrZpHAveI7wcKOfgmsbLuUYo1ukYMw7wWjYhNpfBPro+PRIrLwSdHU4pG7vKmmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQXctAtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQXctAtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2A0C4CEE3;
	Wed, 23 Apr 2025 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421865;
	bh=LQCyjDzI4XJcsikgZvaxnHmtAzvYUZNqAE5FJ288yi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQXctAtYcEuHY7GN5/h2aii5Z+EfJkDYctOsAHasZynnXsydSswYZBiEJ4amKJAVh
	 Xpw6e4CkgE9zvx/jF+eCO3+fxYUJQgGzMgqYpkLcPj9xJ24r2TL6RlaOqShYM1Lmqp
	 Bc2m5AlS8/qYe1p4NJQKxTttLUvYUPjwPItVOT74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/291] scsi: iscsi: Fix missing scsi_host_put() in error path
Date: Wed, 23 Apr 2025 16:42:39 +0200
Message-ID: <20250423142631.333637260@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 687487ea4fd3b..7f0fd03dd03bc 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3207,11 +3207,14 @@ iscsi_set_host_param(struct iscsi_transport *transport,
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



