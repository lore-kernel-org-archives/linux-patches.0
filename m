Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CB4346A0E;
	Fri, 21 Nov 2025 13:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731979; cv=none; b=tio5Whfnpb0jSA4KUJBtmRE74OBtDwVV/V6LPhU++F67gIlEjApV1DQuvUFs0/Z++iX4iZMm9buECd31FXYLSjaSRD4SCA+Yei2S6J2R0bC3Yvuk1UNpLe8EHm6+rfCJeSPg/qKmIvF6Q+vhkg6P+H2YV6HmGUK360vKO5aPvAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731979; c=relaxed/simple;
	bh=IyH6dU674VyWLsyhZQrB+xsO1vX2+HxerrF1dwXU6OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gr6xVM/QM5kuco6j9i9J473EHCa1V7A24EVqA3C6XYSHFhVKOBzWP3YoYMYxhA/DI4xhgT1AdfQExTBD2decA1khqEOT8Yd5G8fwl/AWoedbotyxy11O+ATJao04JeEyyYM1HzWd7jSS2EIiy4ZuG2+E+XBs8vNf3DAwoVHpCpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LsOR+yIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LsOR+yIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95289C4CEF1;
	Fri, 21 Nov 2025 13:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731979;
	bh=IyH6dU674VyWLsyhZQrB+xsO1vX2+HxerrF1dwXU6OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsOR+yIMdiRy4iNLK+tRah4SKf9znZD94pILJ9l0n77dTH50N29kXRxcLAoTINox2
	 1A4OnyPtBPgKUXtqqJ8rHDcTmtfeM5wr0AWGY71KTI/54F6H9PAWOP+IudVEYMzD6r
	 Ct6TyCK/PzRmuynI6ql9n41P3HJ2G3N++W5x6eK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 147/185] btrfs: release root after error in data_reloc_print_warning_inode()
Date: Fri, 21 Nov 2025 14:12:54 +0100
Message-ID: <20251121130149.183505494@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

commit c367af440e03eba7beb0c9f3fe540f9bcb69134a upstream.

data_reloc_print_warning_inode() calls btrfs_get_fs_root() to obtain
local_root, but fails to release its reference when paths_from_inode()
returns an error. This causes a potential memory leak.

Add a missing btrfs_put_root() call in the error path to properly
decrease the reference count of local_root.

Fixes: b9a9a85059cde ("btrfs: output affected files when relocation fails")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -174,8 +174,10 @@ static int data_reloc_print_warning_inod
 		return ret;
 	}
 	ret = paths_from_inode(inum, ipath);
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_put_root(local_root);
 		goto err;
+	}
 
 	/*
 	 * We deliberately ignore the bit ipath might have been too small to


