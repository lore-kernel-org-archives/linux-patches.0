Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933EE1D5141;
	Wed, 25 Feb 2026 01:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983733; cv=none; b=Wifai/99D6LkBTmBpkrmWvHfbASG5TyuN4SuhPa+XHhs7Qsu3J/KVhWtl8dxkLSPKfJ2YkcMbO/w0YpgPeCxvKcn1YcteVipe5dpIcZgq6/VP2caKlAVaJKw7pm+BktbR+QOl6XjdnTga2a6nIKemcuvAgJ/5ZserHnN8eaAVoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983733; c=relaxed/simple;
	bh=RETED7amnF99+qlcIlPtk60rjzIg/yA2j3wZipVnNiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsqDlX/IEQm/Cvx4YfrL265IpWVtjxvzARB0xCXQUWS1StKwBcU8iYoVGjUgiSLlCjQDWhno8xjlWHUrb1+ufU7JyFwvEdS2oRRsMtUAkcS4N9Oj+xbIukeWj64zf7jAdDxceKQXejmfF3jg7m+n/rJwedLpic1hEGjhsA8OiQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHRYZvoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHRYZvoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BEFC19423;
	Wed, 25 Feb 2026 01:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983733;
	bh=RETED7amnF99+qlcIlPtk60rjzIg/yA2j3wZipVnNiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHRYZvoDFye+2LBg6A8CJ9UdpPZ4AX3+cn5uA7Kh2uG3YX1kw0VSGLWdJBe1Xq76n
	 JQXWlJNsIDxXrDNV46P+xgOiCivIlog5x9+granvm1/4vT1VPEJZ0Vrox2B9P1K5f0
	 uR3GA7beU5H6pwHGrCKQ68nite9vlj8hL3FCSXfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/641] btrfs: qgroup: return correct error when deleting qgroup relation item
Date: Tue, 24 Feb 2026 17:15:54 -0800
Message-ID: <20260225012349.666768799@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 51b1fcf71c88c3c89e7dcf07869c5de837b1f428 ]

If we fail to delete the second qgroup relation item, we end up returning
success or -ENOENT in case the first item does not exist, instead of
returning the error from the second item deletion.

Fixes: 73798c465b66 ("btrfs: qgroup: Try our best to delete qgroup relations")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index febc22d1b6487..7a1dd250e92c0 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1627,8 +1627,10 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	if (ret < 0 && ret != -ENOENT)
 		goto out;
 	ret2 = del_qgroup_relation_item(trans, dst, src);
-	if (ret2 < 0 && ret2 != -ENOENT)
+	if (ret2 < 0 && ret2 != -ENOENT) {
+		ret = ret2;
 		goto out;
+	}
 
 	/* At least one deletion succeeded, return 0 */
 	if (!ret || !ret2)
-- 
2.51.0



