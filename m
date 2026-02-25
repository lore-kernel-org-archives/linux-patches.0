Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D41A2D063E;
	Wed, 25 Feb 2026 06:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002594; cv=none; b=G0OcYtYECvC2fmkassOXr3fGiiVCY2kc8lUILgLgDB69ymJmMjbxS6WXqYonHdO/d+oGfdnvgimMSI9yJTotRaJPzSZ9ip547kM4ZctptdkvNVj4S/MRAsyD7cRRnqh4kLFkMPbFhv8CnVHXAhdke3QWOXuv8pNfun4EsEC3JRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002594; c=relaxed/simple;
	bh=KoLJW4xzoxX92nWwzid2W2v9tBV0XUJ+MYDKKuxU5+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XT/n6SL6lsQj58nKrREeuTfP0CKIcrK6pJi7P4C3B4aUEn4l+uy6xAxjLRHQ66slMZ/VeojS+Rn78CCavwxdr+a+/lJmqAZPwRKy72nmOJp+oxsJn4yBD4HMPbiDHy51ySHQKYjE7+HJjDkwTWFKmNT0WStiDqmKpWzkO5V47Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LO9ZiCPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LO9ZiCPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238DBC116D0;
	Wed, 25 Feb 2026 06:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002594;
	bh=KoLJW4xzoxX92nWwzid2W2v9tBV0XUJ+MYDKKuxU5+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LO9ZiCPCmUSzS9aZ+EqdNEAZFOAxNEOJzqG9B1K0QqsnKnNsGkb2vfLpIWCFY1YwG
	 gOH8/SvDOUutUTBt346mo8S4ZtFSUVNbtU5vYUHwrM5NuYtEqL/unvyv0r6Mgc7H0u
	 CzhNBOmdmfAS0yM69OMqvyiMU6S8CwzMuci000RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Etienne AUJAMES <eaujames@ddn.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 338/641] IB/cache: update gid cache on client reregister event
Date: Tue, 24 Feb 2026 17:21:04 -0800
Message-ID: <20260225012356.862038768@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



