Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CAF1DE4C9;
	Wed, 19 Mar 2025 14:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395156; cv=none; b=qHTiHZ6ZIr+izHaK/FeTthQKkwLaj3IGKj05QRV2d70WfV80jqliaiPxusAdSi5fCvw9XkLAzauHzl4OxI3yny9teaTc2GKRw+5eClxUdpvjVqAOq+lh3MlmMD5YfOO63cFd+kwVCOZH1hL/i+4dFR2u+8Dcz6ru31zHCge91Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395156; c=relaxed/simple;
	bh=QQpr0vl19bK5U9fkeSYBDet9mXr85TzL7aCT9h5WpeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ir92CWq8b/K8g3u6UQiZVwAvMT/sg92IMWxxvOuiHYpZISsjdlI9yUuZF60/+EQJfFbTq3udRkkuwk9NQBFgLzMqbI825d01YpcOPEa6RcsuxkgrZgx2jIjzeEODkiIB7SCKbqboKF9xBm5kJIrZ2Lt2zdkJB7cpVSlWq8uxPvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlPe/eu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlPe/eu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CF6C4CEE4;
	Wed, 19 Mar 2025 14:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395155;
	bh=QQpr0vl19bK5U9fkeSYBDet9mXr85TzL7aCT9h5WpeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlPe/eu/xOt+dgeMWbUU8fOWrPnzrYVMEwkWl4ldtw/185u1G53eGknlya0LdFKP+
	 Uoe2A44aRy27ASLJ36SrxRyJahRbw3g/15YKE2cztIbcij1vU9BRUfOJR3cHc9YXiF
	 iUjJPoR4XxcIHkUFhvHRKkseH81D4PTSyUSicZT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 6.12 231/231] fs/netfs/read_collect: add to next->prev_donated
Date: Wed, 19 Mar 2025 07:32:04 -0700
Message-ID: <20250319143032.544671430@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

If multiple subrequests donate data to the same "next" request
(depending on the subrequest completion order), each of them would
overwrite the `prev_donated` field, causing data corruption and a
BUG() crash ("Can't donate prior to front").

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Closes: https://lore.kernel.org/netfs/CAKPOu+_4mUwYgQtRTbXCmi+-k3PGvLysnPadkmHOyB7Gz0iSMA@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/read_collect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 8878b46589ff..cafadfe8e858 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -284,7 +284,7 @@ static bool netfs_consume_read_data(struct netfs_io_subrequest *subreq, bool was
 				   netfs_trace_donate_to_deferred_next);
 	} else {
 		next = list_next_entry(subreq, rreq_link);
-		WRITE_ONCE(next->prev_donated, excess);
+		WRITE_ONCE(next->prev_donated, next->prev_donated + excess);
 		trace_netfs_donate(rreq, subreq, next, excess,
 				   netfs_trace_donate_to_next);
 	}
-- 
2.47.2



