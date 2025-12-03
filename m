Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158913A1CF6;
	Wed,  3 Dec 2025 16:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779546; cv=none; b=WDgnJIAsX82hENCy9OQ6Dpd7T7zSW166HRu1mI+9O7b5mxi/XDzNbdN6CePQpAq0NE6EPkXmLATAKsMFV4owQdUOKj/winEVSQd1OPY/HVXTb9+GJ3/IfSVimFuoEE7gRObuE0ZY2Z1wSHRQlLYmzUmWOcSglk4bD/ywsRBm67g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779546; c=relaxed/simple;
	bh=FWIwqP5w8h2Rw+eT6EdEXOQv8dkly29J4soTin0XbXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UGJJB3Qv2qDjstLlKHK7EJgqcjY3uokN+SeHRGBLP+xXYF6SwdMtCqxoBjE6paBZ1p/SLvOb4DLNSz4J3UpyAuToirAC4TncrfLTlxpkhRu8tzeg0wdOBo86AdxyPLOh/jCsG3kiJKVhKxFOxX/tpByph0NQujjZMWPvTSCubno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMHWPoUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMHWPoUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794A9C4CEF5;
	Wed,  3 Dec 2025 16:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779546;
	bh=FWIwqP5w8h2Rw+eT6EdEXOQv8dkly29J4soTin0XbXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMHWPoUQDhFHoDOOP28ftL9jlsoUzTCPkzgjFVeKk7BU6Nl8wikFNTwiRpMWecqlF
	 mKDQwhMtifBrvV7SiVDnhQeDtTdD4bYoCh4+jtKl3+Wxb71ZDTbmQtLdJrEZ3uDlhx
	 T7YhA5DmhrcaDhtXQKaZMM3hPxBpoJjMvGp3h0E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 290/568] 9p: fix /sys/fs/9p/caches overwriting itself
Date: Wed,  3 Dec 2025 16:24:52 +0100
Message-ID: <20251203152451.324848718@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randall P. Embry <rpembry@gmail.com>

[ Upstream commit 86db0c32f16c5538ddb740f54669ace8f3a1f3d7 ]

caches_show() overwrote its buffer on each iteration,
so only the last cache tag was visible in sysfs output.

Properly append with snprintf(buf + count, …).

Signed-off-by: Randall P. Embry <rpembry@gmail.com>
Message-ID: <20250926-v9fs_misc-v1-2-a8b3907fc04d@codewreck.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/v9fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 0129de2ea31ae..fc3dadbd2e11c 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -561,7 +561,7 @@ static ssize_t caches_show(struct kobject *kobj,
 	spin_lock(&v9fs_sessionlist_lock);
 	list_for_each_entry(v9ses, &v9fs_sessionlist, slist) {
 		if (v9ses->cachetag) {
-			n = snprintf(buf, limit, "%s\n", v9ses->cachetag);
+			n = snprintf(buf + count, limit, "%s\n", v9ses->cachetag);
 			if (n < 0) {
 				count = n;
 				break;
-- 
2.51.0



