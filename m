Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF715C148;
	Tue, 29 Apr 2025 17:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948914; cv=none; b=qwK15hEKqOjpDATPACqsxw4NN69U6KFIU0uVRMjRjpvXuMheFpsJMqpMGI6k/bBA74A2mO0DD8xD8SeHhQBkbPuMUyNEt9Vn+V0gbWCanylRJq2pFAujm8HHaCEne5I4RN0NQdYVEQ1XeNipYXB/RxVt1G8nJQGaNH/rt878NJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948914; c=relaxed/simple;
	bh=dj+U1j+SMDq6GBmLWCjKRKCRrlQVlC0z5/rgVHGj2lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISiZ2NQQv3zppbzrZvftg2wyAhcKnCRzKOdbFQv/Il65G9OO6rAuk91QYYSV/8fWqurVfYSCivV6r0AFxEO6z0oQ5aTZ4LGUOzxb8wOZmQ7b6acRGaAIOjj3/+00W3LPOm20XeXcsdrZad8e5p2W7q77JkP5SOx96v3rYXkfCls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B33yJrk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B33yJrk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71889C4CEE3;
	Tue, 29 Apr 2025 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948913;
	bh=dj+U1j+SMDq6GBmLWCjKRKCRrlQVlC0z5/rgVHGj2lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B33yJrk89p4uhmupf7X4nRo2f6rwfpySQQfXODIiQMjC4/Ozjfew5l/vgte8G6ErN
	 8ZYvpe0ZDfrzMAh+F5bEBS4VgqpQ5B9a0S7eEHTzHiRQSIeqaNz7E++47N28csbkGG
	 bmFlCG8ldyyfEFcA29XX/R6y9QL0fOLGm35GAkuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Walton <calvin.walton@kepstin.ca>,
	Johannes Kimmel <kernel@bareminimum.eu>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 162/373] btrfs: correctly escape subvol in btrfs_show_options()
Date: Tue, 29 Apr 2025 18:40:39 +0200
Message-ID: <20250429161129.803245155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Kimmel <kernel@bareminimum.eu>

commit dc08c58696f8555e4a802f1f23c894a330d80ab7 upstream.

Currently, displaying the btrfs subvol mount option doesn't escape ','.
This makes parsing /proc/self/mounts and /proc/self/mountinfo
ambiguous for subvolume names that contain commas. The text after the
comma could be mistaken for another option (think "subvol=foo,ro", where
ro is actually part of the subvolumes name).

Replace the manual escape characters list with a call to
seq_show_option(). Thanks to Calvin Walton for suggesting this approach.

Fixes: c8d3fe028f64 ("Btrfs: show subvol= and subvolid= in /proc/mounts")
CC: stable@vger.kernel.org # 5.4+
Suggested-by: Calvin Walton <calvin.walton@kepstin.ca>
Signed-off-by: Johannes Kimmel <kernel@bareminimum.eu>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1559,8 +1559,7 @@ static int btrfs_show_options(struct seq
 	subvol_name = btrfs_get_subvol_name_from_objectid(info,
 			BTRFS_I(d_inode(dentry))->root->root_key.objectid);
 	if (!IS_ERR(subvol_name)) {
-		seq_puts(seq, ",subvol=");
-		seq_escape(seq, subvol_name, " \t\n\\");
+		seq_show_option(seq, "subvol", subvol_name);
 		kfree(subvol_name);
 	}
 	return 0;


