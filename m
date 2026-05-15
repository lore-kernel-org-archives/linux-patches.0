Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D05F3B9D96;
	Fri, 15 May 2026 16:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861619; cv=none; b=TLYnwn0XclIMGuObOEK4J/+XXH7HaFRJjltzZkqu4hp6Welu2CFkEscb3SseA47KmGo5YJ3nb64zEe4/PLZ6HLK9f8+HKZ/T5a7aNMElotX6yqb49TSLupeK1AvWmxDdTADiF9hly9l0UHz6iByky9qoi5lIfC/WcEveMMfjm0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861619; c=relaxed/simple;
	bh=k9gZJmZ0M3yrgl4gHMopTGC6TnwD0R9Izm4STGZQR6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1i14nrTBHRPdM5CiEX/faF+J8lvuKGe66c6xMnfOHkE23+xH+0553vcjE1FfsFGm2PV8ht94MYzkuwGYfjQcIViMvEl8jegrz8D+hnrc+kFvAzFHKCc3x6HmtNbLqFp8MDPMhlsyp8eoF5M6399FRd5fJp4RxsgqjNlHFedcSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0edhaBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0edhaBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD717C2BCC7;
	Fri, 15 May 2026 16:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861619;
	bh=k9gZJmZ0M3yrgl4gHMopTGC6TnwD0R9Izm4STGZQR6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0edhaBL4Ognd/or1xwkWUjtWUrkvq33fV5SEsfzJW5gSybihll1wbOgz50GBIKz/
	 pqj3fIIasImj9rAoECmvV4O9eGBl1sOZwyF4geq3EbenTz7PnaDDidhGQu4a3m43Xr
	 Qb0maE/Pqsr+JdOQeyNTZRcwZteTXJc/TlnTjFWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 398/474] xfs: fix a resource leak in xfs_alloc_buftarg()
Date: Fri, 15 May 2026 17:48:27 +0200
Message-ID: <20260515154723.658383462@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 29a7b2614357393b176ef06ba5bc3ff5afc8df69 ]

In the error path, call fs_put_dax() to drop the DAX
device reference.

Fixes: 6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ kept `kmem_free(btp)` and `return NULL` instead of `kfree(btp)`/`ERR_PTR(error)` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2045,6 +2045,7 @@ error_pcpu:
 error_lru:
 	list_lru_destroy(&btp->bt_lru);
 error_free:
+	fs_put_dax(btp->bt_daxdev, mp);
 	kmem_free(btp);
 	return NULL;
 }


