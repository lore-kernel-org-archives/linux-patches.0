Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE8330C36B;
	Mon, 13 Oct 2025 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368070; cv=none; b=aT+RnSBCIUc7S9OS47npTPMQBA8CVnshwyymJYvVLireXWSPHgY0waZ4weWObrf/k6077wQRIMCzy8lPeG9La86mArE4uBrA3xk+BPRmKi/InnID0Z0w+Zj5DSQNZ0/CQBVoxN5T8wtnCd9Ua/HOOYmdg1+EgsjlySLMDapeM8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368070; c=relaxed/simple;
	bh=uRbSfgy0C5DKIckVxmBZvaCvvOmYwK54AcdiM/U0UHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqvqVW6shEcJEf2fLNYEZNnu5RCUCQVVEDaNfBDrRf04rvvumwuopvdV8M+cM1Sne4zCv7WSZWEvPdyovTRs4s8rXcv5OBJKqa3gJDJH2gcLqs/oIr0/L5cJhTqsQYP4dAsbgury0W50dsdyWG8W0J1zP51W1V9Z7QzX236gs3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKeu+UZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKeu+UZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7DEC4CEE7;
	Mon, 13 Oct 2025 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368070;
	bh=uRbSfgy0C5DKIckVxmBZvaCvvOmYwK54AcdiM/U0UHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKeu+UZbjXJqKb2Ox76DBBrZjfAxKX5f1T9CxhUN0fL8IWsfouWhmqhMM1pTs4qqe
	 PLbocLbGVgbJjYhwxcNLEf05L5it4gBuFiMOTVYRZnaBdhwbh6t1b0bz5Jn264AD1Z
	 tYTHj5M+PcIVlyPb7eoxeMaA0iPY0x9NqsziA0dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/262] gfs2: Fix GLF_INVALIDATE_IN_PROGRESS flag clearing in do_xmote
Date: Mon, 13 Oct 2025 16:42:27 +0200
Message-ID: <20251013144326.318977597@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 061df28b82af6b22fb5fa529a8f2ef00474ee004 ]

Commit 865cc3e9cc0b ("gfs2: fix a deadlock on withdraw-during-mount")
added a statement to do_xmote() to clear the GLF_INVALIDATE_IN_PROGRESS
flag a second time after it has already been cleared.  Fix that.

Fixes: 865cc3e9cc0b ("gfs2: fix a deadlock on withdraw-during-mount")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 161fc76ed5b0e..e5558e63e2cba 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -801,8 +801,6 @@ __acquires(&gl->gl_lockref.lock)
 			clear_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
 			gfs2_glock_queue_work(gl, GL_GLOCK_DFT_HOLD);
 			return;
-		} else {
-			clear_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
 		}
 	}
 
-- 
2.51.0



