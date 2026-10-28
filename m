Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211644;
	b=C2mVmFhsOacDKGMQ9Ek31g5gAQomjjAq71BsBqoOZPzui+mlbr2rcpxXmSw8QjX1Qd6i
	 qfDsaBtEyfp3vMYg/x6dRwJcfevMp4qeYvZnWbHXPaR3LechhnWpee810kf4nZ5M38Jxc
	 eyxgyJXFUuJrh5VMmVM7zQaJSGHYjf0IEvnKr/+N4m0HcyHvbGjIoUm4S4840RxKMsok/
	 Y+J9+U1WHIfVsVPDrrHvQ0x6+MRYc0Q28kkoYK3s4YQlHupX+WVULAw9QiKrxfrZgea8A
	 RlglOOVovk8vzmmRJBI60erV2Vc+vOVnAsZ6T15CbW/6B0JNTZibcbEIOq99Bw2Fqzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ukaqb/S6dW/WXm79BXzT7RFZxd3Oz1753Vw2UZUyS08=;
	b=EVXX6CJtBtES/SodLxMHRYyX6d1J4YVBo8lQ2mag8fJIGSIsOPCzxg3pEX2zTLrjT/dr
	 Fb3iQDxCKgOL9tPt6qeV+jm0WnpZy36Xh/hnsCMjqWU2WXdiXHyizkVtDVgK5LnhQd2is
	 agiIcER0CAyjyAJYrZb7l0bqQSatrL8jlwaNHioZ+18tLsAn63a+WILH2XVFmp4PkqnV1
	 /9Gq21yFuzyzaAtVDmyZ5zXI3+1pKxjXMLX2yHUvSILyKSBraxdIk/arhHt5tv5rSoUUi
	 RSmcDAS2gxhhZir0mPbEO8MQ72f9CO7G3u7vSGasRArse6h8yVOIHJmCbm/SMhAN1Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrWlwD58;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B09606A322;
	Wed, 28 Oct 2026 18:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrWlwD58
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60ECF1F01825;
	Wed, 28 Oct 2026 18:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211643;
	bh=ukaqb/S6dW/WXm79BXzT7RFZxd3Oz1753Vw2UZUyS08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrWlwD58uHoN3rBl0PynGJ/4FH6IX75L9ICKW/kD4vw/jpblNlvFmMsLb3GGRpDYo
	 iFla78dur7XPAZNKGZaelY/3qawZEvY6Xyv9DaBXFk9Cu500MvwsXHurEup7VETksF
	 QzcQR8krBgHorvsttOkBIspKM/amtvDfCL4Kot7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 449/571] namespace: dont copy an unmounted mount tree
Date: Wed, 28 Oct 2026 17:59:56 +0100
Message-ID: <20261028170018.682402459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 8bacbf6be959973b28b691713a872c12eae69eec ]

may_copy_tree() accepts a mount whose root is an nsfs or pidfs file
before it checks whether that mount is mounted. This exception exists
for nsfs and pidfs mounts. They are part of no mount namespace so
neither check_mnt() nor is_mounted() would let them through and
bind-mounting a nsfsfd or a pidfd wouldn't work.

Problem is that exception also admits a bind mount of such a file when
it was lazily unmounted and is only kept alive by a file descriptor:

  mount --bind /proc/self/ns/net /tmp/x
  exec 3< /tmp/x
  umount -l /tmp/x
  mount --rbind /proc/self/fd/3 /tmp/y

With MS_REC or AT_RECURSIVE copy_tree() doesn't stop at the unmounted
mount. It copies every mount that stayed attached to it as well. So if
you have a bunch of overmounts over the nsfsfd or the pidfd the whole
unmounted stack is copied. That's a bug.

So refuse to walk an unmounted tree. Copying its root alone stays
possible. So a bind mount of a namespace that is gone can still be
recreated from a file descriptor on the old one. The file descriptor
pins that mount and its root and __has_locked_children() only reads the
direct children which don't leave the parent's list without
namespace_sem. The internal mounts carry MNT_NS_INTERNAL instead of NULL
and are still walked. Copying an unmounted tree recursively fails with
EINVAL.

Fixes: e149ed2b805f ("take the targets of /proc/*/ns/* symlinks to separate fs")
Fixes: ef4144ac2dec ("pidfs: allow bind-mounts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-4-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: adjusted context for inline mount validation in __do_loopback() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index d7f157e2a7bb8..3c20771eabfff 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2391,6 +2391,9 @@ static struct mount *__do_loopback(struct path *old_path, int recurse)
 	if (!check_mnt(old) && old_path->dentry->d_op != &ns_dentry_operations)
 		return mnt;
 
+	if (recurse && !old->mnt_ns)
+		return ERR_PTR(-EINVAL);
+
 	if (!recurse && has_locked_children(old, old_path->dentry))
 		return mnt;
 
-- 
2.53.0



