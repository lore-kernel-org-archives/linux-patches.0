Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98021347FEA;
	Tue, 11 Nov 2025 01:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825314; cv=none; b=R+5fgGmk23eT2yuqchubYWom09NXz7eWcfxf1ns4cSMSpBQdirjveitxXKJrXQQ7kyhA35h7RMMhw8lfo6bRDlQ8vOaKyzFy6vfXg3itkcrvUqzktLIu7qDuVl+e1qa73ah4qtKCoYZg/Q9s6LQAv5NgXCZhUBFv32fUUVtbq7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825314; c=relaxed/simple;
	bh=Kn3gl+ZSPiVEzOnb7O2L1rkrDByVHEV0edWpgOxnq+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ew4/vq8yvdATok2yDlnl0AkG4WDK1+F22dJrgOyNC/QjrY9dt5PkdK47ZVy+/9jo5z1M9i93NgDflHcBI1VbfvZZn7eTovaTBgHTCLVWVjl7lJXU10tEfO4WtFb0BQjxikrRdypp7+6D71I8yPjabIyZkmgvVv/KNZdcx18+PZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LE5VfA5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LE5VfA5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31095C4CEF5;
	Tue, 11 Nov 2025 01:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825314;
	bh=Kn3gl+ZSPiVEzOnb7O2L1rkrDByVHEV0edWpgOxnq+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LE5VfA5pZjJD4ZB2u9QeX+9X53uQOFAKP7p0bj5ELQWC9uaQaS/fysnHl8Gp7NzWT
	 CnsA+6gHEXwTDk524/GSxjhQQro6slaKXv71lefVYEU+FNGUPnyJDaCm+NSe1opynG
	 gO/XDSmBg7bh500iS5nhGA173Q0VzGqryKyi98KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 713/849] 9p: fix /sys/fs/9p/caches overwriting itself
Date: Tue, 11 Nov 2025 09:44:43 +0900
Message-ID: <20251111004553.672578120@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 77e9c4387c1df..714cfe76ee651 100644
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



