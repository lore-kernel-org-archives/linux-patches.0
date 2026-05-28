Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45463002A0;
	Thu, 28 May 2026 20:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999884; cv=none; b=W/4E6dAS02RyZrHz5V8Ai9KSggwkxeTueVdjD0ZLReUXC4sbsW0zBJsqZYMk4TFHskevY8+G5cb2hFHvycTYcaA6cc2nM3lB9AiLJV9npcacdnAsrtHvAVap5oQoss1pv6MKtTSS7WJJIHE4Z1WXeZojA8oaqs4g9U0/8WZtNlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999884; c=relaxed/simple;
	bh=U7LkFHK4ZIFhOwjUbBfo8N9s7IFDMw9/x89meLC7rzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoZINzq26DddSATSiGcMJ46VeWMdn3YDbuT7B5kMhRY2VRpBsJr+oKrAUgJRf7pAt4MqDn87o3qVzFGf2oYRbx0ptv30CFdsPOtkfu1D1gd5L0jTCEdxIvZe8QrnPoU5BWYIK1ul1nWUqFScCswYtZLZ/NLiPyU3gtGswzVGsUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRDnOuVf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRDnOuVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB911F000E9;
	Thu, 28 May 2026 20:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999883;
	bh=nE+Ere9PkdNlsEbuMaemKEi72D1OGJBywalajqZzqTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eRDnOuVfunrUnTcgOcOH/jA7EW6DKmctUJOf4Qfn1IDjzFZCE5+uMr737FULx2vO8
	 fNA2n5/FMcIjxGeQKCKd+L2mbdRGXYgGduHKunPK4NoLgBGqzmW6gsbcDwkxozhSsi
	 wUDn0vW0sUU8nd3ocunR4SkdWk+aYqbefpFZTnQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yang Erkun <yangerkun@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 224/377] nsfs: fix wrong error code returned for pidns ioctls
Date: Thu, 28 May 2026 21:47:42 +0200
Message-ID: <20260528194644.878758876@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 725ecd80688bf3c57ca9205431f2c06174ff0756 ]

When executing NS_GET_PID_FROM_PIDNS (or similar pidns ioctls), if the
target task cannot be found in the corresponding pid_ns, the error code
should be ESRCH instead of ENOTTY.

This bug was introduced when the extensible ioctl handling was added.
Without proper return, ret would be overwritten by the default case in
the extensible ioctl switch statement.

Fixes: a1d220d9dafa8 ("nsfs: iterate through mount namespaces")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://patch.msgid.link/20260507112301.1042757-1-chengzhihao1@huawei.com
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index f22c2a636e8f3..e2f9a725883c7 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -261,7 +261,7 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 		else
 			tsk = find_task_by_pid_ns(arg, pid_ns);
 		if (!tsk)
-			break;
+			return ret;
 
 		switch (ioctl) {
 		case NS_GET_PID_FROM_PIDNS:
-- 
2.53.0



