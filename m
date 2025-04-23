Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1422928D836;
	Wed, 23 Apr 2025 15:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421921; cv=none; b=CidrSWEHNR4gKeIrsxPir3kobIA3Pnt0cz0i9ahzoZlkLEvZt//dd63gVlHyLKUD9egSeLbM5qRVqT972NScEBxEHhmTUGsogJE4b+DvLxhVdGD81caFLJKVYBZuIuRpB6nD76v1CcLZffyL2iHWJAlwY1oButYTjVcFLdpyb+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421921; c=relaxed/simple;
	bh=sgd6GNaVjcm4Jk9f7st5Vly7X48fRaIBxZcchqpdJ8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yv8M57rCBz52elNEyCIf3xQ1oSUG+2y0mVwoZt+2grvO9L/RTLkt3hkto4r+bNmpOUs+L41ys3rZTWWTwYopYJlXzwMR+ouHjR1/J6u9sE3effkIEbpjLIiQ9zLdgMZzB3R7Cro8sPZJ8KynVvWGbYOvgsLQPEV45fGU3/gW4jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6p+86jF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6p+86jF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3513AC4CEE3;
	Wed, 23 Apr 2025 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421918;
	bh=sgd6GNaVjcm4Jk9f7st5Vly7X48fRaIBxZcchqpdJ8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6p+86jFtKjzDOx7TjiMXD43Jk59outcskD55kg+ceQ2nqyuF50EkI3AYyAxlLGG6
	 T1Wz7sknuVaJLecDmKQ8+ANsTwR7cyaFQv9g23y/l+AVB1NywVPfSJu5QPqLkoFK6H
	 ZdhjD8tNxOUUZzz2eLqCNfWOimlWW73xLEYs7ZDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 245/393] scsi: iscsi: Fix missing scsi_host_put() in error path
Date: Wed, 23 Apr 2025 16:42:21 +0200
Message-ID: <20250423142653.502319334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index deeb657981a69..0c30fec555475 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3208,11 +3208,14 @@ iscsi_set_host_param(struct iscsi_transport *transport,
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



