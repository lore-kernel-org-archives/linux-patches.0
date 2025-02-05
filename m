Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129B71662EF;
	Wed,  5 Feb 2025 15:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768637; cv=none; b=aGVMp3+1+1beni9G/Ei00TgvvVrOcB9+qIxQS8UE1pRQJrMJ60vUckUyaiLVE00j9d+TdL9LLdeBSk7jMD7KL8QSBmfMfveFTMWizKWwkkpTFBVbnzRJ9t8wpf01HQ6W6hcNQw0pSXxA597B4s4/TUCRgzRM75AI8PhgpzHfXSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768637; c=relaxed/simple;
	bh=8hLZrdEADjJSMlAG43ly2RY0NcnJAdjNSPforRN0TH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adgSRMpjmzXg2+hAUAv5aM4vhpqu+hDBDV80knjAbqXULEv3NhjudIC+93NlBT2V8dcoN2MeuVhREB1Kt9PjIhFqqPkng+bEWq1bbHOxuW/TBIhYS/VbwH+4J8a8TzpcqrASlQ7BCu9SdxEI5LRLPTHnoxuY80oBo2o5DyqIk9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKsqGPHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKsqGPHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D76EC4CED1;
	Wed,  5 Feb 2025 15:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768636;
	bh=8hLZrdEADjJSMlAG43ly2RY0NcnJAdjNSPforRN0TH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKsqGPHhHAXzx25tpPY18FajyNrDFAegb8rmXMdSsJwI8FkPP+z3BFLISLthG0ic3
	 NhkGZQfbqswDkf6ZOO55nouEeZDbSPLEic/DOPiKBby0GyZzjIgz3Z8uMnW0QCER47
	 gj3qF3ebCd6Uteltc/M/EaKdSmwtcKf41OOKozZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Anton Mitterer <calestyo@scientia.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.13 613/623] btrfs: output the reason for open_ctree() failure
Date: Wed,  5 Feb 2025 14:45:55 +0100
Message-ID: <20250205134519.669437532@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit d0f038104fa37380e2a725e669508e43d0c503e9 upstream.

There is a recent ML report that mounting a large fs backed by hardware
RAID56 controller (with one device missing) took too much time, and
systemd seems to kill the mount attempt.

In that case, the only error message is:

  BTRFS error (device sdj): open_ctree failed

There is no reason on why the failure happened, making it very hard to
understand the reason.

At least output the error number (in the particular case it should be
-EINTR) to provide some clue.

Link: https://lore.kernel.org/linux-btrfs/9b9c4d2810abcca2f9f76e32220ed9a90febb235.camel@scientia.org/
Reported-by: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: stable@vger.kernel.org
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -971,7 +971,7 @@ static int btrfs_fill_super(struct super
 
 	err = open_ctree(sb, fs_devices);
 	if (err) {
-		btrfs_err(fs_info, "open_ctree failed");
+		btrfs_err(fs_info, "open_ctree failed: %d", err);
 		return err;
 	}
 


