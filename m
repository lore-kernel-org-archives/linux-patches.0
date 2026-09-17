Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6BA4B7A55;
	Thu, 17 Sep 2026 18:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671254; cv=none; b=B5M1GlzNwmQIO4+ZTjouyaQaWRHv4EkhGaDGpxSmLpG+/gfloekhJlU/JlK1gJyaiOvsXzSei0NJoLl13wUR/huC6Wmtg4PKbnWozuV+s+zaFQfz64D2FSVbHwZJeayDU9oiAQKNcR8p7p9JhudOXjm/1kLc/4wtfaSBaBo/oQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671254; c=relaxed/simple;
	bh=M2QaUc0bZCZ4Wjhc3YI5uHjCJlEyoKIGoLvgckdr/YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qr/C7uiFHAPh/Zszc/kh55bGvDnUaWpOs++FtK+BWKO9h3106amKUJQWeiO0NHpOlc1KfY2AIs8W2iTeiK+/GO4S4WMb108jtQP8b2PUM1Ulu1Pe02uXBubt7MUxm4+VPXEul+qeUe8b1NMTM06kFcmW8OMOaNXhfQfmAY3SMrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqC2ZtAt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqC2ZtAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA311F000FF;
	Thu, 17 Sep 2026 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671253;
	bh=INzv7FSRJp7Oi0tBzsuL7k4L3KgbEx1x/zrbldZRTvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VqC2ZtAtcVkECxY37GttxfNKIaYNFVSdQMKMy01lX2R8yUJO0RHE44Uzq0LaCExIx
	 QKBUry9AbAyctnzwkAcTUqAzAwxprMWfqfnR0rmRo3bRSee0fTLVOd9PQYO8eY3FHO
	 8ywdrVhChXzMGukJJcz/shsDX34JmS/Ty6wfU3j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0915/1102] xfs: destroy seen inode bitmap when we fail to add a dirpath
Date: Thu, 17 Sep 2026 16:14:18 +0100
Message-ID: <20260917151603.593688863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 1a441c6842da75c5b862cc1c9f7969d6a93b54b9 upstream.

LOLLM observes a memory leak in xchk_dirtree_create_path if we create
the directory path object but appending the name to the path fails.
When this happens, we don't tear down the (empty) seen inode bitmap.
This is a pretty trivial error, but let's not leave logic bombs.

Do the same for a similar bug in xrep_dirtree_create_adoption_path.

Cc: stable@vger.kernel.org # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree.c        |    1 +
 fs/xfs/scrub/dirtree_repair.c |    1 +
 2 files changed, 2 insertions(+)

--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -259,6 +259,7 @@ xchk_dirtree_create_path(
 	dl->nr_paths++;
 	return 0;
 out_path:
+	xino_bitmap_destroy(&path->seen_inodes);
 	kfree(path);
 	return error;
 }
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -619,6 +619,7 @@ xrep_dirtree_create_adoption_path(
 	return 0;
 
 out_path:
+	xino_bitmap_destroy(&path->seen_inodes);
 	kfree(path);
 	return error;
 }


