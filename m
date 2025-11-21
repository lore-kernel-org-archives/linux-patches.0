Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E14D2FC89C;
	Fri, 21 Nov 2025 13:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733092; cv=none; b=IAugiIUg9izMO7n4nrV1eHqNB0QY8yl+66Al/Vk6Ox1xdcDpfJVxSY/FF6pIJaVAfSWcWeuSMgcHb5mMuA/9o4RwvMr065aQlTB03M+RCeWMJsa20n6eHuVrM0TWVUXPyyJ8/57/wSBmFMsmom2T/XRmSuPqnYMaVycd9m41ntA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733092; c=relaxed/simple;
	bh=3lp9ssKvHHpJZMvRFvBlQvrsKan5B4fTgIadzLseza0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DvGSulNkepsOt0EMrX8KLLbpf5A8o7acqO8xCzByO7ocVcZ3UlUlgiMffivc7fFIVAYYmQGGcYQzkEjoZL+JhuS1KFcbKhD8Lxf4c2uQwYAgEx5nFiFd4UdhPrxMdRj6s8UMomz88ddGgclrfdjb/H5hTJeXFpi709xvE3sXOCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvahQnuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvahQnuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DCFC4CEF1;
	Fri, 21 Nov 2025 13:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733092;
	bh=3lp9ssKvHHpJZMvRFvBlQvrsKan5B4fTgIadzLseza0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvahQnuEtkhqY1edl9cPTVS2nAkm9KALI7wyrGxYPQ4G3cmC+w4PljBtfh5dSnZh5
	 b25qWpqaIecdWKBWWuHk0mk06v2/7ZCYzLy2B3zJz1TIrC0j+jikS4l2nlMEwSig+N
	 uY1IajEkKNzhj091ZheuciTHRlgM22njLQjLgkPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 315/529] 9p: fix /sys/fs/9p/caches overwriting itself
Date: Fri, 21 Nov 2025 14:10:14 +0100
Message-ID: <20251121130242.234357869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d525957594b6b..af1921454ce87 100644
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



