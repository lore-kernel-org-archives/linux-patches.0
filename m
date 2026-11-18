Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026238;
	b=07nSdep/rqLYNhBdZDg4wkX4rBplKUtQENe7pVrQbtTvb+8e+BsXVaCxSxZx6hU4PjXT
	 g5wYCt9nCn/bcC30V4uTWGnlyeeaR+YSGJN6LCPSIptnwEh9oRgxy0p6njbkcKWjFypgv
	 xgi2FW62m95nrDHmEPcWADjHC0ClI04sSmotLOxKhVNvzuLjnXQGxMrHwjf03eW2qWCXi
	 94FPXwu1WwsKx+XcdoePMAeyyIlG8/MIHacgpq1n83PBiYqmPdJOSGbXyvtSKYpXwSiah
	 4c3RzX7NIbsGA/ibRPKjq6lxjDNwrgD3iXIY2MuuKv/t9gQZl2FB1ge2ymsNyrShHBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gh00yKomDKOZdqQQTm/+bPFQqtZrBQjEXzCo4q7IjCs=;
	b=wytR8sCP2J7ybO8Yi19urn0Jr2iWUNwn176KM6g2MtknAe37qJ0DAMJU6PZfbLe716QE
	 NtN+ULG24SzAoy6zf9mVZhVCp48tMO4c+y9Np+HoAke0vWMv2beBgehG82LgS/yHvvMcc
	 0+e9Du0m6NsOhxS2BLiQdBlYLNvMV9pwl2qr0kqjRGJipLmWKiXcZfDEr/B8eaj+MPx8y
	 6k7+cjAErEL/aZ/AM1i91ITyb5qG7xr2z9uLtY9kQ71CUmydwOTlmlgz0dE1m796c+H2o
	 aw7A3O1VjYpd3YTuAnrO3YrpiXnXe5d357FFKrileNdEwqEpI/a7xxra0yzffLr36qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CnYnlGc6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C65606A335;
	Wed, 18 Nov 2026 18:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CnYnlGc6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50DB1F000C7;
	Wed, 18 Nov 2026 18:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026238;
	bh=gh00yKomDKOZdqQQTm/+bPFQqtZrBQjEXzCo4q7IjCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnYnlGc6ZAIbyAFwzv1neokHv8HqssOB69WV3690F6uugJc0QrpbUsP+/rpJKbtK2
	 O/VzetOx1lplmx3sHNai+JVqrxsDb4411y+arqvSSnJefSo6568CJUn1EEDeezaWgt
	 cT3vo8EYFZ7++c17FWmasUl7BJVbKu6z1xlwOcNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1363/2151] btrfs: fix lost error return value in btrfs_alloc_logged_file_extent()
Date: Wed, 18 Nov 2026 15:51:38 +0100
Message-ID: <20261118150211.679697472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 95bff1616f4a8..2f207bca62720 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5011,7 +5011,8 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
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



