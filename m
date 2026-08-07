Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10474746A8;
	Fri,  7 Aug 2026 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115067; cv=none; b=q51G8AOLMjndiS156PkUGAcZBTFyyd0mtlRTtgNBG4zIyvMvSuHn2cTgU6nH7OfiJm4Q6Hi3Ozd8TpIt4dae4cFJd6KRLDc16Zxce2zRQYg4SK165X5df4wvhWEXhN9P4/CbrGTb/CiMG0Q9N9+i7sN4zUXYwOeQndZS0LCGqFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115067; c=relaxed/simple;
	bh=Wggo2VxFg8bIAUDM38150L+VaKAwdcgWfLxLmtkp20c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qI2+k92t9UYdrsU3pssDoEg6WZjaHhi6UwFIMkTt51eyN630mkhr6fh5YDu0VHAI3PvWUweD1MOc7nRTFRwNEE0rWxhLAawqF4AM6sHfdqDMjF2O4gGk7jcL+BhfXrPPtiFH9hYvpJtHUyy6LP3ORk33NCXUCX0Y50yS5/wsyww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+RiAC+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+RiAC+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030321F00A3F;
	Fri,  7 Aug 2026 15:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115056;
	bh=DoMiCM30oz4W3rb5HJbkTpECR7J75wLq14ekd4oGWGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+RiAC+mJR5F0do4yf336/sPa/Nw267lHZB2tc23DMx17mlL0sAEkOBLMpKHLkRZh
	 412m1VrcUmXTkbhnwA/aJRcjwl+w7Cgi+mCP7a7ulU2x6zDw0kwxV7Ezy7AwsLhwym
	 0COs0LLjlGQ5Cbc92FhUhnuvVN36CiXsWCDVKse0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/396] netfs: clear PG_private_2 on copy-to-cache append failure
Date: Fri,  7 Aug 2026 16:34:18 +0200
Message-ID: <20260807143426.400196208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit a81fc9266e1c5fef9ccf675a9b44b2f4ab464923 ]

netfs_pgpriv2_copy_to_cache() marks the folio with PG_private_2 before
netfs_pgpriv2_copy_folio() appends it to the copy-to-cache rolling
buffer.

If the append fails, the folio is not queued for cache writeback, so
the PG_private_2 state and its reference must be released immediately.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260727130716.1099906-2-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/read_pgpriv2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index a1489aa29f782..7eacc58abadb7 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -54,6 +54,7 @@ static void netfs_pgpriv2_copy_folio(struct netfs_io_request *creq, struct folio
 
 	/* Attach the folio to the rolling buffer. */
 	if (rolling_buffer_append(&creq->buffer, folio, 0) < 0) {
+		folio_end_private_2(folio);
 		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &creq->flags);
 		return;
 	}
-- 
2.53.0



