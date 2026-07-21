Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7636746EC84;
	Tue, 21 Jul 2026 19:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660638; cv=none; b=GYUYhbTR+Pm7qeChJTuncMv8fD24l9sUWI7UZdpcagCL4mGgbrH6Z5mPO5Ds8LuUPIITFxUdHexWinsz5XoFDCEASTfzMqnUNe4FOiYCUWoy7EtLsF3KzWMl+N6SnUq+99bD27OtTJ8qmJ1Zmijk1H7735LwJkoKYwTWttFh/Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660638; c=relaxed/simple;
	bh=GaOTw5kAKsU2FoAwJpZcOBjokOiwbTNM9A+UTThvgMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5X46p8qvOMDz19tyHRmP2hhfllYtBOwM5J4epGIBp3yPRUGAl3PSjuZoX6LPQYuzBhuqLIUwQ+xrs0Qgr6XkrHEslddFeAgchEgtfn1VkeVixrCyB/uC7bkWHFY8DBNiCNqjmzvYZsDgHpOS2bHLQTO/QHf4GuZlbSkMI7xxNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPOfZgIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPOfZgIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AAA1F000E9;
	Tue, 21 Jul 2026 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660637;
	bh=q8PWfwDb9ioQyOnzCeRAb1qBhBDN8bw3deu8WLPrIG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPOfZgIbIJXbcIYFJDGT1gEtySzp2VzkVeU6KqKIbvvEJQbmi0U8ROsUT5NBmjUP6
	 kdw872vkKGeso+UkgSrlvCQHQjy1DeCydZCUYcYOlTTUOiRCXlfjg1D/WBlp2d6Huk
	 3ijPYOzxIDwJlHxO3HhrUHEuQ9H8bM7Rdi3noFls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1053/2077] apparmor: dont audit files pointing to aa_null.dentry
Date: Tue, 21 Jul 2026 17:12:06 +0200
Message-ID: <20260721152617.654997995@linuxfoundation.org>
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

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit add2b70038bea194bcdef8a680f9153ee7f93ac0 ]

In
  commit 4a134723f9f1 ("apparmor: move check for aa_null file to cover all cases")
there was a change to not audit files pointing to
aa_null.dentry because they provide no value, but setting the error
variable instead of returning -EACCES was still causing them to be
audited.

Fixes: 4a134723f9f1 ("apparmor: move check for aa_null file to cover all cases")
Acked-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index 694e157149e85e..fc5abd5473c850 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -157,7 +157,7 @@ static int path_name(const char *op, const struct cred *subj_cred,
 
 	/* don't reaudit files closed during inheritance */
 	if (unlikely(path->dentry == aa_null.dentry))
-		error = -EACCES;
+		return -EACCES;
 	else
 		error = aa_path_name(path, flags, buffer, name, &info,
 				     labels_profile(label)->disconnected);
-- 
2.53.0



