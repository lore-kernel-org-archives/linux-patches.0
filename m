Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0743B3C1D;
	Mon, 23 Mar 2026 15:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278575; cv=none; b=tK5JClBbqqRdXlfCqHhoFHsTpaDFwYFtDOhJbLgrBfVfLevZJOTprjPWuCWFysgv/dByQ/lKk4a3V+rr196b9IgQQsOFHASvv8iDaRMQu+zPYI0umJsgVZ9phvpkxThXpDROCrjcHQtftLdobpmaraFP5GzwSHB16wLiolaavfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278575; c=relaxed/simple;
	bh=07AQdiML0RskApom3OJ8weM1AO3tgfvLIM7Cx5QrHYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rForgGWinw7d4cBcUDL+mzS8KXjQduIp1a6Zrm+//08g6IkZ6guvrU8FfJfEKaCgaJtmNFSg5LPAO+G4NXsx3BEIgca87gyAW28YXZXkjo5d8jThb1jy/bGc/2t4z6bvsYg3TM7BO5ZDSsh2DMCLPqClhPCHAR78EUvWVDS8JK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OsPI5wjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsPI5wjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D23EC4CEF7;
	Mon, 23 Mar 2026 15:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278574;
	bh=07AQdiML0RskApom3OJ8weM1AO3tgfvLIM7Cx5QrHYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OsPI5wjtWeiq45+6eWtCVUR/qq8jfQ713kzrZ5PrzoonETy//MKt0v2Hoi3vy1mCX
	 6QLejF3cN8oXocWvyUDGx9RhlPSXdNDTAAMNZWNeJMlqGl2s8YRpbTdH8hEm0EFiaK
	 Vw3x6Syq3NWqPJW7Y/emKpN4eA8+5e5/vHm3ya8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <asj@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 351/567] btrfs: abort transaction on failure to update root in the received subvol ioctl
Date: Mon, 23 Mar 2026 14:44:31 +0100
Message-ID: <20260323134542.520587125@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 0f475ee0ebce5c9492b260027cd95270191675fa upstream.

If we failed to update the root we don't abort the transaction, which is
wrong since we already used the transaction to remove an item from the
uuid tree.

Fixes: dd5f9615fc5c ("Btrfs: maintain subvolume items in the UUID tree")
CC: stable@vger.kernel.org # 3.12+
Reviewed-by: Anand Jain <asj@kernel.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4037,7 +4037,8 @@ static long _btrfs_ioctl_set_received_su
 
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
-	if (ret < 0) {
+	if (unlikely(ret < 0)) {
+		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
 		goto out;
 	}


