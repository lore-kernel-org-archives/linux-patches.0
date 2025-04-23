Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B36E27F725;
	Wed, 23 Apr 2025 15:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420858; cv=none; b=hNHyTs5zk6uqaOBPGDCadS9E/QEPWtWCcWK9qTcGS80sZ6j4WQuQKJtTLzNdLGWqVXOx72JnuLhhkdT5vIqeJCwgNeVG5YJBVgJ1fcZSQgWyG9+FoPmZHe0n+8Fv6HC4FEzQadjUgFPqbUe3urS70RufYvlEhEYsz0d5IwEavns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420858; c=relaxed/simple;
	bh=p0TGkP6uBs+CJ9wsLSbsyWq3ldbRC0yJIH+FnpWjnxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Od66G0ZTXo+5JA2192aQx4euj3tWQ6Rsl6cUBUWLA/QHacjq33X6HCpXSc4KImyRaF0+Y8ZybvRPyg7F0T1dhdqyy7hI5xgubDYFitforR57XYFKY7sMALRZb3SgP21OVX8afZ7mmtnCz9IIhzHjhB6FniIIyOO1022gXt4wh6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCwmVzyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCwmVzyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE3EC4CEE2;
	Wed, 23 Apr 2025 15:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420858;
	bh=p0TGkP6uBs+CJ9wsLSbsyWq3ldbRC0yJIH+FnpWjnxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCwmVzyI1G758lrbB4f3ViX8Lnq/TeSO1dpGHy4h6FP9NIahznRjcfeJwlORFouX1
	 qeWumzkjRK9eqlKvd3LVdN4BkxwO/rIFykgWNo1SBZsm+fZ14eMIr/XIAmjwhe6Dz4
	 GZF1RzLOXWa1xw0dBqWxZ8gs2AkVI9aftSqaVNVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Walton <calvin.walton@kepstin.ca>,
	Johannes Kimmel <kernel@bareminimum.eu>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.14 128/241] btrfs: correctly escape subvol in btrfs_show_options()
Date: Wed, 23 Apr 2025 16:43:12 +0200
Message-ID: <20250423142625.797762612@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1139,8 +1139,7 @@ static int btrfs_show_options(struct seq
 	subvol_name = btrfs_get_subvol_name_from_objectid(info,
 			btrfs_root_id(BTRFS_I(d_inode(dentry))->root));
 	if (!IS_ERR(subvol_name)) {
-		seq_puts(seq, ",subvol=");
-		seq_escape(seq, subvol_name, " \t\n\\");
+		seq_show_option(seq, "subvol", subvol_name);
 		kfree(subvol_name);
 	}
 	return 0;


