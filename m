Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2023033A9FC;
	Tue, 21 Jul 2026 19:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660625; cv=none; b=jQ0HVnJi14SDIXevpjjBxYIrQymoN/7hWENrUVZxZzNCrhQ+AVWFp/25ZnM7idUdgcy8A4UFiQXNszDKMD/76gLu0ddtOXR+AJHwIzI/hB94B76r8aGfoEUaxeGXPfsZnB1KBuc7vByL9CA0wbSIqApbAS0PB+iomXg1/BsAsHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660625; c=relaxed/simple;
	bh=FBv4MOnnoGBpSGUuLVrdAZKxZYtOtCBs+3Zdqt3xDfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnghMI6VO2O3j0sssDSr1CRG7Sa1ngPCV54QBCUbNSiB/hGDJI9qRaq1j8oi3uG+rT07z/TbkBLrKi96Ro1JHYIkAR1BzMkvj0IWaCkSYKaG3bTrE/g29ns5K8J26XE9IN0P+8HZxK1pcyvCzfiSlC9a0OalQimoCmeNIawSUVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XjrP6hU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XjrP6hU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8652C1F000E9;
	Tue, 21 Jul 2026 19:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660624;
	bh=cm4gpG6Lmd8lkfr0157+BbHrEAYrYuIPbnBegm5zm+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XjrP6hUVgCGyeG51iqZJMi6+7fVv2aqb43Ez2UkktXxJ7YfydRRnDkxIkDqeWiV+
	 UjQ+QrWrjV89yRCgv+Vd7xIKb4jhqF2LqPVwWsr4drZAsRRORQo1ipL16OWfj+L/Ze
	 ZzFNu3tdjzpK4dhGSERoI4Fy4DWRp0G2N7O5hSNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1049/2077] apparmor: release exe file resources on path failure
Date: Tue, 21 Jul 2026 17:12:02 +0200
Message-ID: <20260721152617.556021953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit 7306c41672487a6c28430714be063bc6942c28f2 ]

get_current_exe_path() takes both an exe_file reference and a path
reference before resolving the path name. If aa_path_name() failed, it
returned immediately and leaked both references.

Route the failure through the common cleanup path so fput() and path_put()
always run after the references are acquired.

Fixes: 8d34e16f7f2b ("apparmor: userns: Add support for execpath in userns")
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/task.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/task.c b/security/apparmor/task.c
index 0db0e81b460017..6445cb5f852668 100644
--- a/security/apparmor/task.c
+++ b/security/apparmor/task.c
@@ -313,9 +313,12 @@ static const char *get_current_exe_path(char *buffer, int buffer_size)
 	p = exe_file->f_path;
 	path_get(&p);
 
-	if (aa_path_name(&p, FLAG_VIEW_SUBNS, buffer, &path_str, NULL, NULL))
-		return ERR_PTR(-ENOMEM);
+	if (aa_path_name(&p, FLAG_VIEW_SUBNS, buffer, &path_str, NULL, NULL)) {
+		path_str = ERR_PTR(-ENOMEM);
+		goto out;
+	}
 
+out:
 	fput(exe_file);
 	path_put(&p);
 
-- 
2.53.0



