Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E989376C9C;
	Tue, 20 Feb 2024 21:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463380; cv=none; b=kDQ7V7XH0NCMkn/j0xtcFN3k+Y/5EOIX4EHrqdYz3AoLe8NqHK9ORUnK1Q8vlsNcdVam4OeI45sCE0VcDMBEC1VvRL3Gbpr+aauIxcnoZSnvDqNtFHrOyv9L9N6P34JTEF+cS6SLEW+aGD2g2uOs1MlHeqPsnQ/mnFWfr3cHn6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463380; c=relaxed/simple;
	bh=FjrT7aoEVHYY1+h+WLUcXuf8vGecz1LIwb8PrSCLDg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBYvMuzKJGm0rC3nHb7TGgC3TJ0KFOhjoyzAG/tIvnYFP183Z29lTFJ+TnXfFQjwWTDPTCzzQxCtD2cZWcmIWdRspBkWLiuHcZfBTMu1xD5Blukf0IEgcCptgfH0dXPxCWlQ0ZDlFDeuQQeqHXqY9N7xBc1ICeMWnfT5rJG72B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6JSG4L/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6JSG4L/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5834BC433C7;
	Tue, 20 Feb 2024 21:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463379;
	bh=FjrT7aoEVHYY1+h+WLUcXuf8vGecz1LIwb8PrSCLDg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6JSG4L/IfLpXnYLM4BJ6IoffgJvIf1tZ5Rjx2vu3cEug2utDYKn9U29IK1S2J3cC
	 yYH1rT4EZQqBaGfXdrPzSdCxLr93cMOGYsCPAOnNdo0vPHI0Vw2/GGw7byBgbGtnDd
	 ExMtFb2Kq6X/HyXn+rBdg6723jwR00cOACNYSJZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 007/331] btrfs: forbid deleting live subvol qgroup
Date: Tue, 20 Feb 2024 21:52:03 +0100
Message-ID: <20240220205637.810203500@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit a8df35619948bd8363d330c20a90c9a7fbff28c0 upstream.

If a subvolume still exists, forbid deleting its qgroup 0/subvolid.
This behavior generally leads to incorrect behavior in squotas and
doesn't have a legitimate purpose.

Fixes: cecbb533b5fc ("btrfs: record simple quota deltas in delayed refs")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1659,6 +1659,15 @@ out:
 	return ret;
 }
 
+static bool qgroup_has_usage(struct btrfs_qgroup *qgroup)
+{
+	return (qgroup->rfer > 0 || qgroup->rfer_cmpr > 0 ||
+		qgroup->excl > 0 || qgroup->excl_cmpr > 0 ||
+		qgroup->rsv.values[BTRFS_QGROUP_RSV_DATA] > 0 ||
+		qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC] > 0 ||
+		qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS] > 0);
+}
+
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
@@ -1678,6 +1687,11 @@ int btrfs_remove_qgroup(struct btrfs_tra
 		goto out;
 	}
 
+	if (is_fstree(qgroupid) && qgroup_has_usage(qgroup)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	/* Check if there are no children of this qgroup */
 	if (!list_empty(&qgroup->members)) {
 		ret = -EBUSY;


