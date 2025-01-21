Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37971F7064;
	Tue, 21 Jan 2025 17:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482259; cv=none; b=qpYc67nOJ6TyrvaSRFNuQ0zDorj/YfsASRc2JTtoPlhYsFx5693cIw2gWh+41iDsJPzbbNYjDKtkhmnSXkMBGZYekkmXy7NGcYvGA7kmttXumB0wX4hbz3qrNxlwRRx0DPD+4A8Jh7I5depTSTV/FBfvg3At+Sh6zsoYgLnxVkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482259; c=relaxed/simple;
	bh=m6mxOopvVBiKthBFGRVBn008/6MMfOVZCZuhFmReANE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkQ5G7idDjHVCejvDIWPGrhAfuI9mK//ZNP6FWKoIz0skttgNWmwwXYVLwHWhJ8dYHHWq0vss+3331z0/2olGI8U1Mj/11Cfi6ZXWJGq5A4D8VzZ3RY3ZG7AdBUlyy8RQph4iT7M4Tcyh9nv7dBA/9DxKWvV2ROwKsTIJ9I507M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdugK7X/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdugK7X/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2A3C4CEDF;
	Tue, 21 Jan 2025 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482259;
	bh=m6mxOopvVBiKthBFGRVBn008/6MMfOVZCZuhFmReANE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdugK7X/7669F4ddshTMuJfT8rFdPGFOI4IOqbtIq3EvzVWUYaOGBAqNlGFeKK1GR
	 DIJu3o3AfdDa2eegSE4ix12lmdCSmZji0d1U/ek/pEzdcMdLn2K02n7u/1vByqRDew
	 A0rXtx02J5MhKUs1RDFYjEw7C/KAQJLuvOobKCiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/122] btrfs: add the missing error handling inside get_canonical_dev_path
Date: Tue, 21 Jan 2025 18:51:04 +0100
Message-ID: <20250121174533.630617563@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit fe4de594f7a2e9bc49407de60fbd20809fad4192 ]

Inside function get_canonical_dev_path(), we call d_path() to get the
final device path.

But d_path() can return error, and in that case the next strscpy() call
will trigger an invalid memory access.

Add back the missing error handling for d_path().

Reported-by: Boris Burkov <boris@bur.io>
Fixes: 7e06de7c83a7 ("btrfs: canonicalize the device path before adding it")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0c4d14c59ebec..395b8b880ce78 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -797,6 +797,10 @@ static int get_canonical_dev_path(const char *dev_path, char *canonical)
 	if (ret)
 		goto out;
 	resolved_path = d_path(&path, path_buf, PATH_MAX);
+	if (IS_ERR(resolved_path)) {
+		ret = PTR_ERR(resolved_path);
+		goto out;
+	}
 	ret = strscpy(canonical, resolved_path, PATH_MAX);
 out:
 	kfree(path_buf);
-- 
2.39.5



