Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3C21E0087;
	Mon, 21 Oct 2024 10:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507207; cv=none; b=eiWvjDI5Jly1M5XHuVuFttsqoMkBaeDZ9nRWfPn0uI92sdlbJNJoKWj+0X9F6q5TvkC7PcjBWPNNHEGGeWstLKy8X8nnw/gUy8vgnUobunoT5r4pRtBO0QvUjYuuOHIU168zDNvXl4h9/h8f5NbItgao9o3QW5upmnOuq8WXcjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507207; c=relaxed/simple;
	bh=1t6zmq5evz7YAalKSm6T6pwyX8xGje7jnvyFAWLLk3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXNg5m5aLejSFl4SOngziFP3hwfPJfvhDzrCofqySedoAicJ6+ZV3O+BmQ4+asZpPeUkAN2T0/pWd/mOt+FDROhIOOYuXqeQPC0tS1pKehQVqX/Ci7n2jbbAit2yPauJTE+UNTQwL1PWabbCC770vOsrvZAI0QlDVu0I7voyiyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjDknawe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjDknawe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FD8C4CEC3;
	Mon, 21 Oct 2024 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507207;
	bh=1t6zmq5evz7YAalKSm6T6pwyX8xGje7jnvyFAWLLk3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjDknaweyCTur7ruo8SszxC3B+DuX42cNKeZB5GteoY8+dv/KtTbcAtq/CmnAtw0a
	 8aR1bwAGkeyBOD7/AZ05PDOaBehTWIumVu0Kaia1kh1ds72z7U05zNPqYv9rqT0dUq
	 XIaW8tWZGV3r8gnfnwzh2RfeQbLCDNvjUBfT/Eug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 094/124] xhci: Mitigate failed set dequeue pointer commands
Date: Mon, 21 Oct 2024 12:24:58 +0200
Message-ID: <20241021102300.361195471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit fe49df60cdb7c2975aa743dc295f8786e4b7db10 upstream.

Avoid xHC host from processing a cancelled URB by always turning
cancelled URB TDs into no-op TRBs before queuing a 'Set TR Deq' command.

If the command fails then xHC will start processing the cancelled TD
instead of skipping it once endpoint is restarted, causing issues like
Babble error.

This is not a complete solution as a failed 'Set TR Deq' command does not
guarantee xHC TRB caches are cleared.

Fixes: 4db356924a50 ("xhci: turn cancelled td cleanup to its own function")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241016140000.783905-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1046,7 +1046,7 @@ static int xhci_invalidate_cancelled_tds
 					td_to_noop(xhci, ring, cached_td, false);
 					cached_td->cancel_status = TD_CLEARED;
 				}
-
+				td_to_noop(xhci, ring, td, false);
 				td->cancel_status = TD_CLEARING_CACHE;
 				cached_td = td;
 				break;


