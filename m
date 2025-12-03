Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641133148A3;
	Wed,  3 Dec 2025 15:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776327; cv=none; b=GDunhjWfg/JI/Dw28Trg4wiBwbYP0jhn1sdg4cTFwxP4oNIcoCBUFR5phJogA8OunPdpzoFsLV2cQYqQngi3NGrAqCU5fhX3t31BHlyHl3SXT762njEpm5PQ4nQsgbsf9bpatQxRMrV0mvQjtewZ0xbmpnc6gYqE58bU3pPNr1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776327; c=relaxed/simple;
	bh=gDI0uph5URALL+qGku4O1hus5ynq2iTw9apZaQBhn4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WsDC2fAf+nOY7DOgMW8dAt8MGEwKqnKOtYUuDAngLmA3EdSqcS5l/DiE8whARy8D412nOA6AZP3n8ONfTmxRSB/xgPCmi+T3n09ilL4pJqRi4zfYPvubA6KUd1hzAWcBSgQA6hTXNEXXyaSQt2Eng3xc8EoNZ38yEFXSfa9UKxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBumcN8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBumcN8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F8CC4CEF5;
	Wed,  3 Dec 2025 15:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776327;
	bh=gDI0uph5URALL+qGku4O1hus5ynq2iTw9apZaQBhn4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBumcN8tqJJ2wlk8nXchOtQ2ae/22U5miuEMi2F1BXebofjs5ry9z5JCBnv9cgF15
	 /yIFIY96rvrvnwQ6PNP3FDVeerSIqWME9yjeW+5azF4O8zFo3p8gMHnCqrjj36OK9v
	 e4vTmjKI0mxZUz8PBmHgaZwftfB8SgvwxrybCAAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/300] 9p: fix /sys/fs/9p/caches overwriting itself
Date: Wed,  3 Dec 2025 16:25:54 +0100
Message-ID: <20251203152406.174697330@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 39def020a074b..b304e070139ca 100644
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



