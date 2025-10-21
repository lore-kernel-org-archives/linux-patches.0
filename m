Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89BB2773DA;
	Tue, 21 Oct 2025 20:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077186; cv=none; b=rfJ4stiTZz5nPnV9Gh1Nc87O3ZBxkgfLwa9rip1rUSMT4wb+yxgANWJKv1y5+QwRMKF31Eb76KayqbfKsi4aBUkkHhD0KFfcTdyVwHnbLN3jGmsYvsUJJFys9DAinkdcP8FHGuRfZBvawtqg8wIe7jeLG416gGiF3S60u3N51ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077186; c=relaxed/simple;
	bh=z5wP9VpqJdhpHDNuB0gNbANEBL27/Judkoo2W0YLFk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g7jw+/fk+yZ4/FHINxthGS8EOpn+6rYywPG3GOm/3cGc8CfDVT5dU8d1YYqwSzdd2R69BJvBbkO5IzLYot2gNJkXsqyckOpYTlIQgDa41oIHVmIGDJJiCSQv/4fowoq5GIBysUpJ1ZDj1XjzqqjJqZZB+uRmDMyvDwMEDD/fuq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4N6LiHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4N6LiHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55270C4CEF1;
	Tue, 21 Oct 2025 20:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077186;
	bh=z5wP9VpqJdhpHDNuB0gNbANEBL27/Judkoo2W0YLFk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4N6LiHoa7iDI5JJ4s/j9NhX3+dE+Tn713BzIUOlPirb1YBnb2ZBN+5P5IQ3XtOfc
	 knuOL4JEYoCAFjyf5cDsXh2Jq79rSW4x7YjyjBpMU1R5GtAct0zVFxhEbK/YNZwZia
	 RYfrXEPtbpkPSSgefUJq57KQYl3WYniDJu3AP14U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 026/159] btrfs: fix memory leak on duplicated memory in the qgroup assign ioctl
Date: Tue, 21 Oct 2025 21:50:03 +0200
Message-ID: <20251021195043.819613343@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Sabaté Solà <mssola@mssola.com>

commit 53a4acbfc1de85fa637521ffab4f4e2ee03cbeeb upstream.

On 'btrfs_ioctl_qgroup_assign' we first duplicate the argument as
provided by the user, which is kfree'd in the end. But this was not the
case when allocating memory for 'prealloc'. In this case, if it somehow
failed, then the previous code would go directly into calling
'mnt_drop_write_file', without freeing the string duplicated from the
user space.

Fixes: 4addc1ffd67a ("btrfs: qgroup: preallocate memory before adding a relation")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3740,7 +3740,7 @@ static long btrfs_ioctl_qgroup_assign(st
 		prealloc = kzalloc(sizeof(*prealloc), GFP_KERNEL);
 		if (!prealloc) {
 			ret = -ENOMEM;
-			goto drop_write;
+			goto out;
 		}
 	}
 


