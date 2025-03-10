Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FAE230BF6;
	Mon, 10 Mar 2025 17:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626917; cv=none; b=M0o5OD4tOk0tKSYiqrF5t9tk/gpThMSh2YVd2th1hTiA4Web/W2ufVN0tZv/V4BBLwl0rNNLTdh2DX4mPsAXtyMRce/8mFpFRlLVbrBI2Cnw6xydtcHC83N6d3jGiZLvRl+QY8swdGvgcBokrYiIpv7VvxmU5AebVmdy7XrwVPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626917; c=relaxed/simple;
	bh=WjAFfnTh5Oc7BQOzM2HBQN3XS+TahWRACsRnzoS51n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFCUH5J1R1U3uMWpxQi4+9jY0A8AXTiszdhUbhgBGInh7DtbD8NWCt3pa0eDt9rAbxZN6kqWzUu98TL9kDDmvbPJbeul6Svgen0UJXQT7tluobLglkCNZde19Z6fDxhyPZvxpzj6NU5KeJId1cxYypQ2he+W1ZA/vNFg2liJ0tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaIzdtCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaIzdtCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA47C4CEEB;
	Mon, 10 Mar 2025 17:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626917;
	bh=WjAFfnTh5Oc7BQOzM2HBQN3XS+TahWRACsRnzoS51n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaIzdtCcN8cSn+KFKS7LFTlLYH3maQUAlrwzJeFcXzlhsSKs27bOjxT8O1kxyaw0R
	 UZzGcXjOgYLqNncVbVYdp2P3aDmH/cwLZvgmIKrauE5HEBMMutZhfYbvbPtQpWDPrW
	 OKsdgWRmSaqayOLeJD46xOqU5G3pRtDzSTQSFOuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noah <kernel-org-10@maxgrass.eu>,
	Eric Sandeen <sandeen@redhat.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 140/207] exfat: short-circuit zero-byte writes in exfat_file_write_iter
Date: Mon, 10 Mar 2025 18:05:33 +0100
Message-ID: <20250310170453.367645683@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit fda94a9919fd632033979ad7765a99ae3cab9289 ]

When generic_write_checks() returns zero, it means that
iov_iter_count() is zero, and there is no work to do.

Simply return success like all other filesystems do, rather than
proceeding down the write path, which today yields an -EFAULT in
generic_perform_write() via the
(fault_in_iov_iter_readable(i, bytes) == bytes) check when bytes
== 0.

Fixes: 11a347fb6cef ("exfat: change to get file size from DataLength")
Reported-by: Noah <kernel-org-10@maxgrass.eu>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 05b51e7217838..807349d8ea050 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -587,7 +587,7 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	valid_size = ei->valid_size;
 
 	ret = generic_write_checks(iocb, iter);
-	if (ret < 0)
+	if (ret <= 0)
 		goto unlock;
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
-- 
2.39.5



