Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE30274FD0;
	Mon, 27 Oct 2025 19:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593149; cv=none; b=LfmSbVx9llw89NzNH752vOjerhMajbgU9zNS/1SOFcCSS81i2jNKFydcALQVu3BZ6vPWVS/Q7k7+b72tstVWD311gpIq3cBo9a9EFJMkJB2ej+r/5kCaFTNB8vT1N/nu7WeO7IyQIKOHQdaFEUK4CxaPa+5ZHJ51b2rGpgKEVYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593149; c=relaxed/simple;
	bh=o5wFBb0DnE+HtdSCEXjuXyHdoL+yt7WZw7pwXQpgSbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us993kPCx3t2fJ7rPjrfAkMth4kwD5cPgoEisp3ONBe1022LFsmbGkJhsgA/+YnuW5Ht/hckezN04ri/sykTmBSVxxvRL5pqFLwZsZ4YwXCzDPGHKV5TcgR33kc88PnhdjEUwoXX0+2eAmHzFZ9CuhhNebRX0XPd2/pn7rylPE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMcJBqh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMcJBqh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8F0C4CEF1;
	Mon, 27 Oct 2025 19:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593148;
	bh=o5wFBb0DnE+HtdSCEXjuXyHdoL+yt7WZw7pwXQpgSbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMcJBqh6wjdjRcDw+ea7mLHmMMeKy9MHxbfHiF1Ag1A4A9oGGyRkC5S4N8r6DpVMT
	 5bPOOpAz4sPDtHOpeJr7AR65OmWmV0RpmeignqCRralmAX8uYr90fF25Tqdz6gYVVg
	 haw9cfjWMoaD2V0hmP81LcrlPDK8sGu2VHgZHiEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 005/184] dlm: move to rinfo for all middle conversion cases
Date: Mon, 27 Oct 2025 19:34:47 +0100
Message-ID: <20251027183515.085263742@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit a8abcff174f7f9ce4587c6451b1a2450d01f52c9 ]

Since commit f74dacb4c8116 ("dlm: fix recovery of middle conversions")
we introduced additional debugging information if we hit the middle
conversion by using log_limit(). The DLM log_limit() functionality
requires a DLM debug option being enabled. As this case is so rarely and
excempt any potential introduced new issue with recovery we switching it
to log_rinfo() ad this is ratelimited under normal DLM loglevel.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c    | 2 +-
 fs/dlm/recover.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 6dd3a524cd352..be938fdf17d96 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -5576,7 +5576,7 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 
 	if (rl->rl_status == DLM_LKSTS_CONVERT && middle_conversion(lkb)) {
 		/* We may need to adjust grmode depending on other granted locks. */
-		log_limit(ls, "%s %x middle convert gr %d rq %d remote %d %x",
+		log_rinfo(ls, "%s %x middle convert gr %d rq %d remote %d %x",
 			  __func__, lkb->lkb_id, lkb->lkb_grmode,
 			  lkb->lkb_rqmode, lkb->lkb_nodeid, lkb->lkb_remid);
 		rsb_set_flag(r, RSB_RECOVER_CONVERT);
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index be4240f09abd4..3ac020fb8139e 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -842,7 +842,7 @@ static void recover_conversion(struct dlm_rsb *r)
 		 */
 		if (((lkb->lkb_grmode == DLM_LOCK_PR) && (other_grmode == DLM_LOCK_CW)) ||
 		    ((lkb->lkb_grmode == DLM_LOCK_CW) && (other_grmode == DLM_LOCK_PR))) {
-			log_limit(ls, "%s %x gr %d rq %d, remote %d %x, other_lkid %u, other gr %d, set gr=NL",
+			log_rinfo(ls, "%s %x gr %d rq %d, remote %d %x, other_lkid %u, other gr %d, set gr=NL",
 				  __func__, lkb->lkb_id, lkb->lkb_grmode,
 				  lkb->lkb_rqmode, lkb->lkb_nodeid,
 				  lkb->lkb_remid, other_lkid, other_grmode);
-- 
2.51.0



