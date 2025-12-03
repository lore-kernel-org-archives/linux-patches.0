Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDED313558;
	Wed,  3 Dec 2025 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777958; cv=none; b=WC/DLQj/xgAaPwmv4BafR6vPQS2PrbF5XS69HnT2pvpD0Wylmr7R3/fNf/6X83REbzUvr8oRMwblim4e95SIAhGvZHmBNKSKhk0VcPqiMsMM1sCsePFHQxEis6sNKVKjxIbmtPk84+RqkU3oEpGx1Nlr9ggaGXsxrOUHX8uISLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777958; c=relaxed/simple;
	bh=fjCq8KnI6ByGbykD6rjoa7KoA9CHilp1EUiOscvZv5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p4KLReqHTx1/ju1h48AxfmewHsS+YzXjNmpAWZcifjH/tyuQO/HyGUjolm59QDK8UUoVDo12xrxrRiGt8vUC1g6r3dPs6QLFyBSF2nay8rhtrNjUlupcMk9s4yP11MU9Ccy0+v6y7CfDfTrvEO8HtQuZJHZ14FRWLTaL9PdCVDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2T0tRLeN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2T0tRLeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADA5C4CEF5;
	Wed,  3 Dec 2025 16:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777958;
	bh=fjCq8KnI6ByGbykD6rjoa7KoA9CHilp1EUiOscvZv5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2T0tRLeNuxhydSRq9uLm0vKcPNiZcfenmjASAylQWry/lJWJD9ItF10o1Uxh11MSY
	 IOdR0Eikz691osjSvZ6bFkVtdLg3YX9Fdq3IhBIR7paE/Ne0m5C4XG+sqk3s2M+bc5
	 f42q6aHYIi6+mzyGozfcOYREFwExUkajjBuWzFl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/392] 9p: fix /sys/fs/9p/caches overwriting itself
Date: Wed,  3 Dec 2025 16:25:48 +0100
Message-ID: <20251203152421.360543764@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 141067379f5e4..52765f7a3375a 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -558,7 +558,7 @@ static ssize_t caches_show(struct kobject *kobj,
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



