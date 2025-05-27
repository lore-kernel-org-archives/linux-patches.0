Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2731D88D7;
	Tue, 27 May 2025 17:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366659; cv=none; b=Z7Z+9nIQfqMYJJTW5I+hAH8NZ8986oNggJOZtG/Xy/Pd9Uco5YhR93jKeSlZgILYcyHiAbidC77be7pWHqxgZm/Z6/FUn1Xn190Hib9GJTnmsiLvJqoussNWruM4Ztc8uT0OuZ48ozPgug+dXZLNYlCO3tTTY+y3HL5Q/hTX+u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366659; c=relaxed/simple;
	bh=UhbcUg91SUykKszLDng0YirMaKQm+ZjQwZRVbfYOoEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEfiN5iu9vzNwBAfVG0HlWsIdD1Et7n/1HppoYdYP6Cvmy8chRf98evShMUqKhnQ4bC8JvIAYSr9VWe4JLmcwXgrBYaB6v9KqqrM/IuAOdcJW7dtWVGqHlA2UWe4BTql/iny+2qk9CeYjqXygygmHOyCbJjn+vNXlXqRpA9J49s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joIFQ8BS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joIFQ8BS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F744C4CEE9;
	Tue, 27 May 2025 17:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366658;
	bh=UhbcUg91SUykKszLDng0YirMaKQm+ZjQwZRVbfYOoEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joIFQ8BSVl7V+C3FxgjR2Kl3gPWLgWEiPolGVL9NQ4XCuO1doaK8aHi0VAygmtC0c
	 DoqZUHq0xKPa6pHOIQt5TQVYDq7aLD+KEujOBPqD71yDAgmxXf6Yr2NMrAmTh81KL3
	 gXbe32Y+q59jfh1DQwQd6e9KXkbcpxSGihPNw740=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 139/783] btrfs: send: return -ENAMETOOLONG when attempting a path that is too long
Date: Tue, 27 May 2025 18:18:56 +0200
Message-ID: <20250527162518.820309278@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a77749b3e21813566cea050bbb3414ae74562eba ]

When attempting to build a too long path we are currently returning
-ENOMEM, which is very odd and misleading. So update fs_path_ensure_buf()
to return -ENAMETOOLONG instead. Also, while at it, move the WARN_ON()
into the if statement's expression, as it makes it clear what is being
tested and also has the effect of adding 'unlikely' to the statement,
which allows the compiler to generate better code as this condition is
never expected to happen.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f437138fefbc5..bb8a0945b0fd3 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -487,10 +487,8 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	if (p->buf_len >= len)
 		return 0;
 
-	if (len > PATH_MAX) {
-		WARN_ON(1);
-		return -ENOMEM;
-	}
+	if (WARN_ON(len > PATH_MAX))
+		return -ENAMETOOLONG;
 
 	path_len = p->end - p->start;
 	old_buf_len = p->buf_len;
-- 
2.39.5



