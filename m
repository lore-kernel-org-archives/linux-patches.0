Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5665A1D0487;
	Wed,  2 Oct 2024 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876913; cv=none; b=XoMnCdT8DpilyrC75me/FRrE+Ef3W1yZxWsXQRj/2fwWpcjaNI3MZ8Ve9zE0M0o5eoK1jRvmGqRyR8OnnDSQGAz3pHPkLnaWKldwVXBmhLbVSWrAiLyFvN7jnDRZWNA/yJKa1v2lvltKPVYOxIInYsO3mPzyTAqow8+l3oq5D9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876913; c=relaxed/simple;
	bh=5G2gSjJq9nKhIXFl4COSj8EH3kSclk8PEzOmfrmA41M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzF52Ka6MR9AaWanMbd8pMeMLJeeHQnoa4pzrx7KuU7uLB3H56a0/3Eku0ZGntxY6357OPTrDy7XOC420K4qDDn4nJqyL+5COY1NKDpJA0uA9wPydp8H6f+USMZhj/3ksWifClEAI5awYVtFqu+YyKKPkEYDzsIfNkfjMohb59s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xl242OmD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xl242OmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E932C4CEC2;
	Wed,  2 Oct 2024 13:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876913;
	bh=5G2gSjJq9nKhIXFl4COSj8EH3kSclk8PEzOmfrmA41M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xl242OmDLmHcKgrNv2o7sr6ZsZMgvRIEfQnKRXL0GYyKwJKJNXNdyD9NdL/UtLNOx
	 xQfoeYeyQ0d/WosLTeVHXI/KpeCzplWbdwdn6YEuOtbKH1RuAasEx6gVBMXirOpdNe
	 nsbw5po/cESINperx1uCeyIAivzwMWWVaEkF5hns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 603/695] drbd: Add NULL check for net_conf to prevent dereference in state validation
Date: Wed,  2 Oct 2024 15:00:01 +0200
Message-ID: <20241002125846.583792729@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Lobanov <m.lobanov@rosalinux.ru>

commit a5e61b50c9f44c5edb6e134ede6fee8806ffafa9 upstream.

If the net_conf pointer is NULL and the code attempts to access its
fields without a check, it will lead to a null pointer dereference.
Add a NULL check before dereferencing the pointer.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 44ed167da748 ("drbd: rcu_read_lock() and rcu_dereference() for tconn->net_conf")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Link: https://lore.kernel.org/r/20240909133740.84297-1-m.lobanov@rosalinux.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/drbd/drbd_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -876,7 +876,7 @@ is_valid_state(struct drbd_device *devic
 		  ns.disk == D_OUTDATED)
 		rv = SS_CONNECTED_OUTDATES;
 
-	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
+	else if (nc && (ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
 		 (nc->verify_alg[0] == 0))
 		rv = SS_NO_VERIFY_ALG;
 


