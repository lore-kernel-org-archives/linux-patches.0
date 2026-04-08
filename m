Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B18B67E;
	Wed,  8 Apr 2026 18:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673601; cv=none; b=Iv7TNIcxnapBWkjfCI9rbnpcD/6AsUNgvMK+TJmptUax81D1bhYuum11EIX2JRdaS0wJihXSDvYHtfkS7BonQWkydVYU/IZM7NBYy7/6FifElFX+xreLw/2Ox9ifZUDA5CpXuP1liXwHJSy9LXFB9hTuIa38xV86CZ5e72fYdFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673601; c=relaxed/simple;
	bh=iUi4nhaRTNB4iyPw7mzkRDoY0VSzD+LqMFcus23npyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceP+74XjoCyoOhqi3agA2bdA0g8jD4D9m9Oz5qcXr0ig2n2t0pFwG/WetH25QT3vF7iYAPVIap/46Nsrp1q5279wUbbcJuOd+nIwsmgpfkYMGTCp/AcqJW693w1wMCbLpPZBYjfn287VDp5T1HBRvuVfgR301z4ArQ5SY5QH8Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnTWKy12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnTWKy12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4774C19421;
	Wed,  8 Apr 2026 18:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673601;
	bh=iUi4nhaRTNB4iyPw7mzkRDoY0VSzD+LqMFcus23npyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnTWKy123QvDDvoHKTezjySoPcSuSN4Uzxe78Z+DQQRAH6if1cuptcMs6xKbwhXT9
	 1Q9xA7dc5RNnOI+QlGfBgXdbNTFuI9U64N5gKWgKJRwbpWCEl4lqh7iPD7R1Ox7d+m
	 Fkd6y2prziYfnzfLb9tD8U99719ZPb+5s4b/TdtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 018/242] io_uring/net: correct type for min_not_zero() cast
Date: Wed,  8 Apr 2026 20:00:58 +0200
Message-ID: <20260408175927.754052620@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit 37500634d0a8f931e15879760fb70f9b6f5d5370 upstream.

The kernel test robot reports that after a recent change, the signedness
of a min_not_zero() compare is now incorrect. Fix that up and cast to
the right type.

Fixes: 429884ff35f7 ("io_uring/kbuf: use struct io_br_sel for multiple buffers picking")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509020426.WJtrdwOU-lkp@intel.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1122,7 +1122,7 @@ static int io_recv_buf_select(struct io_
 		if (sel->val)
 			arg.max_len = sel->val;
 		else if (kmsg->msg.msg_inq > 1)
-			arg.max_len = min_not_zero(sel->val, (size_t) kmsg->msg.msg_inq);
+			arg.max_len = min_not_zero(sel->val, (ssize_t) kmsg->msg.msg_inq);
 
 		ret = io_buffers_peek(req, &arg, sel);
 		if (unlikely(ret < 0))


