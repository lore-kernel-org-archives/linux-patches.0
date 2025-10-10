Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8927D2EF652;
	Fri, 10 Oct 2025 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102439; cv=none; b=ksSMdyGKB6ZClWXM9AoIVGJwE/8l1zfZZQ0DmS5QrWcVOHX/KTi0IvGJOnp1Kc53Twq2v90ACpAn7A5HJJdI7bRYNiBDJ8BhxfQf/hwleXNHGqm9zPtVaYdEl4tOoP38MboniMTZwvV16bwzEU/gLrQmkC/L/VQnQ31nbHWJqnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102439; c=relaxed/simple;
	bh=Q2gldWnIfpT3zwrKIkV7zazRE1ZMAO2C8FDwK1GkcbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg/imT2+QMhNVljtxSghshhJZU8h3Fd6oCCW8TTtlCEbg+AVypGpu96cxMrjmZzz6F4rMm91/pj0YzUZSWoPdccmNS+ikNGS9AEhNmzpFaORt9blVHXY8i8OcRvEusLaHY/erDgr/c+UNjWDfX49VNPHobIlkDXZAfSoIgKaoBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8v8o55z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8v8o55z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F984C4CEF1;
	Fri, 10 Oct 2025 13:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102439;
	bh=Q2gldWnIfpT3zwrKIkV7zazRE1ZMAO2C8FDwK1GkcbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8v8o55z8JhuC/lznMb5p1hy62+hiA+Vi3lAR1EeZXI3oIM3xWeoxQSUt6RepE0V2
	 5g1Inuz4R+HHmB8rHVb5imUD6wTbAxK9vLal2auB/aMNt2/CpVDIPXex3GKS28icM1
	 Uh1P9MEF3G7WBlv8yzMHrj2eESa33M/xsHDR3k1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b73c7d94a151e2ee1e9b@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 15/35] netfs: Prevent duplicate unlocking
Date: Fri, 10 Oct 2025 15:16:17 +0200
Message-ID: <20251010131332.344686815@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 66d938e89e940e512f4c3deac938ecef399c13f9 ]

The filio lock has been released here, so there is no need to jump to
error_folio_unlock to release it again.

Reported-by: syzbot+b73c7d94a151e2ee1e9b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b73c7d94a151e2ee1e9b
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Acked-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 896d1d4219ed9..be77a137cc871 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -340,7 +340,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		folio_put(folio);
 		ret = filemap_write_and_wait_range(mapping, fpos, fpos + flen - 1);
 		if (ret < 0)
-			goto error_folio_unlock;
+			goto out;
 		continue;
 
 	copied:
-- 
2.51.0



