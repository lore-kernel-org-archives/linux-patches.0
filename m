Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D2126A1AB;
	Fri, 10 Oct 2025 13:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102345; cv=none; b=oPsORRATEsMg/fjvuXkIRbRLNSdOHAPlSjb78yaYxkHwmnDsTTA7yVEVpWBwy1yV0soR2y6+B5uVbaX2nvV1d/7UoGmhSLE3xYf6otmLYpZl8wXBClqczAnTy3/c+g99oT8rzII6bc8gTwVeMoUFiWVtVAEkLpP4/MLJrtMheno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102345; c=relaxed/simple;
	bh=MMLit2jv84UBJ2z0hW39HADFFv2skvbnwy/uXJlf6nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBzYXhwT1r6HD/iyL9Hpvf4sXu4dg0dEeWmgn+V2I6LYWxq4NL/JGfNaEYMjjQAaEtdS+6nA73FpA39EdNfNR9+ZL5B/ul90GRclNW/wkrTsrBeehppoBdXgluYYufCNAohm2A+eFr9pnQIfqsIJk34x2KnpBpoBtcODiJyfbbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRjNDmSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRjNDmSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5424AC4CEF1;
	Fri, 10 Oct 2025 13:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102344;
	bh=MMLit2jv84UBJ2z0hW39HADFFv2skvbnwy/uXJlf6nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRjNDmSLP2jdH6egMsA3KJ9MUwUMFHFXkHZS1qdHpfWhmdBIw0j0B2ZzpiwaP6m9b
	 CV0xrqvx9mKlO3DZoz8g3oadqFcOO2P7nowEs8DJN2gffBBa1m61h7iaGPrkKug3DZ
	 bchGaNmLx1nOqMvhN5B0t965xxYIniBXp9dNTZW0=
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
Subject: [PATCH 6.16 23/41] netfs: Prevent duplicate unlocking
Date: Fri, 10 Oct 2025 15:16:11 +0200
Message-ID: <20251010131334.259366344@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f27ea5099a681..09394ac2c180d 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -347,7 +347,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		folio_put(folio);
 		ret = filemap_write_and_wait_range(mapping, fpos, fpos + flen - 1);
 		if (ret < 0)
-			goto error_folio_unlock;
+			goto out;
 		continue;
 
 	copied:
-- 
2.51.0



