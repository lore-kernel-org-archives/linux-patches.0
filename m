Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FAF1DF72E;
	Mon, 12 May 2025 17:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072633; cv=none; b=g1D8ZXTP8Rd/5JkiUEYt8YXh5mzLL/RlI/n8hgDs2dZJmmeUorbk9rK8efhM9esiEA/dZObOTxPCxlAUWITVWZ/XboAlnubJClNS75sJygdGb2vSDua/VKf8/MF3Du/OIjqjzwy6a1fJU6n1axajc+rlXGvOwJG8PuDPvHZw7d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072633; c=relaxed/simple;
	bh=3S1Z6HYuVDQH+xYJ8kEafNL/Xvyhu9cyTghCogMGisE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZdlVpxS75eRlTpY9icSAwXjyBJeOL26AQWPHREkax1sbee091J1ww5RqnCVxbWcipLqmgqVrEpRyQmROz48xMGlieOU7zDn+z9gANzu7/Wbv6tfEbGqc+7lqaJixueUAuo+bbJRt7BChoagd4Jl7Kct9dXawY00yA5j10jzkjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGG3blQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGG3blQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79072C4CEE7;
	Mon, 12 May 2025 17:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072632;
	bh=3S1Z6HYuVDQH+xYJ8kEafNL/Xvyhu9cyTghCogMGisE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGG3blQiLH8GSqFm08jN+xWjwxJr9EvsQL8v3Cj1obMmP5FY2HEUQfnytHxDTlPWk
	 gJlpSQ+b+IeBv7WVnIo5M+macLv4Y7RipueDQNwJAJyVNTGkCSSFCGYmt/jHAVXANY
	 CDl3P4xAUfZgctoRSuE5PzSlhTFj0j3Jsp++4dJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 001/184] dm: add missing unlock on in dm_keyslot_evict()
Date: Mon, 12 May 2025 19:43:22 +0200
Message-ID: <20250512172041.697293502@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 650266ac4c7230c89bcd1307acf5c9c92cfa85e2 upstream.

We need to call dm_put_live_table() even if dm_get_live_table() returns
NULL.

Fixes: 9355a9eb21a5 ("dm: support key eviction from keyslot managers of underlying devices")
Cc: stable@vger.kernel.org	# v5.12+
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1183,7 +1183,7 @@ static int dm_keyslot_evict(struct blk_c
 
 	t = dm_get_live_table(md, &srcu_idx);
 	if (!t)
-		return 0;
+		goto put_live_table;
 
 	for (unsigned int i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
@@ -1194,6 +1194,7 @@ static int dm_keyslot_evict(struct blk_c
 					  (void *)key);
 	}
 
+put_live_table:
 	dm_put_live_table(md, srcu_idx);
 	return 0;
 }


