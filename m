Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CBA143C52;
	Thu, 13 Jun 2024 11:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279569; cv=none; b=HXrxwbabgq4knIiVb0Erbhitkfsgc9JacQjBZou9z8Am1VD+6rtlOoJoEDQ/mI8vH22Uqq05syJ1fU3kgDC17Fk4Tm41X8zKJX3gymJPZYWZ7Bub0pCWX0J1fLf7tOwmf/5VDwfMAvjydlv9fhPREcpYTTc9Ucnp2TF8zZzUznQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279569; c=relaxed/simple;
	bh=MUC8cm+6BzVkHjj62zgf8NDR/6w0hQx5JTuoru9ocaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtBCRFANKm3bbP9AxvYM4ltaYAwuHeZf7wt4Rz0Au0mJp8cA05DFjTm9XnpJwl+1kJ4AXr4dj9iKICwr5Tc7Cuc4gbMgNDx+O5LbMpo3wzFIvI6+kv/FMuVTJ/MSnzrcgA9SIXUX7LH4wUTDf1KX3DSY88FR+OSdEkZOaMSGaBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SrEfDTDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrEfDTDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA9BC2BBFC;
	Thu, 13 Jun 2024 11:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279569;
	bh=MUC8cm+6BzVkHjj62zgf8NDR/6w0hQx5JTuoru9ocaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrEfDTDCviY+JMdlIWcDeji5PwF70HMHHZqLw5aA5ERIlLAMWkWpKNpAuGADM1Ptf
	 k3JQIzvJyF1jNTko//x29HDoYqNPog1lqfWJBq2deIsKm1qxJLSqZXgKV7O9SYvDyq
	 yZE/btJWKpuvavu4Rqx3KghZYhgGV5fzt262XkPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.9 119/157] ext4: set type of ac_groups_linear_remaining to __u32 to avoid overflow
Date: Thu, 13 Jun 2024 13:34:04 +0200
Message-ID: <20240613113232.019150936@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit 9a9f3a9842927e4af7ca10c19c94dad83bebd713 upstream.

Now ac_groups_linear_remaining is of type __u16 and s_mb_max_linear_groups
is of type unsigned int, so an overflow occurs when setting a value above
65535 through the mb_max_linear_groups sysfs interface. Therefore, the
type of ac_groups_linear_remaining is set to __u32 to avoid overflow.

Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
CC: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240319113325.3110393-8-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -193,8 +193,8 @@ struct ext4_allocation_context {
 	ext4_grpblk_t	ac_orig_goal_len;
 
 	__u32 ac_flags;		/* allocation hints */
+	__u32 ac_groups_linear_remaining;
 	__u16 ac_groups_scanned;
-	__u16 ac_groups_linear_remaining;
 	__u16 ac_found;
 	__u16 ac_cX_found[EXT4_MB_NUM_CRS];
 	__u16 ac_tail;


