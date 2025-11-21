Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCD927147D;
	Fri, 21 Nov 2025 13:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731162; cv=none; b=eR5Wl1+1XXSsQY1so1GvA7giAe05ReVk7YeoqL4zn4Cdw/bj2Oc4lyBxOJ94SVvMKmHLiQO3rUUYz06PI6LG40ea19Lwq4jE2T++cBS9mGiTGwCcoZ1FQkcAobgUydffQaJLsVdsP9/mtaCHXDIJr0IAGfSQP28u4mXXUcJs55g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731162; c=relaxed/simple;
	bh=cDtgWVzAIVW/TbYAOSk4sY2WgH3zogH6fifiHxNX8Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaVYF8KBHH9rg472vaYEDYtnrpYGnqjncAudblOSsHOYXm4N551k/hDduoJYlhQtJykX9vCrbTZ+1PnPDrfrXu+qX1mRPmdy0HsTuABd7xbKweYr2mc1eF/KbipQeaAfmtZOPwuFx7xur0A9wwD0UBmpVREgRBsQB4D9LHvS1kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqMrnTN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqMrnTN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8E7C4CEF1;
	Fri, 21 Nov 2025 13:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731161;
	bh=cDtgWVzAIVW/TbYAOSk4sY2WgH3zogH6fifiHxNX8Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqMrnTN91t5FKzSzvm8DO40buY2aCeuF6Vtt9MGKswWivkQFr1ZESW0UxB9f6apHU
	 jSeXgxmTqv4eh5irTHL/wcBnBmwDN+b0ehbzv62sqsi2dS+27F+lRW9F41ua6Je2Mk
	 UiPB3t3vutk9Bw3D2saKT6zdE5uTk274vYCwv+e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Benjamin Coddington <ben.coddington@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 110/247] NFS: sysfs: fix leak when nfs_client kobject add fails
Date: Fri, 21 Nov 2025 14:10:57 +0100
Message-ID: <20251121130158.532974742@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 545148d42dcc9..ea6e6168092b2 100644
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



