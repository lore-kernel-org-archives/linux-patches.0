Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031492;
	b=3qv6+Pyon2GXyZ//zSPqlFK6LrksRwn022hUUkBBrk9KUFW/61XSRiMCQ7Tg7/q1JmQ0
	 FXnCIr67ed6lm3UT1zm5I9l1fmtPmXek27nZz8g0W8Q8AULLbXa13bFnsl/il2K8XtKN9
	 vcXau5j36LSuoQyPEDKcxExDpDXtOe1maaCSPy7XJSMcwymzPUxrQ/3nHC+epGDUC9YYb
	 wJWZMb2bfyYS2ERv02wDNM77zepoXFULyylMdyBsBdt8Fw9R4y2G5KnS4qNj3Gq7XmvWf
	 iXoUZloZUuKK+SjbN4WkFchnT43BAGQQKN4ykjNk+rZA9MqLOotSI1hbqvdq1eS/H+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fFg1FZat884eXgF7ZneSMXkBDa22GhrXErtxvxNdGjs=;
	b=Z/CtCQzEHQwyW9gyMfpLrRYN9PbBZT0SNaqvZKkxrCeMeESQjheg9tA9e5y24cX28F+h
	 Nq7zH9jZwjZjMwqSear5KN6NJS6eX3MN0LWIJCvX2CFjdd6m/WPVLSRMZeYMAaZ7KGwh1
	 ibjaj+bCI9Uq3zc6hE+v9EaUBMPsIYnftF5KpRtF6abPau1dbnBL8pPnT3RPGSdoV/z+N
	 /0t1/vybYIOUvwJ2UDgLKgxQbSS9rIMIrfhHkQCkJXPV75u4y+co4b3eu3F4Zga4/zn+6
	 IswOToa4gbB+knPRq6pDahx+IHIZ4IPB+CG+hACcAoj/98EHSHgXVQ0poXZDr60zHDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1ev9uYl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F566606A31C;
	Wed, 18 Nov 2026 19:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1ev9uYl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6257F1F000C4;
	Wed, 18 Nov 2026 19:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031491;
	bh=fFg1FZat884eXgF7ZneSMXkBDa22GhrXErtxvxNdGjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1ev9uYlrT6/FJUMSQjt9hHbvx3A4tCKbuLFED3/pRJrNRv9Qh3NWQegtaUQ3DBvy
	 htNprVlWkz/5tXdjdxgHXTI8T0VUjSwt/8oemxCmdFB0/K63G+46hL3aP85trlT3xn
	 Y2mSAx6DKTHskCt/8ZXJmL+0voDU4uOk6blIqDM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1078/1756] btrfs: fix lost error return value in btrfs_alloc_logged_file_extent()
Date: Wed, 18 Nov 2026 15:53:25 +0100
Message-ID: <20261118150053.142258368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 784cd5a83476c6c720521f21350fb823928555ff ]

If we fail to allocate a reserved file extent we then call
btrfs_record_squota_delta() and assign its return value to 'ret',
discarding the error from the failed allocation attempt and allowing
log replay to proceed as if no errors happened, resulting in some
replayed file extent item to point to an unallocated extent. At the
moment btrfs_record_squota_delta() always returns 0 (success).

Fixes: cecbb533b5fc ("btrfs: record simple quota deltas in delayed refs")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a821ea34674f3..1497a99fc725c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5010,7 +5010,8 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 					 offset, ins, 1, root_objectid);
 	if (ret)
 		btrfs_pin_extent(trans, ins->objectid, ins->offset);
-	ret = btrfs_record_squota_delta(fs_info, &delta);
+	else
+		ret = btrfs_record_squota_delta(fs_info, &delta);
 	btrfs_put_block_group(block_group);
 	return ret;
 }
-- 
2.53.0



