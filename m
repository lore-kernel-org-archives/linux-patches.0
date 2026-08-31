Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A856A599A31;
	Mon, 31 Aug 2026 13:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184306; cv=none; b=JaS9Ze4BOM/DG4EvVnEygH7/J784Ynjl3Mc4oOJds1xTf6LyUCM2jaYBlBqz+AMcdjuNuJaJxkLNQwMcC8FaMYI/gFqYEmWXOZUdCQe9BZmLVOCwETDuqH2wPrqASYidBb7PKd6JEpZrEyn28XzMGuhl0FfmmIEppKuTHIMawYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184306; c=relaxed/simple;
	bh=02HpdsVBXmlVvGBnHSAwsRrrbpDZd6rh0Xtxl6nQbPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aCK1cDS14IyB0CuQqXOug2jF0L/Q2E2GFh037aPBKlSqbZp4n9VviQhn6lrcseM6+HCRND1K5SZg5wpChulHUD6gi7l+tOAaeDogCntKDiBynFeYf4HFDG+5V2N/aFo0Qlutr4abCwyPq/QfPa/Vutar+hxln3c9ZU0Wva3RbZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8Qdphro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8Qdphro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3C81F00A3E;
	Mon, 31 Aug 2026 13:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184303;
	bh=MRpJL+WoNk4DFHGlYx6cIUDseQ+vnAXt019qv0tr+18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8QdphropY2RW75CYQfBFrozQrTUs9bHYe/wJAfchURaC+kaOtZRdxvTJPdOqGwva
	 FLbCb0IDfqBIRTjwiWmT44ckCopuj8KHXw9jywYgATuJRT7t8wC8h0xA58aYq563/8
	 M5P2HjpGWCe/68Qj2b4v+9jHnpIDD8hwjTSrSlZv/D89y5ypQctytFHrOxOEWThgjI
	 3MRZMr0O3MJah1IoG47WYc29E4W20EU6YY2UkD+xzBAKhAYIZY1jc1v6nMDfEs4pt8
	 HTC25vQgWfiefxtnjUsbUqdekhTBkIS62v/NWQ2P7y6OJQ4wYN11gbNeLsCD3W4doa
	 GGjQicaTYKjKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhenghang Xiao <kipreyyy@gmail.com>,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Berkant Koc <me@berkoc.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	miklos@szeredi.hu,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] fuse-uring: clear ent->fuse_req in commit_fetch error path
Date: Mon, 31 Aug 2026 09:30:40 -0400
Message-ID: <20260831133314.4125787-612-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhenghang Xiao <kipreyyy@gmail.com>

[ Upstream commit 7d87a5a284bb34edb3f4e7e312ef403b3385a7b7 ]

fuse_uring_commit_fetch() error path called fuse_request_end(req) without
clearing ent->fuse_req when fuse_ring_ent_set_commit() fails. The
still-pending fuse_uring_send_in_task() task-work later dereferences the
dangling pointer through fuse_uring_prepare_send(), causing a
use-after-free.

End the request with fuse_uring_req_end(), which handles all conditions
already.

Annotation/edition by Bernd: The UAF should be fixed by other means already
and actually has to be avoided that way.
Just checking for ent->fuse_req == NULL in fuse_uring_send_in_task()
would be prone to race conditions, because if malicious userspace
would commit requests that have passed the NULL check, but are
in doing args copy, it would still trigger a use-after-free.
Setting ent->fuse_req = NULL in fuse_uring_commit_fetch() still
makes sense, though.

Reported-by: Shuvam Pandey <shuvampandey1@gmail.com>
Reported-by: Berkant Koc <me@berkoc.com>
Signed-off-by: Zhenghang Xiao <kipreyyy@gmail.com>
Signed-off-by: Bernd Schubert <bernd@bsbernd.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished and matched the fix on upstream as
**`7d87a5a284bb3`** (also **`79f6e8deb22fe`** on a later branch) —
*fuse-uring: clear ent->fuse_req in commit_fetch error path*. That lines
up with the commit we analyzed.

On this **6.18.44** tree the buggy error path is still present and the
fix is not applied. The earlier analysis stands: **YES** for stable
backport — small UAF fix on a default-enabled FUSE io-uring path, with
maintainer sign-off and a known reproducer.

 fs/fuse/dev_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 6f74c345080f4..0d76821cf4ec6 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -947,9 +947,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 		pr_info_ratelimited("qid=%d commit_id %llu state %d",
 				    queue->qid, commit_id, ent->state);
 		spin_unlock(&queue->lock);
-		req->out.h.error = err;
-		clear_bit(FR_SENT, &req->flags);
-		fuse_request_end(req);
+		fuse_uring_req_end(ent, req, err);
 		return err;
 	}
 
-- 
2.53.0

