Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062517;
	b=e2VP2CGFzxoBP6CbH1GjSHlnqdbPzYhLrJJ4JB7wBD69f2GJPQZj5hP+iIaehqXyhOd7
	 rhxedlbTDDTYB+S/dkU5BlkonMS8xqD5R7KpBB01TZqj/MbvUmopiVPFrjZpkoXpjrJEw
	 zKxoALvn/Fcjb1PC5eCWyoplBzg9eUlDhBM4I5uvniAqoSnC4ACzo9Y3FfGXEQZc9W6sz
	 6KR9T6ST8Ps/QUl35E20Hzjv84HPb5UJaUzr7uR5lNbhSZf9ttdFkdNiZPhN2YORqbTo1
	 /czme1ZB1D03JA8P4zKA6Ib1/fyfgZVloS96M4O5CoACTvsftdZMO10DTGnt4HC2oWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H2ECwBAJeX7Lfcb3mfX3W7GhOLsUB0qBqg3iaWwCwsU=;
	b=xp8e9gHd+sgYoc+8KFn2zcSz721BGspRTVRebRJAfXEyUnhbaRchlvHjf3AVqVMCLqco
	 jqx7IQSawmA5FNOMPEWxi1ch36vfkqXJTtQZ/fQpRyOo7PlphDsiMdMsqgup8S71P76eX
	 V5NnEPTYO9QLrAMjyhTpDrNu4P2bdvU+3mzvXRHk7vztVv1s9EaY5khCkaQA7akeWVVy4
	 n9yQTCmfg5j0ZaI5PWw8YH2/jkAQThHPuA0SDw1sOSv7BD5Gzr2K3Sxd0mp7/ge2yY0Bt
	 rq3VPC3ibVhhlc223drrKyfCfLx6/jVX+PgHRP/dEUpdOYKs1X68vD80QA2Q8y5Fhpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tb5yqcIW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFCC606A33A;
	Sat,  7 Nov 2026 14:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tb5yqcIW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8B41F008A5;
	Sat,  7 Nov 2026 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062517;
	bh=H2ECwBAJeX7Lfcb3mfX3W7GhOLsUB0qBqg3iaWwCwsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tb5yqcIWZ68Gm8cqWA7P8dYEvctFq1BGFqgB3qFsZezIKDP2RKMRzytIxS4bcYxeu
	 FfJS8qf/Y8PPewnHoCxPMWSrJTS4S38kdPMR3RvJ6Sxp1ywQscqgMGTn07mIbyR46r
	 s4j4KdZ75XN0yxV08MxV5dccUOCVIPAEn1I7tDHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1413/1536] listmount: dont wrap around with a U64_MAX cursor
Date: Sat,  7 Nov 2026 08:57:09 -0500
Message-ID: <20261107135037.512096691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 95a5412022e437691f4eb1924ff249d9044f5ed1 ]

do_listmount() takes the last mount id the caller saw and looks up the
first mount after it by searching for last_mnt_id + 1. With U64_MAX
that wraps around to zero and the search finds the first mount in the
namespace. So a cursor at the largest possible id restarts the listing
from the beginning instead of ending it. A cursor of U64_MAX - 1
correctly returns nothing.

No mount will ever have that id. Mount ids come from a counter that
starts at MNT_UNIQUE_ID_OFFSET + 1 and a caller that only feeds back
ids it got from us can't hit this. It's still wrong. Nothing can come
after the largest possible id so return no entries for it, just like
for any other cursor past the last mount.

The reverse direction isn't affected. A cursor of zero is special-cased
and anything else is larger than MNT_UNIQUE_ID_OFFSET so last_mnt_id - 1
can't underflow.

Reproducer, unprivileged:

    #define _GNU_SOURCE
    #include <errno.h>
    #include <stdint.h>
    #include <stdio.h>
    #include <sys/syscall.h>
    #include <unistd.h>
    #define LSMT_ROOT 0xffffffffffffffffULL
    struct mnt_id_req {
    	uint32_t size, mnt_ns_fd;
    	uint64_t mnt_id, param, mnt_ns_id;
    };
    static void list(uint64_t cursor)
    {
    	struct mnt_id_req req = {
    		.size = sizeof(req), .mnt_id = LSMT_ROOT, .param = cursor,
    	};
    	uint64_t ids[8];
    	long ret;
    	errno = 0;
    	ret = syscall(__NR_listmount, &req, ids, 8, 0);
    	printf("cursor %llu: ret %ld errno %d", (unsigned long long)cursor,
    	       ret, errno);
    	for (long i = 0; i < ret && i < 1; i++)
    		printf("%s%llu", i ? "," : " ids ", (unsigned long long)ids[i]);
    	printf("%s\n", ret > 1 ? ",..." : "");
    }
    int main(void)
    {
    	list(0);
    	list(UINT64_MAX - 1);
    	list(UINT64_MAX);
    	return 0;
    }

Before, on 7.3.0-rc7-00252-g4e3259b08c54 (vfs.fixes) in a VM:

    cursor 0: ret 5 errno 0 ids 2147483651,...
    cursor 18446744073709551614: ret 0 errno 0
    cursor 18446744073709551615: ret 5 errno 0 ids 2147483651,...

After:

    cursor 0: ret 5 errno 0 ids 2147483651,...
    cursor 18446744073709551614: ret 0 errno 0
    cursor 18446744073709551615: ret 0 errno 0

Reported-by: shaos <shawnq1@163.com>
Link: https://lore.kernel.org/r/20261020110732.959552-1-shawnq1@163.com
Fixes: b4c2bea8ceaa ("add listmount(2) syscall")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261021-work-mount-statmount_listns_fixes-v1-3-8917a4c1bd14@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 64b431555827b..fa611381c3a35 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5565,6 +5565,8 @@ static ssize_t do_listmount(struct klistmount *kls, bool reverse)
 	} else {
 		if (reverse)
 			first = mnt_find_id_at_reverse(ns, last_mnt_id - 1);
+		else if (last_mnt_id == U64_MAX)
+			first = NULL; /* nothing comes after the largest id */
 		else
 			first = mnt_find_id_at(ns, last_mnt_id + 1);
 	}
-- 
2.53.0



