Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A87F514752;
	Thu, 17 Sep 2026 15:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659267; cv=none; b=iHWxj8jGMjDf+8PCYLHKp0F0cuShCqtneIMTrNVdOtNBKRexs4zeUWRRMfDBC+BVStNq8BVRG2wofnSoA4auevAQYyx9LHMW5ii2l2d1oUco9tRwT8NVB6Le81Ob1NBwR2KDMS0EjWgRCOWw27nkGJQnTu1j+O92/1EhMa4TPjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659267; c=relaxed/simple;
	bh=tOVtI3fS6NZpCBZAHfeAQnwNM706vf0ObpNk77KqFBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJVMCAMaegfSfWJs5ZuDTruTLtBE9t4mn560R6ugkJuaMuHJnBblmLkvHwIZZR1GXfeIvgDliVPTScID2FvQqzZ2xRN7H6JqESZTzEc3iV4EknSo+ZDm2/XQiIHj+2vVJVnBmEiKMNjk/H8471kmnz1vYE5KG/oTM7qzd14Ly/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqMm1/Ac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqMm1/Ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1CA1F000FF;
	Thu, 17 Sep 2026 15:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659261;
	bh=UMXsm1KWpxbjwYfaZw34RlQGB4moCp3LCVhkYLYLRP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqMm1/AcwN8+gZ8xTsTGMDLNYfy9ysuag8C11jSMwnT2YzXUm38CtQZ4Xul8qifpy
	 ikLn/ObTeV1A2/1b6NlJHNRld6XvfMty2qHrwIGaRUWXpQpRNwP2lUr9iw4zDtSSy5
	 beGI/bQXardjDyVNSVZ/HLL0Xo1CygB6VrGKWO84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 196/733] btrfs: send: fix lost error return value in will_overwrite_ref()
Date: Thu, 17 Sep 2026 16:08:24 +0100
Message-ID: <20260917151356.042385875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 3ae480c7474b0..a888202397edb 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2066,7 +2066,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 
 	ret = is_inode_existent(sctx, dir, dir_gen, NULL, &parent_root_dir_gen);
 	if (ret <= 0)
-		return 0;
+		return ret;
 
 	/*
 	 * If we have a parent root we need to verify that the parent dir was
-- 
2.53.0



