Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565AB3CF688;
	Thu, 17 Sep 2026 18:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669034; cv=none; b=cT9/Uncm57SG932AX39w/qQG+zuHozKh04Lx2XyXIIBTAzjAX3Ed+BXkesnROuwhl34yJJhFsQJQGGWXG16hMeXtclbU9TRpiiwkNlyp18zsga4fJbHyVphQ8coIzqLPRc+Z2nmrCcg0CfKKKL8INgSC0U1W+Df97DBgDM/vXNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669034; c=relaxed/simple;
	bh=uSDup6Pu0AnUG4X5Ka+j8l/3wJAvNMnDQCydR2ft+aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1iqpY+JzNv9mnC+jlbi8h6kXxojURQ2WUntWeiQ+QNHkJUq3q4k7e/NhAya9ousl92CHT3JZ3fL4BswZzmHdWMDHkbaYTv25W8GoiByB9orJ7vI2qDHKqCorJowPAz/32NJakziPpVSpd12CdfHuhopUqB5v+JyE8CojljUHxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2r1H0+Ls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2r1H0+Ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718E11F000FF;
	Thu, 17 Sep 2026 18:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789669033;
	bh=7ZoZT7dn/DSR9K2DvH6thmOXInvNanRNgrJ5sE3qYv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2r1H0+LsqBnesDZHDa9urux8q1f+uRof/m2wUMo7G96QPlI1ABfFz2tELnJyUndle
	 0ujD4NCFPNA+O7ZHAOss2HDgqYmSq+oPVhJKOZOnfK9HTWGHkC6nEzq6ICuRCM3WzE
	 Ku8U6nuwV1AS1B7PTsHIWMsJj4VN28OzWsHQIC1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0622/1102] btrfs: send: fix lost error return value in will_overwrite_ref()
Date: Thu, 17 Sep 2026 16:09:25 +0100
Message-ID: <20260917151555.693249331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit d0285dfbc3b46f41395b26ee2f4a16d99fb3e736 ]

The direct-return refactoring in commit b3047a42f55d ("btrfs: send:
directly return from will_overwrite_ref() and simplify it") changed
will_overwrite_ref() to return directly instead of going through the
common out label.

That resulted in a negative return value from is_inode_existent() to
start being converted to 0, making lookup errors unable to be
distinguished from the inode not existing.

process_recorded_refs() expects negative errors from
will_overwrite_ref() and aborts processing when it receives one.

Return the value from is_inode_existent() to restore the previous error
propagation behavior as it was before the refactor.

Fixes: b3047a42f55d ("btrfs: send: directly return from will_overwrite_ref() and simplify it")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 2fa577d4a232d..21792774f45e3 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2157,7 +2157,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 
 	ret = is_inode_existent(sctx, dir, dir_gen, NULL, &parent_root_dir_gen);
 	if (ret <= 0)
-		return 0;
+		return ret;
 
 	/*
 	 * If we have a parent root we need to verify that the parent dir was
-- 
2.53.0



