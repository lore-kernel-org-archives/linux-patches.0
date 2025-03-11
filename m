Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481ED25DAFF;
	Tue, 11 Mar 2025 15:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705629; cv=none; b=fqOtGkWupvRGpN3m4nkIBqzN/jvIRzsv3rSNs2VUZSPqYxCMo/kWU4fCHw9or22zu+o0Z8s7YtSxctL66KP4u0C8GIqp9zfBg5GCpfjvp/JPhS5Da4Ir7IILoD8/lu2FJ2SWaSKa7WkZ/v/nAx2FnUwARaJisX/+84Iiw9smcaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705629; c=relaxed/simple;
	bh=K2gdVGll4hvYDKtsTc/VNer/jlE4y3ALeScnY7zOiJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNWKvmjmeXglSSEdGNRhlyKkZZ2GlaEPCI70Hbx4+kG1mRpZezizvTCUHTx0LLCdKWQPs2b8uUNHFjKHzYcBBrdQ70GN55hTaTWDFGNgLZ94ZGdRJ9wWx01mJCEogIFzNIg2pYUiIQfRRqV/ub4q5eKU2q/3qlD4zE9ZA30OPzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jaMuDgZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jaMuDgZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CDDC4CEE9;
	Tue, 11 Mar 2025 15:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705628;
	bh=K2gdVGll4hvYDKtsTc/VNer/jlE4y3ALeScnY7zOiJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaMuDgZfd8A6LJOqApM/TZqXfujGZMMk7KxxXRE7DuwFR9BO9A809X+zggmftA5SJ
	 PkzkIqDJZoNRqMwJCgtlyf2HlNiBuLG94/Mk9PS3BAOdiG/kRIXvcWXODZu0+DWfhd
	 EecqxLRhHCrbbkWWiG8chFbNrmoSpy3h5RgPD+jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Anton Mitterer <calestyo@scientia.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 082/328] btrfs: output the reason for open_ctree() failure
Date: Tue, 11 Mar 2025 15:57:32 +0100
Message-ID: <20250311145718.145399232@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1217,7 +1217,7 @@ static int btrfs_fill_super(struct super
 
 	err = open_ctree(sb, fs_devices, (char *)data);
 	if (err) {
-		btrfs_err(fs_info, "open_ctree failed");
+		btrfs_err(fs_info, "open_ctree failed: %d", err);
 		return err;
 	}
 


