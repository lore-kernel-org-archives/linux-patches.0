Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8100256458;
	Thu, 13 Jun 2024 11:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279251; cv=none; b=il408MvjZr3nJcUZO2qzi+dan0prUnlH8dW9VlHbY3F69oYNcueAdEHc7ikKo+WVEtbavIULcE39aN83UVA3Q1ifAI4Er/16Ix5d4M+WMshAGePj2OvIUcvL5zCHQnoCosJRs5WjXWfwF9cCL/KxyTzXe0uArZO5uYeDAd+/tp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279251; c=relaxed/simple;
	bh=8wxlCXn8rDlGonzQ1DJzMQbj1zDhFtVgEgJ6diULvH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oi0yOGaCDlSpDTTbTCPaD2q3tR4OFQ/2mWpy94QIc08NTrglddMC8hlsS8r3GbNIWDnYiB95UZANhVjxFERAnoHcA6RVv6PS8zKmzBoQbAqOs0UZcWy61l6wCbnqAB18cS3JTa6wzLPZrQAcQC1+lajpHrtRhulmK6OJiRcqVxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WtEFheX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WtEFheX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06374C2BBFC;
	Thu, 13 Jun 2024 11:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279251;
	bh=8wxlCXn8rDlGonzQ1DJzMQbj1zDhFtVgEgJ6diULvH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WtEFheXI7FOGWVWoSIShwNtU1CGlfsre2HneKYcsyW1VJfn7Fp0+jb0X8vC4Uyow
	 NiNSx4QmY6zKhDPtYw3OmUOIezioZIlMd1FL5lvSnsk4jC5lp5nqUfPY2oXSWH5pP+
	 3w5BUiOhGcoVlqtc8uwLw+W9LTqNSYE3WZoIV0Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.9 013/157] btrfs: qgroup: fix initialization of auto inherit array
Date: Thu, 13 Jun 2024 13:32:18 +0200
Message-ID: <20240613113227.919719616@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 0e39c9e524479b85c1b83134df0cfc6e3cb5353a upstream.

The "i++" was accidentally left out so it just sets qgids[0] over and
over.

This can lead to unexpected problems, as the groups[1:] would be all 0,
leading to later find_qgroup_rb() unable to find a qgroup and cause
snapshot creation failure.

Fixes: 5343cd9364ea ("btrfs: qgroup: simple quota auto hierarchy for nested subvolumes")
CC: stable@vger.kernel.org # 6.7+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3129,7 +3129,7 @@ static int qgroup_auto_inherit(struct bt
 	qgids = res->qgroups;
 
 	list_for_each_entry(qg_list, &inode_qg->groups, next_group)
-		qgids[i] = qg_list->group->qgroupid;
+		qgids[i++] = qg_list->group->qgroupid;
 
 	*inherit = res;
 	return 0;


