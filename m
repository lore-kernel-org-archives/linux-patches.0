Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDDB18D636;
	Fri,  4 Sep 2026 05:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501402; cv=none; b=uTLFW1uOVDFXCTca9GOsJWJxVEJ80BO7txmTwpUt5TkP4oedaGe6iPKz6MUc9zFQbayTLGQHtTdir2ldBEEJdd5ANDrb39mvjGlkTcTGV+iep08XIESrq0Cr9hD58dwtSmzAds0qQ152fhQWKjQ830AeBcfQRo2acNCudxkyUD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501402; c=relaxed/simple;
	bh=hkscTYuskfAYtfOzMeHWZ6aBpX6yjwgUj9IM1HKW+y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLgF7VC94/5XDPjLiPaDsLuzp3v9Tp+7QrcqKRCD0DIwfVL+EtedZuvqJhaeimwsDlwMGiL36KTjSpPGfvdM87yZLfnPS9E1EP8oAS9tBSeRbQ1yw5XVtP/OpSJ3dasRlY0vo5Rp1h6ux94w5t4zqjgHGJJ+4Tv56Ieh9e/X150=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4VLyqYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4VLyqYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8A51F00A3D;
	Fri,  4 Sep 2026 05:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501401;
	bh=xQ3RZDokQEpACCbIFQ9ZbfKTz9I+Z0hp67jTrW13Elg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4VLyqYCyM9ZsQCK5GSnzrtKWQRGJEOXXUpq7MTnDVkp9Wej/GSylHeS7lmos3Paq
	 HLhfqVI+14Kd3b0b64TOkg8385rO0h9a6ivmt0lNj0DbLc3IdK2hWpX3uYJu9uCpUY
	 c+4DKC+O4gzae1LpcLckKDz050i1oTnUHOdbVl3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.18 354/552] lockd: fix NULL dereference on lockowner allocation failure
Date: Fri,  4 Sep 2026 06:58:31 +0200
Message-ID: <20260904045758.268055631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 4c7fc129db061c7daab841c4f3c342d894832362 upstream.

nlmclnt_locks_init_private() installs NLM file lock operations even when
nlmclnt_find_lockowner() fails to allocate a lockowner. nlmclnt_proc()
then returns -ENOMEM, but the VFS still tears down the partially
initialized file_lock and calls locks_release_private().

That invokes nlmclnt_locks_release_private(), which dereferences
fl->fl_u.nfs_fl.owner and crashes because the owner was never installed.

Clear fl_ops before attempting to initialize the NLM private state, and
install the NLM lock operations only after a lockowner has been allocated
successfully.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/clntproc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -487,9 +487,12 @@ static const struct file_lock_operations
 static void nlmclnt_locks_init_private(struct file_lock *fl, struct nlm_host *host)
 {
 	fl->fl_u.nfs_fl.state = 0;
+	fl->fl_ops = NULL;
 	fl->fl_u.nfs_fl.owner = nlmclnt_find_lockowner(host,
 						       fl->c.flc_owner);
 	INIT_LIST_HEAD(&fl->fl_u.nfs_fl.list);
+	if (!fl->fl_u.nfs_fl.owner)
+		return;
 	fl->fl_ops = &nlmclnt_lock_ops;
 }
 


