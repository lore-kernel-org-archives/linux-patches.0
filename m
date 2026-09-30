Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796C451C058;
	Wed, 30 Sep 2026 18:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792733; cv=none; b=mPojzjZ4niOeqGRjLqFxmm9BcVarSvHGn/7zsNuWYjsO71on1K7gSuGzuWjVe5zUVD1a+zEbL2UhihT1Iao0cyzzrmEAFGq5sxX33Ru+TfOeh3+GnolzxQLPxtAJODS394eZwe2E63nFxBK7p9WxPi9PZWCREqfe/s//WqgA0ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792733; c=relaxed/simple;
	bh=CkxDWDZsFUpt3ycHXMgw12csbJp9k5RNzIfYXzYJqY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhLJAt2rSM44BhLzBeAzZo1tr+e2tjpPk5s+t3hj9ajKfnvf6IXYYLuUlC/FeDwgsyLpV1f7vibOMx5lAX4pdH2jg8upvWbigUYv8d2QIhhLr7yXH+/19HUWyWTXPobsuu4FOobjHIQWe/2AKenOiFZyCACtfgYXxbNk9Q/0Qb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJvlEcap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJvlEcap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D367E1F000FF;
	Wed, 30 Sep 2026 18:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792732;
	bh=nIdNroOVuGnv8EYAKOrRwbhgogX/d4mV6oN3/KRxbI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJvlEcapNJyXsohltEVuFUL60kw3hiL1vLGoUSgw6HMjVtQ+NYJR/TD16nT6Fl9UI
	 l7Q3UwpPsyds/n7yGhOe+AW6BkV2zH6wT6zmoQx3bFDKT3fgM18gqL7OMQ+AD8sBau
	 VZfp7+FVD7RWnOGz/9KqMoU2J/3wZIrTzvxj8rJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 752/752] drm/amdgpu/atom: Check kcalloc() for WS buffer in amdgpu_atom_execute_table_locked()
Date: Wed, 30 Sep 2026 17:30:22 +0200
Message-ID: <20260930152414.489021578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit cc9a8e238e42c1f43b98c097995137d644b69245 upstream.

kcalloc() may fail. When WS is non-zero and allocation fails, ectx.ws
remains NULL while ectx.ws_size is set, leading to a potential NULL
pointer dereference in atom_get_src_int() when accessing WS entries.

Return -ENOMEM on allocation failure to avoid the NULL dereference.

Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ Roman: added parentheses to the 'if' statement, matching the upstream commit. ]
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/atom.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1226,10 +1226,15 @@ static int amdgpu_atom_execute_table_loc
 	ectx.ps = params;
 	ectx.abort = false;
 	ectx.last_jump = 0;
-	if (ws)
+	if (ws) {
 		ectx.ws = kcalloc(4, ws, GFP_KERNEL);
-	else
+		if (!ectx.ws) {
+			ret = -ENOMEM;
+			goto free;
+		}
+	} else {
 		ectx.ws = NULL;
+	}
 
 	debug_depth++;
 	while (1) {


