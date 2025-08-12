Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA62E257435;
	Tue, 12 Aug 2025 17:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020810; cv=none; b=MJVUyo0nCT1oE2du5/NcJ+EWcrAvJpqUO9sOwk3xpFYVkRHoNjczyigOEevTQucGVwvsopJhWVLnECynqryoH84os/VRXLLrfdjEgwIjSrjxENO1TR7LcL0A4T4/F9e0wef6f7cuzCtvi1ZOdjW7uMHWYRW0qXCMfsk1pzPtaog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020810; c=relaxed/simple;
	bh=+/cWHX5hCSqHoxEfr2LFlftZgaGdhiya+f4sOMhQjUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfmD5Dd+LO6i1XHn64QoAwjClIYy6H2JS4BJbyMzUnryRaT42gGL8qCaRfP0W1lMUYWonsF9/vSp09cjmvxUFp5OFWbuRCWHr/T2P4Nauv/dslhEza5OgdadSOKQjmcl0iC2u2PaEvYPUW01RLP4waWt6Ir7epd2Q6yAz1Ha1Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/GP56lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/GP56lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E17C4CEF1;
	Tue, 12 Aug 2025 17:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020810;
	bh=+/cWHX5hCSqHoxEfr2LFlftZgaGdhiya+f4sOMhQjUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/GP56lcZeiEAUs42p/CmKvyBYRlh/B1W70YPC8fTrNcAU1pdc82C2eDodTCGvJ7Z
	 Wx3Fm6xgY/XveqNLSe1y9kgMcGm7FtfiakhwA2LuLLwH5sRatLYohsTGRV8fqQZbCK
	 67EgjCES2HMFh534cw6cXAOqU4kN276xr1YegH3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/262] hfsplus: make splice write available again
Date: Tue, 12 Aug 2025 19:26:38 +0200
Message-ID: <20250812172953.417839513@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 2eafb669da0bf71fac0838bff13594970674e2b4 ]

Since 5.10, splice() or sendfile() return EINVAL. This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write
without explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250529140033.2296791-1-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index c65c8c4b03dd..73ff191ff2ad 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -373,6 +373,7 @@ static const struct file_operations hfsplus_file_operations = {
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= filemap_splice_read,
+	.splice_write	= iter_file_splice_write,
 	.fsync		= hfsplus_file_fsync,
 	.open		= hfsplus_file_open,
 	.release	= hfsplus_file_release,
-- 
2.39.5



