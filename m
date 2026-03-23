Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127373BD62F;
	Mon, 23 Mar 2026 16:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282732; cv=none; b=VJu96dpvcyzfCjHcd818pNyhcKBsuvX0LczVyk1J2v+jtKiRaOoL4ldOdawUTW68cIMdf6MAxZbmAIsntre/rMMIrflLYgZOF04ft+uj0DR3Xomwk5pzsza1fZo59qtNHNYj7bOIAm6rYGk6V21sVHIRpj0k4ViNDVOSFkWi92o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282732; c=relaxed/simple;
	bh=iwjKHGQwSpRWOPiOQqZ4fMPTyyaE0j7mMrFCLauFzKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZK1DKmtPX8BkuAdOonR3lfVUu8pLt1DcDraUnfOTf57ZSG0eeS6JKTenkoUb0peNEcTYSQ2bTmRtYBytgKqX29llcq67Etbt3kuaSdSVkL1Reu3/vnFDC77ldkL0zjAuCh/J5uqnOom/f2OF6Rx+JtrNPC6ZOjHAbKUCyFyU0Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjEt5pHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjEt5pHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3CDC4CEF7;
	Mon, 23 Mar 2026 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282731;
	bh=iwjKHGQwSpRWOPiOQqZ4fMPTyyaE0j7mMrFCLauFzKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjEt5pHMYrHyfLFVzBewKwOR7UKncPp6cMpBISe/xuiPynV6wum9kAyGA/mpEh19l
	 siLXNxRXwkmXq2hm269oJErjEXtV5FTFjYWknKJG4qINeUbN1Ibmz+YoOsdoxjx3cQ
	 HChw2IdpjpwfyK4fMfEd3YZXMP1eUpYB46tV7XUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <asj@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 264/481] btrfs: abort transaction on failure to update root in the received subvol ioctl
Date: Mon, 23 Mar 2026 14:44:06 +0100
Message-ID: <20260323134531.577774446@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4921,7 +4921,8 @@ static long _btrfs_ioctl_set_received_su
 
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
-	if (ret < 0) {
+	if (unlikely(ret < 0)) {
+		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
 		goto out;
 	}


