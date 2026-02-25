Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96D120C012;
	Wed, 25 Feb 2026 01:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983348; cv=none; b=tjKgS2HKMSKCRc1eCemjtYRsGImo872eILEA2jh43wj1KuzlWSdw9MF7WnJsFFvLHQcVL4izpLFCVtABlKhWl+rZYCrnj1ufeddtg3bY679koANd17JATxZzc1EXFSpw9cVitrpycHF61yMa1lLHujntqhLk3Nh0luoiDdd7rrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983348; c=relaxed/simple;
	bh=WZNcfxH7l1TeOlHRydgQH99b+K/CK/aRWqei4eDctYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5I0RWxg+Sewe5wPXP6aXwCR3LW+cSFZ8iV5Y+GO/wsdxR/4DXGm8+n0Vit2AP++vWGDGDJ87qNzgCv2b1R66eriHc/WsbGiBCZEQ78qoXDq2uNZmpVWPu+8B/FoW0QJ23HZNY0wF5ei+jF/EqzIXdG4w5DzjFJzMC/SqPAN4HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfVPiNqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfVPiNqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A15C116D0;
	Wed, 25 Feb 2026 01:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983347;
	bh=WZNcfxH7l1TeOlHRydgQH99b+K/CK/aRWqei4eDctYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfVPiNqbo2sPGzgkVP4KGI7/d4T5PsGqUIqVG888j1h2Vlck0wUzeDAeZ8egz9e3I
	 QG4Z7fCq/Egfaga25LIUT21efXEbWtGAZnVVrXCAZVDPOVKcmyQRWr0gqNf/HWBKeA
	 n1JR13D4zbSNnsWLEw4HnxMp7km1rWCBQxTshzOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Etienne AUJAMES <eaujames@ddn.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 440/781] IB/cache: update gid cache on client reregister event
Date: Tue, 24 Feb 2026 17:19:09 -0800
Message-ID: <20260225012410.493613315@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Etienne AUJAMES <eaujames@ddn.com>

[ Upstream commit ddd6c8c873e912cb1ead79def54de5e24ff71c80 ]

Some HCAs (e.g: ConnectX4) do not trigger a IB_EVENT_GID_CHANGE on
subnet prefix update from SM (PortInfo).

Since the commit d58c23c92548 ("IB/core: Only update PKEY and GID caches
on respective events"), the GID cache is updated exclusively on
IB_EVENT_GID_CHANGE. If this event is not emitted, the subnet prefix in the
IPoIB interface’s hardware address remains set to its default value
(0xfe80000000000000).

Then rdma_bind_addr() failed because it relies on hardware address to
find the port GID (subnet_prefix + port GUID).

This patch fixes this issue by updating the GID cache on
IB_EVENT_CLIENT_REREGISTER event (emitted on PortInfo::ClientReregister=1).

Fixes: d58c23c92548 ("IB/core: Only update PKEY and GID caches on respective events")
Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
Link: https://patch.msgid.link/aVUfsO58QIDn5bGX@eaujamesFR0130
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 81cf3c902e819..0fc1c5bce2f0d 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1537,7 +1537,8 @@ static void ib_cache_event_task(struct work_struct *_work)
 	 * the cache.
 	 */
 	ret = ib_cache_update(work->event.device, work->event.element.port_num,
-			      work->event.event == IB_EVENT_GID_CHANGE,
+			      work->event.event == IB_EVENT_GID_CHANGE ||
+			      work->event.event == IB_EVENT_CLIENT_REREGISTER,
 			      work->event.event == IB_EVENT_PKEY_CHANGE,
 			      work->enforce_security);
 
-- 
2.51.0



