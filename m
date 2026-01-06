Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AD62D8777;
	Tue,  6 Jan 2026 17:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721272; cv=none; b=e5y9hfO1LQYc98d9j+/Azqynhn/6lkKwgFgnJSq8mOUqh83N18vaU3f1BeRdcU/dsCggpRwTg3U0my5SsUgAuSyJv2/g/0/S+1Fb9gwKN0VP05OoIy3akQ5EbROzYhTO3smc7i3BeFNgUFxUWPck7fiaiRbmFyBX+Up2Jjtcn2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721272; c=relaxed/simple;
	bh=24o7Pqj04CnaXA6FkjF16dxAhK4Xa29UbK8PDxNCGWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPk0Ok88TmIpEK0W5z2cGtw7YBO4aZY/WDpTdPVLeRIk7nFMRD2j6Ub1qTRd/SXB829zVO9vLXUWBdxRIpbm7AoHC1U/TKDNDxRNiCx6KEh/ZtXTBt8hugw31Eazn3Un9/dCCNfkbL8/XKuMiAEMYvBlhc/ChXFofPIeDWXjjpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJN2JNtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJN2JNtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB8FC116C6;
	Tue,  6 Jan 2026 17:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721272;
	bh=24o7Pqj04CnaXA6FkjF16dxAhK4Xa29UbK8PDxNCGWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJN2JNtYmXT+Ahk6uwK1CbJYe+Y1mqMhs3uZzOCtFqCLkddam3QIkS/kl6GUA0Co5
	 COrAbdd86AiO8xJFhlusR5B49KpNDAC6negmyqLtXWgmwOahq9URPp/lEIZ0YZPIv0
	 OX0lVUvOdOzR2LWnLFh89qRnIxeo79/0Tz8UJmWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 486/567] gfs2: fix freeze error handling
Date: Tue,  6 Jan 2026 18:04:28 +0100
Message-ID: <20260106170509.338299224@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

[ Upstream commit 4cfc7d5a4a01d2133b278cdbb1371fba1b419174 ]

After commit b77b4a4815a9 ("gfs2: Rework freeze / thaw logic"),
the freeze error handling is broken because gfs2_do_thaw()
overwrites the 'error' variable, causing incorrect processing
of the original freeze error.

Fix this by calling gfs2_do_thaw() when gfs2_lock_fs_check_clean()
fails but ignoring its return value to preserve the original
freeze error for proper reporting.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b77b4a4815a9 ("gfs2: Rework freeze / thaw logic")
Cc: stable@vger.kernel.org # v6.5+
Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
[ gfs2_do_thaw() only takes 2 params ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -759,9 +759,7 @@ static int gfs2_freeze_super(struct supe
 			break;
 		}
 
-		error = gfs2_do_thaw(sdp, who);
-		if (error)
-			goto out;
+		(void)gfs2_do_thaw(sdp, who);
 
 		if (error == -EBUSY)
 			fs_err(sdp, "waiting for recovery before freeze\n");


