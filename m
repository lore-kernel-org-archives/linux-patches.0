Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063586;
	b=y2zhJO7j9DqPOrTZDjplryU7HV0zSBsAjLl/QWKkKcKAxCN3mQhZIbkYb2UQY6e14VOK
	 iLYX1i81MDakdZvQJfW3oPG9kxVqltfhVWjcIK9JyN5Z6PXcIN4s49v+jbynLYfOfzEvz
	 2gl232E0FD1GXRUKy1jV6mCQmtd20f0dz3Km4LeF9c4cXnu/Pdi/+DmONGx2BwUkXP5l4
	 qFThJo9+e8dUJmnXrW5sWyEJXCiQ1u4XUecC89CzXMMiKAidXqerIY8nP6j42nzGO7oFT
	 6xXad4TOuDaaPtxiMMKKs2x+/aDu89eB+Kkwcxc476ZoqVyUkLWSjaDbdGGC+YRQwfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xofuk4/QLRugsOrEnIG5pdT1Xq9P7Nn6TyTJsHaV4Cw=;
	b=l+MrqOlq3U91tpU2S1uMq/1q0R7GV5wH5b3HlCR0eUP+VRPCZC4iAA56iX3+OD3AxatH
	 FHKQSIzzCdtXPUdnfjqOso9YJgU8LutDd5uUVAKO/LkuAtozpMVoGrUmKh5V7vrRaWfS9
	 XH5t5bOfUNtyOFB9AKnglfrzmIEwgl4Q0hTvoh4zurcTFk3o010WzosBRPrOh59epWQwR
	 nA27EJiQEHeNg4IqkTY2S7isIEYBwIv6KdmgxNmGK6P7xnfiLs6WSX66m5i937rzZil8R
	 xfyPjtytOjUeM7mBLos3zhhc6p8Jw89gP9UBnY23syEuH8rLELXvocbDtq5NR/20g2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkY+crE4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C541160A263F;
	Sat,  7 Nov 2026 14:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkY+crE4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226B31F008A2;
	Sat,  7 Nov 2026 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063585;
	bh=xofuk4/QLRugsOrEnIG5pdT1Xq9P7Nn6TyTJsHaV4Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkY+crE4PkbDSeSURzoB2SzZsWLxv7EHmOsaIiX+mmwwkPdm4uNzwH/0nvlI21wCi
	 H6QA9JY50QpTwBM803WKETpEOZPhaLkaA0H+1JQhubnKcdZD0H1HCnLcGMuhdnx7Bp
	 KUw8F4YEYvb3EV6wBDx60m/ySElxNLNtq+qh7gdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 712/869] listmount: dont wrap around with a U64_MAX cursor
Date: Sat,  7 Nov 2026 08:56:34 -0500
Message-ID: <20261107134917.020840911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fd7949d88a6c5..bb73b317f9e72 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5998,6 +5998,8 @@ static ssize_t do_listmount(struct klistmount *kls, bool reverse)
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



