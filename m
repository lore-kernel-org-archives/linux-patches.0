Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DD820B803;
	Wed, 19 Mar 2025 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395001; cv=none; b=BlL7TS6MlpXGbZcUINgcEPBElQeFePLtCctxU3n84EaFu4NqBiFFcNF2BJ7RdOCCaUYmeRUlI13r0gINGPlAjEwhe0AOPp8gPmWwo6rztKwPbhtFEvC76MELk7wWhzH5wfhMbrs3NUqtXDRU1oPZPcP16pwflqYV7R4tzmqPsiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395001; c=relaxed/simple;
	bh=CdzkQ4Rj/JMdYt0C6RJCITnUNRirwxKBU691yH/spZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4aykCDg/tcJRaa7cHVL96FXy/lJZn0BgK6b9p7QPZ/6vrTqbdfRuK4MC+v4ecE1KrSQrQ4OoCUgpdfN0BPZcobJczHy6ajz41IbkkrQz434GlF5v60uheZiBUEdBtIdXrlW7ZowDsF/ymq+mg1nOh7JLHOy1EInhfyc2TyLHW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoLEPNuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoLEPNuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D2EC4CEE4;
	Wed, 19 Mar 2025 14:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395000;
	bh=CdzkQ4Rj/JMdYt0C6RJCITnUNRirwxKBU691yH/spZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoLEPNuYdBXDowMrJrhbg40MZ+DGj1YdL324dX4dAHnc/4j9SDn2HOC10SQ7DbskU
	 qhyFXuqAruCXdDLyjA4Y0Ykg004A8LksC1f/bvN7W+OGfGiVNXVyykSs0JK3Lz/LCc
	 7SRGtVjM8YAu/MbaI97e1xhy9jV6hbD2OMfESHdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 6.13 241/241] fs/netfs/read_collect: add to next->prev_donated
Date: Wed, 19 Mar 2025 07:31:51 -0700
Message-ID: <20250319143033.699062344@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 fs/netfs/read_collect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -284,7 +284,7 @@ donation_changed:
 				   netfs_trace_donate_to_deferred_next);
 	} else {
 		next = list_next_entry(subreq, rreq_link);
-		WRITE_ONCE(next->prev_donated, excess);
+		WRITE_ONCE(next->prev_donated, next->prev_donated + excess);
 		trace_netfs_donate(rreq, subreq, next, excess,
 				   netfs_trace_donate_to_next);
 	}


