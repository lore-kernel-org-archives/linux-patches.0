Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312652550DD;
	Thu, 17 Apr 2025 18:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913579; cv=none; b=mUXF/6Hpq5o/tYdv7AMWxn4dmuQ8c1S9DQ6RNr8PEelIsSQQZMcis/yftsTUMzM1nVUmhYXrEtudfx1eReI/0aPEQedRMC+hvtVjUg7F9KY0EKujxol7YVsvPal7kMo1W6PSho5um7Ihp/g5nTP70cKxYy8dwNg5/aYo/ePHbIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913579; c=relaxed/simple;
	bh=hGGeFYMk04aCfyADGmbIxGb7y2HjuRtBrCysrLkzfcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCEg87JLP5X3iR5ustJTLzjojc0eP7iGGUlgipensfgoEpU/janQOyNhpgJdFVADSS5WW/XivJzzSXDh0iujDgCDOV2M4SIVZuSG9Hz0LrbecWqNoZb6DFxaM3a3vZXSqX3RnRpuUaY6ErvM7SxL7FvOwchyTcdqm10tGnPI/4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnXQMH3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnXQMH3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F64AC4CEE4;
	Thu, 17 Apr 2025 18:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913579;
	bh=hGGeFYMk04aCfyADGmbIxGb7y2HjuRtBrCysrLkzfcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnXQMH3h8Wec2p1+Xm3leoYZJrjPfXygR0oy/vltHD+PK3UnA8hFb+Y2j7Kna89pF
	 LMxAKWZ5VNb82LVbMpcCTQIHr+C5AXppjKcHgPE99WdMqOGIVlxd1zxe0LD/SoeHoy
	 zMUygKQyNSxYs4+EzZe99qgo13JwE/iUvX50zjRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.14 385/449] dlm: fix error if inactive rsb is not hashed
Date: Thu, 17 Apr 2025 19:51:13 +0200
Message-ID: <20250417175133.755803763@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

commit 94e6e889a786dd16542fc8f2a45405fa13e3bbb5 upstream.

If an inactive rsb is not hashed anymore and this could occur because we
releases and acquired locks we need to signal the followed code that the
lookup failed. Since the lookup was successful, but it isn't part of the
rsb hash anymore we need to signal it by setting error to -EBADR as
dlm_search_rsb_tree() does it.

Cc: stable@vger.kernel.org
Fixes: 01fdeca1cc2d ("dlm: use rcu to avoid an extra rsb struct lookup")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -784,6 +784,7 @@ static int find_rsb_dir(struct dlm_ls *l
 		}
 	} else {
 		write_unlock_bh(&ls->ls_rsbtbl_lock);
+		error = -EBADR;
 		goto do_new;
 	}
 


