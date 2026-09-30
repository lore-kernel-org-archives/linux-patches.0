Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9BC4C10C4;
	Wed, 30 Sep 2026 19:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797172; cv=none; b=MYZRnUGfsBHBqxY9PbpT55ebD5nkwZOZRkz6pzOWXt59Gdk6VzbLhkXaNcg9cEA0VQZrZWebwbTREa4u+vQ0pdodRNf1XDJmpoCkHs7jVmuJmHYFwmWjPu3XxSO3rDbM7EQHN4TT9lPY89w3SrNcg5zeYBJKadbeLJorq4p8NQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797172; c=relaxed/simple;
	bh=uL8LY6Uc7VGSK37fcmAFjrN5qBgC07vnUlqZpgjOEkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpMrj7dF1OxfEdpYIn0ab1D7QXfYSioyu+3soiAlleWmqnOQOllx6H8obTAmXSeSoiswFw9ZOSe0TZh59sgab4EYTZOO8QDSH6Zus2U5BSxYiniAKUSzmFtY6eLneIpHkBQ7YzHytQ52fT/GDxKd6IRX46Er4BoRcTyFR5bUZqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ir/s6ksh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ir/s6ksh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B711F000FF;
	Wed, 30 Sep 2026 19:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797170;
	bh=tRbTx0fNyarji4kCC3dOpt1dX5IrC+0AQg1ou506kXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ir/s6kshVO2GqP3ltx7z8arw5JonPeyYGucX571Ts3U4hW5S8LJlVpzAjDo5XW/JD
	 jjqpQZI6bIabiQGB3bbcYl5ArFmCVL/Cp/kfJP9RJR19UMSPdzWuKwRicHemFxN/NW
	 Hni31QPKVSPWt1NeztGFSTjgx68swUkK5LGQCsMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 6.6 1171/1193] drm/amdgpu/atom: Check kcalloc() for WS buffer in amdgpu_atom_execute_table_locked()
Date: Wed, 30 Sep 2026 17:30:55 +0200
Message-ID: <20260930152500.261871848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -1228,10 +1228,15 @@ static int amdgpu_atom_execute_table_loc
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


