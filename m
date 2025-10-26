Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BB623EA89;
	Sun, 26 Oct 2025 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490249; cv=none; b=G7oR/Fqk/IVsbmSibQTOlf/0wUUMvgHhw2Hi2O6qdhjpN2cQqXTdgR8TSLasboOBpJSyIji+Nt8/leQramufkLrS1jzBTqa8CFlSVaA9Qc1yXuKv9yBvk4gmnw5Cj/I8jnmgcbEd4/FOETacKSz4t6L0AjxuQzUq525NxPKi1ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490249; c=relaxed/simple;
	bh=kJr34zXk9Lj3aU0HtVg1SkQb5pCkfQlr84Lg0Aj5QZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mUKQEWlW4g2gtqKw0tWjzaQbq967O3JPjUxy41XkZvd9PJ2Fp1CngWUT2yTe20RO4frHlpMSSyqaQGRnhtIuC4TSDBRWOevrQmT9Pc+5TOa4nARzslqZbyn1wU7LWhvWaodVWISR9M2XDpqAFiXerFFv5RXwtJGxnjA+vJ6RCWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwoVpZq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwoVpZq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3B2C4CEFB;
	Sun, 26 Oct 2025 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490249;
	bh=kJr34zXk9Lj3aU0HtVg1SkQb5pCkfQlr84Lg0Aj5QZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwoVpZq7f1LESZiwlJt+tZNlSMTFJc3MqjcOli0nnwyxXN/ukBlYjoNA7tOXD7oBZ
	 j9RRQl1S0gCM8sw5RmTZZxgpiY0hepT026EzDoKt/UJ8KS9GszvG/ixnttnjX903uh
	 fcC9kwMH007PzMGO16Mx8DeIztop/eyRH3Q6p2Etg5xQSuLhPlXAXdfvKVgyK8DXOU
	 IZjJKR9Ax39taZQ/PEOx0cH2dmnSTz6RW+GRQwxrVxVN+MY5n9dfHfgRE/1LlqXgIi
	 3IS4IEwnV6QDNK3M7pS2iBBcPpH7qacvLTwgVRb7GBhXqND+lDwwmhnEOzxO36fOys
	 ePYpCx0/bnKVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>,
	ericvh@kernel.org,
	lucho@ionkov.net,
	v9fs@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-5.4] 9p: fix /sys/fs/9p/caches overwriting itself
Date: Sun, 26 Oct 2025 10:49:00 -0400
Message-ID: <20251026144958.26750-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: "Randall P. Embry" <rpembry@gmail.com>

[ Upstream commit 86db0c32f16c5538ddb740f54669ace8f3a1f3d7 ]

caches_show() overwrote its buffer on each iteration,
so only the last cache tag was visible in sysfs output.

Properly append with snprintf(buf + count, …).

Signed-off-by: Randall P. Embry <rpembry@gmail.com>
Message-ID: <20250926-v9fs_misc-v1-2-a8b3907fc04d@codewreck.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES. The change in `fs/9p/v9fs.c:563` switches the sysfs formatter from
`snprintf(buf, …)` to `snprintf(buf + count, …)`, so each cache tag is
appended rather than overwriting the start of the buffer. Without this
adjustment, `/sys/fs/9p/caches` only ever reported the final cache tag,
which is a real user-visible bug for multi-session configurations and
makes the sysfs knob effectively unusable. The fix is a one-line
adjustment behind `CONFIG_9P_FSCACHE`, touches no other logic, and keeps
the existing `count`/`limit` bookkeeping, so the regression risk is
negligible. There are no prerequisites or follow-up changes in this
area, making it an ideal low-risk candidate for the stable trees.

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

