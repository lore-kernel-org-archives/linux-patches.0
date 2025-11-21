Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E79830AD19;
	Fri, 21 Nov 2025 13:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733333; cv=none; b=X1JDclIdQTHPLJW3FCcjy5EfhRokdblq5BRuGQbsEbmK90O6CNYVOa0tlvCBHpo64xUPacSXNXXn1Q8dpYINtVHniDSswyyOxNP32NqYLneXu9g94c86HmkbewMm/WlKS9mcTaibuckUcdhXwXOMh4ZLe98Pd4Y4WiNh7TL9Bzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733333; c=relaxed/simple;
	bh=RjRXkgWeRDljy4YDKzBHp4vC+mzKkUBDk26O8N3iSw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBH69yASAQ1fQoTRjnsBVHOZ4fBzrgDY0xKAzW+LtoCaTfyiUgyTKM6aVS2ovAUzEs7ohUPuBytAWQqvxn9/v6I+DT+FcZVZRv2VZlTOBPb0skAvH2ljwmvaWScOa4bqbZ3Rod8gOIj/HFqwD4ocAZju7Auozoix8mk27MfP0CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peiruWM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peiruWM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F011C4CEF1;
	Fri, 21 Nov 2025 13:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733332;
	bh=RjRXkgWeRDljy4YDKzBHp4vC+mzKkUBDk26O8N3iSw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peiruWM7juv/GqzAsIHDxBAorHo/GeQqIeNvHDDxI9pyUoREZFEEnd1MxUc9GyIwM
	 YyK3es5uS5M+8Zjgb6BGx6mgLiMDJXdHuP/a0XE+fERNGbMw8D6wS4+WmJAaso4yCl
	 GaTtSsf3uHjHb/+JBGlrb0dCbKPR8pMP7LrWT5Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Benjamin Coddington <ben.coddington@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 433/529] NFS: sysfs: fix leak when nfs_client kobject add fails
Date: Fri, 21 Nov 2025 14:12:12 +0100
Message-ID: <20251121130246.421242067@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit 7a7a3456520b309a0bffa1d9d62bd6c9dcab89b3 ]

If adding the second kobject fails, drop both references to avoid sysfs
residue and memory leak.

Fixes: e96f9268eea6 ("NFS: Make all of /sys/fs/nfs network-namespace unique")

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: Benjamin Coddington <ben.coddington@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/sysfs.c b/fs/nfs/sysfs.c
index 784f7c1d003bf..53d4cdf28ee00 100644
--- a/fs/nfs/sysfs.c
+++ b/fs/nfs/sysfs.c
@@ -189,6 +189,7 @@ static struct nfs_netns_client *nfs_netns_client_alloc(struct kobject *parent,
 			return p;
 
 		kobject_put(&p->kobject);
+		kobject_put(&p->nfs_net_kobj);
 	}
 	return NULL;
 }
-- 
2.51.0



