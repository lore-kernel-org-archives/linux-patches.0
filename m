Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB926261573;
	Tue, 11 Nov 2025 01:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824601; cv=none; b=opZ8G/Si+FkMos4X5FHTcbF4Lp25cTtlkS9Jk7qPS6npuKmVjoeWLmaKAi8Sv9Yuuykatz/VuSCr2AqkwfQ3My3Grxl/RHlkMlTDt2AtAzyqiQjT57pRRormKuIBiHMPOpNB1niDyuOQhB92fRCj3fVyo5PSD1C2EmxIeywNaHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824601; c=relaxed/simple;
	bh=Y8PZYAiFe7EBOwjgLGjhJSjx53AnCZF2fhaIWi0H5ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O+oBiR47+psWv7Y4viFTDockC0WSMSIAKIBv4KFPkvQ81ccWWUs0gOY9mUW9vNYremYoKLxeoUFaFNOuZTR7S23JV43PostOlixGgZz+Cl0kGcxVZCBO2zV7ki9QibH0yqNcwWOKuT/DRsNX3vYpTCAFzfHXaTd6WVHNzJByM4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJrVLBcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJrVLBcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309C1C113D0;
	Tue, 11 Nov 2025 01:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824600;
	bh=Y8PZYAiFe7EBOwjgLGjhJSjx53AnCZF2fhaIWi0H5ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJrVLBcBfZfZpf8Yu/303YkqRNH3l2bXjjhniI4HrJL3kusKp28kxI+gmQZyvC+Dn
	 /K/Z0IFfB0hAmT2gf0uf4tSCtwbklko0HBHMQcbCTffo6gdjNM1jUcdZh79juLyYwk
	 C+WyyjCDb95W4boDFlgh2vaPVaJiOPWAD3E6n094=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 477/565] 9p: fix /sys/fs/9p/caches overwriting itself
Date: Tue, 11 Nov 2025 09:45:33 +0900
Message-ID: <20251111004537.647242318@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 281a1ed03a041..e35b30534787d 100644
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



