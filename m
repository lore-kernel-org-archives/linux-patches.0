Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0C51AF0CE;
	Tue, 15 Oct 2024 13:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998116; cv=none; b=Z0LbxabtGhhotwWoYEqKryMsme7zraVEgTuvQHnGdap6Jr8mT8Y16bjBu/7CY2FxiLLYfh1KeX5m1qMneDIX/lTeQpKhxmcJo7InINcRIX5BFRMH0PPNAg9DYGrvUglCNh03r0zOCZhihqS8o9Bk6nG/Yk4z4GJxy99d5RH9f30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998116; c=relaxed/simple;
	bh=t+8Zf0KY1UdZpaZqbW5pnKZxmXcK7epLgs/nCLD8gwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZahOmG9l8FwNHPpvAtjQvBwawHg9tZRh+jTB1UEQtR2GIk5Tjf+t6q2F+zuLX5xUrZanc3Pxq+PtIVgQj+8ssiUd1UsrtqQoPsgphzbyqpd+1piZpb9S2c3NPysAqc6nh3Q3sl/jm2rGi5+L2k4BjI/hhkdOyWSAwWnpvZJP2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1d2Z32g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1d2Z32g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCAFC4CEC6;
	Tue, 15 Oct 2024 13:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998115;
	bh=t+8Zf0KY1UdZpaZqbW5pnKZxmXcK7epLgs/nCLD8gwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1d2Z32g9k6x32fFsd4XIhUJdqqVPnJC3SBmuLwU7MKBJcfAYJOGhSP2seKHubXts
	 w72tY/F5hLGEmxLIoM1tRHMqR8pkIFbpsusAbRq9HRzP5keP0Q+MYx8rMlGPGgA/XV
	 8FIeqS/JT/Moqa2hQ5wOl9jA9kaRk9X4OClW6GE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 384/518] jbd2: correctly compare tids with tid_geq function in jbd2_fc_begin_commit
Date: Tue, 15 Oct 2024 14:44:48 +0200
Message-ID: <20241015123931.791564170@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit f0e3c14802515f60a47e6ef347ea59c2733402aa upstream.

Use tid_geq to compare tids to work over sequence number wraps.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20240801013815.2393869-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -740,7 +740,7 @@ int jbd2_fc_begin_commit(journal_t *jour
 		return -EINVAL;
 
 	write_lock(&journal->j_state_lock);
-	if (tid <= journal->j_commit_sequence) {
+	if (tid_geq(journal->j_commit_sequence, tid)) {
 		write_unlock(&journal->j_state_lock);
 		return -EALREADY;
 	}


