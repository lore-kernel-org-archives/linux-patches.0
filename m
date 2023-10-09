Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357261A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TL5gXvrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80EBC433C8;
	Mon,  9 Oct 2023 13:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857827;
	bh=C8AQGxA+ABLirQjbxbb7VhpfvCTcG6O8xMWS/9C3T0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TL5gXvrYLw6Qymr5datnr9oHOSzBgQP5Q0ulPW1WQrqLwWnSO4AqeKNd5n+lRlVOB
	 7I+nbnZlopBNqxp/8Im1i2HU3O9TSKXOaqLEVnIfuLUOJ1xybWhROq+Ka4nzqn+LWm
	 DkX0YCgSU0JIsBhpIfTCGlHHbZ/qcA0J7SuNi6bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 161/162] btrfs: fix fscrypt name leak after failure to join log transaction
Date: Mon,  9 Oct 2023 15:02:22 +0200
Message-ID: <20231009130127.369953554@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit fee4c19937439693f2420a916169d08e88576e8e upstream.

When logging a new name, we don't expect to fail joining a log transaction
since we know at least one of the inodes was logged before in the current
transaction. However if we fail for some unexpected reason, we end up not
freeing the fscrypt name we previously allocated. So fix that by freeing
the name in case we failed to join a log transaction.

Fixes: ab3c5c18e8fa ("btrfs: setup qstr from dentrys using fscrypt helper")
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7491,8 +7491,11 @@ void btrfs_log_new_name(struct btrfs_tra
 		 * not fail, but if it does, it's not serious, just bail out and
 		 * mark the log for a full commit.
 		 */
-		if (WARN_ON_ONCE(ret < 0))
+		if (WARN_ON_ONCE(ret < 0)) {
+			fscrypt_free_filename(&fname);
 			goto out;
+		}
+
 		log_pinned = true;
 
 		path = btrfs_alloc_path();


