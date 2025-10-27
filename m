Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292182C15BB;
	Mon, 27 Oct 2025 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592323; cv=none; b=AQHfUk4Ye55R3WvjatVWLdt5sXnhhmdPFUcuqrWfXBsXXbu6M781ho5jmfauk5SWaZOa1ch8uPPfnW3MTMqP+Y9g1G7/qtp/v14c/4yAFzgp0h3fY2F/EZHSzMVz5yb7QGoR9cFBY5Ikq21FnPdzGt0GR2eqMg2fFs9Tb/LlxP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592323; c=relaxed/simple;
	bh=WH5BgjoVWV/XrYuk4LcKg0bPiXcv4h00alWx8qPLCZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZG/AMPuGHMBddaceXzbnChhhf0nss9rKGKzGlWKGh+/T/0tzU1aL4Y43vZqvTFilHk1djiXVX8ZDbSrXUIBnn+qkKAW91oFDhNST1GBVlSjDbcIGTo+owo5Lk/ttcXRQIMeIB83pXmKX9u6a61Fi+sFqkP53OYgOhIcOVewU7hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EF/yTbXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EF/yTbXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D69C4CEF1;
	Mon, 27 Oct 2025 19:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592323;
	bh=WH5BgjoVWV/XrYuk4LcKg0bPiXcv4h00alWx8qPLCZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EF/yTbXwXbJ/wojVqVTfUHyB3hVxADk0vljyiv0ssX9yowLcrWCCOoQE8o5VTKedC
	 URRw8yIynP+M6aCGSk2innuJzTVErl/sYuxsWC9bf35XiLbRHXSD+8VrmQyFcmfxVl
	 p4mnu1CISaQZOqIKCvakO38QuWHEAOjcYT0bqCqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/157] hfsplus: return EIO when type of hidden directory mismatch in hfsplus_fill_super()
Date: Mon, 27 Oct 2025 19:35:37 +0100
Message-ID: <20251027183503.317624411@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 9282bc905f0949fab8cf86c0f620ca988761254c ]

If Catalog File contains corrupted record for the case of
hidden directory's type, regard it as I/O error instead of
Invalid argument.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250805165905.3390154-1-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 8c086f16dd589..7e889820a63d0 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -538,7 +538,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 	if (!hfs_brec_read(&fd, &entry, sizeof(entry))) {
 		hfs_find_exit(&fd);
 		if (entry.type != cpu_to_be16(HFSPLUS_FOLDER)) {
-			err = -EINVAL;
+			err = -EIO;
 			goto out_put_root;
 		}
 		inode = hfsplus_iget(sb, be32_to_cpu(entry.folder.id));
-- 
2.51.0



