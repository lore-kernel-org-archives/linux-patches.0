Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD51262FE7;
	Wed, 25 Feb 2026 01:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983675; cv=none; b=NXLCHFmN9bkyX8t2pM7tO0F3K2FkIYyFd/L5STjDWFJtdbwjsfZQXKgNHgvKnprupRS27y6VCD1wnzZ2TWAStX4+Wjwn2aewNEET2mIypB+TOyVXS8iOgYiPO/SqMJUk8NWgYtOef6kMUL/NYzAPESJTQJsxl28dG0pYEkbpK64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983675; c=relaxed/simple;
	bh=qbx13s0+pOfcOcTGei8G2slsq5gEXk2zqOEMr+NDjDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jH/V36Ft56cBrNTbxrT2OXhc272q7i5jgdeB6dhja1aPCm9uccmwKP7NRpNtgvPp+NeBEFyvZLFFYP2xAS1nzNOyBwCfBmmGO6b2WcJSN1XZbZ5cPVuPM7irhhBeyibc7LkB2tTvlH10YR0NrFllJ0s6QlEbuONQ/np0gI5ObxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIY9bFpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIY9bFpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6450C116D0;
	Wed, 25 Feb 2026 01:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983674;
	bh=qbx13s0+pOfcOcTGei8G2slsq5gEXk2zqOEMr+NDjDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIY9bFpnoXUXVCj4j+zdlPV+EAHDs0zmeYiO6HvCdMhGQSleagSJwXCFNyMncIfk6
	 xZHIR462k4ljuROgWgPRypfEVkNB1c5diMvUIQgLz7223EJkw4cnxDKPoaZw+ffQYW
	 +XGsmvnwC8IxXv3qiudffKX5o6/qdBfhHzHFDmVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.19 760/781] ext4: fix memory leak in ext4_ext_shift_extents()
Date: Tue, 24 Feb 2026 17:24:29 -0800
Message-ID: <20260225012418.359482490@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

commit ca81109d4a8f192dc1cbad4a1ee25246363c2833 upstream.

In ext4_ext_shift_extents(), if the extent is NULL in the while loop, the
function returns immediately without releasing the path obtained via
ext4_find_extent(), leading to a memory leak.

Fix this by jumping to the out label to ensure the path is properly
released.

Fixes: a18ed359bdddc ("ext4: always check ext4_ext_find_extent result")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20251225084800.905701-1-zilin@seu.edu.cn
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5414,7 +5414,8 @@ again:
 		if (!extent) {
 			EXT4_ERROR_INODE(inode, "unexpected hole at %lu",
 					 (unsigned long) *iterator);
-			return -EFSCORRUPTED;
+			ret = -EFSCORRUPTED;
+			goto out;
 		}
 		if (SHIFT == SHIFT_LEFT && *iterator >
 		    le32_to_cpu(extent->ee_block)) {


