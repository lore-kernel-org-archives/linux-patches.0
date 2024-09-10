Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA4346444;
	Tue, 10 Sep 2024 09:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961949; cv=none; b=ZTznIK7NRu5qkTfIQ4mGJWUdz80A6o3vF2pftlTxSO1oDtb/6TJKZr0D5/xu4Cq0jv5vbeIV1BfHTeA8zzGfVHyDsZ3TyXbZZqlmN/d7S6/rSVy7U3pW4T35dZpawv050koVGxOIQATyYq2ApYInneF1CR6qBM1Aywsy/pJpWrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961949; c=relaxed/simple;
	bh=jhCiTt4QoXbx9RXy0Pa13QdC43qaAPLkliPqWAQ4uGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQpjZzt6Yg7vSaMu4TdaBsyRGye+bUPZVkK7C2bnPW9in2n5GK8JROktZ2cnpapp7+Msreb59FYp7yDrXP2O5VdS8yoGhnpfEkgNUXoX1JRZLDNpHTGa7Pl1NM2Cx+tHdlRlp7MWY/jaKabQ4P1LEQnonpTuNXRrA39aL3eUwp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccR9e3R+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccR9e3R+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0678BC4CEC3;
	Tue, 10 Sep 2024 09:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961949;
	bh=jhCiTt4QoXbx9RXy0Pa13QdC43qaAPLkliPqWAQ4uGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccR9e3R+nx2dIfOBJewH8eQqoq31/9XMp07NWMUHRiiXe3/4RGD8If6oRXiQtxcvi
	 gLQXyMZWVdEiIr9NUWxf5mfAxu518Ao+qsmhiYQGRz8x68Gn/TmHep+OcsK9uqAPbL
	 HNA7fvzayEDoXI4o4lHKDDIXw3ftbAl4TOZ9fD3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 243/375] btrfs: handle errors from btrfs_dec_ref() properly
Date: Tue, 10 Sep 2024 11:30:40 +0200
Message-ID: <20240910092630.715760128@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 5eb178f373b4f16f3b42d55ff88fc94dd95b93b1 ]

In walk_up_proc() we BUG_ON(ret) from btrfs_dec_ref().  This is
incorrect, we have proper error handling here, return the error.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 96cec4d6b447..033eb428ffcd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5754,7 +5754,10 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 				ret = btrfs_dec_ref(trans, root, eb, 1);
 			else
 				ret = btrfs_dec_ref(trans, root, eb, 0);
-			BUG_ON(ret); /* -ENOMEM */
+			if (ret) {
+				btrfs_abort_transaction(trans, ret);
+				return ret;
+			}
 			if (is_fstree(btrfs_root_id(root))) {
 				ret = btrfs_qgroup_trace_leaf_items(trans, eb);
 				if (ret) {
-- 
2.43.0



