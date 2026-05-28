Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40FF33372A;
	Thu, 28 May 2026 20:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000085; cv=none; b=a9MymUzr0f2MzwpYghSdpXdBr5QFG/ZPidaq8mOuTdC5ekXBtsJT+e6AVE3TWT4sudw7q2FyUvYd1LP7dTBuPFIa27LSO9DkuwgrX7H0nODyh/UGVwNbRkLwmDiX1vBfPsz53axf3dlDOqj5BGqxUXlGLuvKxMyJbXTcnPMBnOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000085; c=relaxed/simple;
	bh=alyutVkJSOC7Ja05iw9WcwiJTi3m7Xj600gNdZA8l3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIUSWbQDgWAosUHCKLW/J4WaSQFugLugkmJXDUOtMCuughBcLLHpplEcCMgHQvJ06sUQZfTVpR/z4O8QpzFbKJryC+z40ZM6IizNIEI5yR5PSQf/vv5tQ9nW0DklBk+B9KTTPerH/x8O6HZ2vtA/7+cWABhVqfm01TujodDdXL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVuekXn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVuekXn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDE91F000E9;
	Thu, 28 May 2026 20:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000084;
	bh=FB31kwr92R6JcK3Va6SPxJFNcOum3DEYciOCmmhRsoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVuekXn/n1hBvzhLgjChvnkRR6XeLm8tZrk8e0EBM7LSijpsZVbG6vMi49enSSqZP
	 QOf7f3GZLdmVBfr4R6CuKuvTTeNCeyKfNoYvk8lKhbcQHsdPzqJ4wTpP2bA0Mey81p
	 yzG706K5Pajs2ulWciyqEB1XyL7SawelMNTGQ7nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 297/377] btrfs: add macros to facilitate printing of keys
Date: Thu, 28 May 2026 21:48:55 +0200
Message-ID: <20260528194646.952366134@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 95de4b097e25225d4deb5a33a4bfc27bb441f2d8 ]

There's a lot of places where we need to print a key, and it's tiresome
to type the format specifier, typically "(%llu %u %llu)", as well as
passing 3 arguments to a prink family function (key->objectid, key->type,
key->offset).

So add a couple macros for this just like we have for csum values in
btrfs_inode.h (CSUM_FMT and CSUM_FMT_VALUE).

This also ensures that we consistently print a key in the same format,
always as "(%llu %llu %llu)", which is the most common format we use, but
we have a few variations such as "[%llu %llu %llu]" for no good reason.

This patch introduces the macros while the next one makes use of it.
This is to ease backports of future patches, since then we can backport
this patch which is simple and short and then backport those future
patches, as the next patch in the series that makes use of these new
macros is quite large and may have some dependencies.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 1e92637722ae ("btrfs: check for subvolume before deleting squota qgroup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/fs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 37aa8d141a83d..acdb9e52f6fd7 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -73,6 +73,9 @@ struct btrfs_space_info;
 #define BTRFS_SUPER_INFO_SIZE			4096
 static_assert(sizeof(struct btrfs_super_block) == BTRFS_SUPER_INFO_SIZE);
 
+#define BTRFS_KEY_FMT			"(%llu %u %llu)"
+#define BTRFS_KEY_FMT_VALUE(key)	(key)->objectid, (key)->type, (key)->offset
+
 /*
  * Number of metadata items necessary for an unlink operation:
  *
-- 
2.53.0



