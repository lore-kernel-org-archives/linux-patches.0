Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA7D27453;
	Tue, 29 Apr 2025 17:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946807; cv=none; b=caUmjuw/WAlpSvmoVF+/IFq0S7dRlECS7b2/Oi20yS6izEon3I6hZPPQrd8D1C58zCbq3BtLoLz+Y+5X0P1me9v4O9Yu5b8DaKBpLIVJDDtn8eiN1sVEcIZoRByKHgUlRRxLQTW+i13Ep0Igsv46zJTnSVQacFIxvHDzT1eu2uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946807; c=relaxed/simple;
	bh=OwxsJnoObmk8JR3QIjbCx4HI1bG12051WCBjIp8n56Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVaoe2fAiMDmSlv71XR7hO1qOHCCmyvStzYiopEYC/HBmH77NcR1B6KrrYWx7KoJna6tWvjQ802N1kokjqjX9Jin2OYSCh6yzbkXBxXRnTpnPreNpxbe6Bu90o+u+7qaFQ0EXem3lTxnC5v2vqGZtN18oS0E9i27ns+dg1mKXeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDu7spia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDu7spia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4C4C4CEE3;
	Tue, 29 Apr 2025 17:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946807;
	bh=OwxsJnoObmk8JR3QIjbCx4HI1bG12051WCBjIp8n56Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDu7spiahxCIWyhOKDVQB6Ul9JWA7IQB3Ks2m7bQLU5XBj8t2pzeNVe8WZkg9uOlw
	 fpHhNpSlX6qfQ4OgzQbDMCIjumXpJYh5O13YSsld8FUN+FikLtB6HCIo54+dB/NTR6
	 pcZH0nTs8/xWk3JCq1iYYDXsX21PJcCJRke+7spU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 076/286] jbd2: remove wrong sb->s_sequence check
Date: Tue, 29 Apr 2025 18:39:40 +0200
Message-ID: <20250429161110.976479051@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit e6eff39dd0fe4190c6146069cc16d160e71d1148 upstream.

Journal emptiness is not determined by sb->s_sequence == 0 but rather by
sb->s_start == 0 (which is set a few lines above). Furthermore 0 is a
valid transaction ID so the check can spuriously trigger. Remove the
invalid WARN_ON.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250206094657.20865-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1649,7 +1649,6 @@ int jbd2_journal_update_sb_log_tail(jour
 
 	/* Log is no longer empty */
 	write_lock(&journal->j_state_lock);
-	WARN_ON(!sb->s_sequence);
 	journal->j_flags &= ~JBD2_FLUSHED;
 	write_unlock(&journal->j_state_lock);
 


