Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC7F186E4B;
	Tue, 10 Sep 2024 09:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961476; cv=none; b=g4X8985pDHcE7tDyJ0TIJVcm3B4NiwRgB5MU1nzS14I0Qj/6fBdmYv9t8hQDqmHRQp/6CZAwjyTKwnW5SS/lYXgTc1+xnutfZJjQOswwdLb2PZHcQFxVvw0SMx3Dc4M2jAmw375ZjavLl49Yvd9oGdhAgL3GyGyaHlrvn/KrfGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961476; c=relaxed/simple;
	bh=uReB2FsC1dEgdY17Rwby9TJjKbmWkeKCVmOt96U45hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzHfLtnal1TeLpSq9DbtW96ZzWZGNETfTrLQJ59jl8qNiEu9ksbOlLV1xljpesEwNZvwZHmuqsy1PJGTgEmV5dhEcWwlEw7ar1Renq9GcYh6Y6MVWSS5rGq+Y317ATcsZ3MN9VV5JhZ2mOHuwIEskdiGaDp89+OvBk9b13YJdpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQMn4/d5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQMn4/d5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7150C4CEC3;
	Tue, 10 Sep 2024 09:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961476;
	bh=uReB2FsC1dEgdY17Rwby9TJjKbmWkeKCVmOt96U45hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQMn4/d5umo0F3STNCcvp8PNL6QgoDqS3/3Y51yxflEqLi5j+OS2xowhtRgEM0YtY
	 y2DckI+KyaI1um5lxAT8VIz4NuJlZuJGK6JzYqKJkcvZMETXZBfejnohsduUd7IwG6
	 W3mV+2yIOh/3fcU8dRNhHqgxWMxvIsO0FAyiRuwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+81670362c283f3dd889c@syzkaller.appspotmail.com,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 083/375] btrfs: qgroup: dont use extent changeset when not needed
Date: Tue, 10 Sep 2024 11:28:00 +0200
Message-ID: <20240910092625.024402866@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit c346c629765ab982967017e2ae859156d0e235cf upstream.

The local extent changeset is passed to clear_record_extent_bits() where
it may have some additional memory dynamically allocated for ulist. When
qgroup is disabled, the memory is leaked because in this case the
changeset is not released upon __btrfs_qgroup_release_data() return.

Since the recorded contents of the changeset are not used thereafter, just
don't pass it.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Reported-by: syzbot+81670362c283f3dd889c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/000000000000aa8c0c060ade165e@google.com
Fixes: af0e2aab3b70 ("btrfs: qgroup: flush reservations during quota disable")
CC: stable@vger.kernel.org # 6.10+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4269,10 +4269,9 @@ static int __btrfs_qgroup_release_data(s
 	int ret;
 
 	if (btrfs_qgroup_mode(inode->root->fs_info) == BTRFS_QGROUP_MODE_DISABLED) {
-		extent_changeset_init(&changeset);
 		return clear_record_extent_bits(&inode->io_tree, start,
 						start + len - 1,
-						EXTENT_QGROUP_RESERVED, &changeset);
+						EXTENT_QGROUP_RESERVED, NULL);
 	}
 
 	/* In release case, we shouldn't have @reserved */


