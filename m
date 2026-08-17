Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF57A3B42ED;
	Mon, 17 Aug 2026 13:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975144; cv=none; b=pdr2vnwONDfx6+/al0WhsUeov5Q8VK95XY3Eij7kRiRt4PK+YD0thRePK4IuAbD1NZbBsBoK/mBmuOXoiZpSjb8HU/t6UiUzYeddTRG/+Lg4A5Y/EQlh+L+ApQxcmBoKBQk4KD2g3UrWn2Vt+QIWDpwHEItrjr9MIORv/ArMLEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975144; c=relaxed/simple;
	bh=ltOgKic99FkP3GfCUZfOCWx1PdQwRO3meo0gxvvChO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JS8/AkJFIQVN078HXwX4hFjXdwp78MLn/zslYV9Te5BROa8UNmneZQj4ux8HKPtGIIOBRrOm6P30/NhnJXLNfvaL20GhNXFQewdJE9Z/6FWD+Ieo9kbdmn6nKiqIKy3wGaqZXL8Ms4WYE2JHbX3Mpb6iGiZvocRdiuGnL29YG3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uehjwDCA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uehjwDCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86171F000E9;
	Mon, 17 Aug 2026 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975142;
	bh=/j20q5zY3He6NrA4hWHQ3juV97gFuDHy4yi6NWjOO6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uehjwDCA83MMo+k0WA4baFk5T+73ixwvNewjBIQoFiTNKbStdolbDCN+NdxLxa78s
	 XdFWzB3NwfeMlftuq/1rsRqlv+a+bXd8GUi3M1qLqvYpu6pLwT6yILDcotbq8Q9fHE
	 z+N3rezoaP/FK0cbyM84CB9qZhH84F4E2yMYgMOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.18 177/250] misc: fastrpc: take fl->lock when moving mmaps on interrupted invoke
Date: Mon, 17 Aug 2026 15:32:18 +0200
Message-ID: <20260817132543.833272598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit b85a0e91d7d6cd06a53c881a46f749cfcef416a2 upstream.

When an invoke is interrupted by a signal,
wait_for_completion_interruptible() returns -ERESTARTSYS and
fastrpc_internal_invoke() moves every buffer from fl->mmaps onto
cctx->invoke_interrupted_mmaps. This list_del()/list_add_tail() walk
runs without holding fl->lock, the lock that serialises fl->mmaps in
fastrpc_req_mmap() and fastrpc_req_munmap() everywhere else.

Take fl->lock around the move, matching every other fl->mmaps accessor.

Fixes: 76e8e4ace1ed ("misc: fastrpc: Safekeep mmaps on interrupted invoke")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260724223342.629168-4-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1276,10 +1276,12 @@ bail:
 	}
 
 	if (err == -ERESTARTSYS) {
+		spin_lock(&fl->lock);
 		list_for_each_entry_safe(buf, b, &fl->mmaps, node) {
 			list_del(&buf->node);
 			list_add_tail(&buf->node, &fl->cctx->invoke_interrupted_mmaps);
 		}
+		spin_unlock(&fl->lock);
 	}
 
 	if (err)


