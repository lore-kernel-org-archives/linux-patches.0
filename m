Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571CE12B176;
	Tue, 30 Apr 2024 10:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474748; cv=none; b=CNtHzBKoAl3FvY9gBckIu8933F5PyiNYPRWqcNBBqBdrAtkBlrjVkB1jIfiUutlWUsjTmiQRpGya84mPFrchnXz7aUUXVcPrr4MJH+NbpXWDCZ4Kx/ZvtX5LbBiARIfXiOlXfTXslh0jgT7XQCseC2eV7p/toQ8+Sx+hzHwkr9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474748; c=relaxed/simple;
	bh=0tmYN4/7vK/iQr6jMn+UoNHUKZmND2Wk6cRFGFEbnaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhJ/qZ7odDNadxa2nUvKTqxM4XAXwOimCJ1uvjx1r6rnG7Jpd/3WfcRX0xCkw5kfR9dV64r+Mz8wNoSz6cKrFEtjrpK90aRau6MMkrq+R7VuXw7HAiem6/60M+UplHWDjRP1Ni+Slk174akjuHuMQn+b9KyF9yhHMgLJPLDMSqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiTl4Y31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiTl4Y31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DADC4AF19;
	Tue, 30 Apr 2024 10:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474748;
	bh=0tmYN4/7vK/iQr6jMn+UoNHUKZmND2Wk6cRFGFEbnaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiTl4Y310s7c48pKJ/qNcSsfjHo+aRNSHwtpspf0cMfc84O5kicIrsL52KRu5C5/a
	 Arh+FIkTGe0qBOUo42n9NJxCpddK9GdcJ5wivUDKQ1qBWZafHPmnFqQvSmwJcP3+mR
	 sPCFPLMJ4U9TIIdXB3+zq76+q4jcShEGYWR7lvLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 023/138] btrfs: qgroup: correctly model root qgroup rsv in convert
Date: Tue, 30 Apr 2024 12:38:28 +0200
Message-ID: <20240430103050.109356737@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 141fb8cd206ace23c02cd2791c6da52c1d77d42a upstream.

We use add_root_meta_rsv and sub_root_meta_rsv to track prealloc and
pertrans reservations for subvolumes when quotas are enabled. The
convert function does not properly increment pertrans after decrementing
prealloc, so the count is not accurate.

Note: we check that the fs is not read-only to mirror the logic in
qgroup_convert_meta, which checks that before adding to the pertrans rsv.

Fixes: 8287475a2055 ("btrfs: qgroup: Use root::qgroup_meta_rsv_* to record qgroup meta reserved space")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4114,6 +4114,8 @@ void btrfs_qgroup_convert_reserved_meta(
 				      BTRFS_QGROUP_RSV_META_PREALLOC);
 	trace_qgroup_meta_convert(root, num_bytes);
 	qgroup_convert_meta(fs_info, root->root_key.objectid, num_bytes);
+	if (!sb_rdonly(fs_info->sb))
+		add_root_meta_rsv(root, num_bytes, BTRFS_QGROUP_RSV_META_PERTRANS);
 }
 
 /*


