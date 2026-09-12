Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12AE3148DA;
	Sat, 12 Sep 2026 07:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199797; cv=none; b=msG0oXUCggN1MrJmrWDxQPhCNWLI480iiwsQZvlBzFfXCz36WhDPBdB4thvDBC43ko2XQRo9B2WpMfbNU0QV9iy3CsMZJYmI/NS+Y59SaPlgpWO56lnUSqp86jII7s+nD0J7Bqzm9yNO+6A5U6KjSgBhnxqR9V9W3kosDNjvWps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199797; c=relaxed/simple;
	bh=I5JcFphysvQHM9CGlkuCbTfegqxDK6M/b0CGLpn+FzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtHJHSOrulhLHji9wQA7SNp6G9Tlnko28Opf4sMc01YDCmn41xDAWBhw1AO9a3bv+fMj3JLp3aKvSdnR3a9wd8vuqFjmebtQMaKvzbmjQhvsmAieHciO4i7WOKyY0rYfcFubFQaunUZPgOJm8+E5zFu3rQpXADRTKQxl7kF5KqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaIZ6hww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaIZ6hww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D1B1F000FF;
	Sat, 12 Sep 2026 07:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199795;
	bh=xn3z40+RHY8Rt2NQuoMIpwZHMzW5Q1SpZOoocydcYRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xaIZ6hwwaaV95JpuWg++wFuq0IPGwzIisKVo7X1T3cZXZmgxs6Pb/eFVAeH7NHqdt
	 pvjpSTWpLvpp5AWkwjrXpUwXjIG3E+EbZ2K2zf8TOwVcJ3RLAWzKNW+ehccGJODOY4
	 lDIExnc/D0wtRU/jV2cmgOpNpEXCOK8qM6FbWhiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Jackie Liu <liuyun01@kylinos.cn>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0658/1815] liveupdate: reject nonzero reserved value for SESSION_FINISH
Date: Sat, 12 Sep 2026 08:40:08 +0200
Message-ID: <20260912065704.327834927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit 05cf3d87a0bf23e328a7f7db488860fe14acc335 ]

The UAPI documents liveupdate_session_finish::reserved as requiring zero,
but luo_session_finish() currently ignores it and finishes the session.
Accepting nonzero values prevents the field from being safely repurposed
by a future extension.

Reject nonzero reserved values before changing session state, matching
LIVEUPDATE_SESSION_GET_NAME.

Fixes: 16cec0d26521 ("liveupdate: luo_session: add ioctls for file preservation")
Assisted-by: Codex:gpt-5.6-sol
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Link: https://patch.msgid.link/20260716012607.22020-2-liu.yun@linux.dev
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/liveupdate/luo_session.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f38b5b18f3f81..b4a9f55c44987 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -316,8 +316,12 @@ static int luo_session_finish(struct luo_session *session,
 			      struct luo_ucmd *ucmd)
 {
 	struct liveupdate_session_finish *argp = ucmd->cmd;
-	int err = luo_session_finish_one(session);
+	int err;
+
+	if (argp->reserved)
+		return -EINVAL;
 
+	err = luo_session_finish_one(session);
 	if (err)
 		return err;
 
-- 
2.53.0



