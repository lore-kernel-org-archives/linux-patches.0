Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BB515E8B;
	Mon, 30 Dec 2024 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574323; cv=none; b=ohDwfvFe668JVCc+mliq/x1WwVK3en9PCi2VNp9vKFADBIEXh1hnlQGncx7m2mJLaPpG8cG9LrHfhx1klCBvFq3v4VmR43wMt3RkG0QQHVTO7oMj5CX5BnLtotnEhggoX8OMM0XEDaXUCp+DxU/2eUEoC89Q1p1JTqpRObK62J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574323; c=relaxed/simple;
	bh=Ys/hMdyRSk/uCTMxcF90hHRqnXmHtfWtLpdgGSURdks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzyLy8TnkQsg65GLqKzxKfX6RiiuuEw4U9VkB8kdgcfhziVi30etKjxPXbBp5mt1FS+5PJh1lqv4NpdD6dG8bt0YJYOpfDqcXx8K9DuRd1gSx5MuNM2O4YsyeYLthNwkWoLRHJnQSE/uIMk7repQb0a69Xu95SW+8OZKfIEgIDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GovyooL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GovyooL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF93C4CED0;
	Mon, 30 Dec 2024 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574323;
	bh=Ys/hMdyRSk/uCTMxcF90hHRqnXmHtfWtLpdgGSURdks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GovyooL9yvCd2wW+eUQoZTVyUDVJNiF+HZeqHaWbCe2yGN98dkv90mm4+w/GpwZk0
	 h40g1ip9PY8l1bgq0S1XrzQ8/8GYSlG3mqQxXD7gJCZ+/Mh0Z1OhOf0m8GdP5ibt+k
	 7yO66Hnr3/kasBUmsWy4aupnii7VQqPXmaEanyGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 102/114] btrfs: avoid monopolizing a core when activating a swap file
Date: Mon, 30 Dec 2024 16:43:39 +0100
Message-ID: <20241230154222.045141330@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2c8507c63f5498d4ee4af404a8e44ceae4345056 upstream.

During swap activation we iterate over the extents of a file and we can
have many thousands of them, so we can end up in a busy loop monopolizing
a core. Avoid this by doing a voluntary reschedule after processing each
extent.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7117,6 +7117,8 @@ noinline int can_nocow_extent(struct ino
 			ret = -EAGAIN;
 			goto out;
 		}
+
+		cond_resched();
 	}
 
 	if (file_extent)


