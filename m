Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36649423A7C;
	Tue, 31 Mar 2026 16:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975904; cv=none; b=Q8hT5jdjjXIIGa7mGkLRpNQWeW4gH6Tff7OVkRVHHJaVNjsoueA1B3rsmwi0m1/P55MzoXjF5DO6QFpnvLi/3GkKV6WnTOpZPXjYzmh3WF/nFlh6P0rEQUtwPS9saSujVg31OeGFciy/p1ZGjOoAbASFlgwIuRbHfJUS20a9RlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975904; c=relaxed/simple;
	bh=lpfOwLSsEkIjkniFXebpQ0nXyA3AXzIeLhykGe4yzyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meMy4FpNshlCvWDGlJa3doVGS/D8O9/uD839GReREU7rF10c0aKhFZ7COx+RkOt74w+Q4Ep11eRQcPXJgseu5RZSFOwztSyGd+PtwxsUhecigafFfK32UunxhAe7EWb4W2HiX0sLYgalxXuytxPCGcjuywzLvbaaof8Aqsgtcsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAsZZ2Qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAsZZ2Qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A5DC19423;
	Tue, 31 Mar 2026 16:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975904;
	bh=lpfOwLSsEkIjkniFXebpQ0nXyA3AXzIeLhykGe4yzyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAsZZ2QytyzeD/Ew3HeLodTdTUudU6smW8wR8zdWgcI2hagXYr2y2mYxYvdppvefL
	 c8ZOT2GxnrkXOJC9xq+Ngcb2PIu9o25HJjq2FCC0b586SoiSRnybTnvlRzn7Ic1bgM
	 nc9rnYOrswjR5WItvUUTG5eLKQM3zGi556NuQXmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Buerg <buermarc@googlemail.com>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/244] sysctl: fix uninitialized variable in proc_do_large_bitmap
Date: Tue, 31 Mar 2026 18:21:21 +0200
Message-ID: <20260331161746.493517199@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Marc Buerg <buermarc@googlemail.com>

[ Upstream commit f63a9df7e3f9f842945d292a19d9938924f066f9 ]

proc_do_large_bitmap() does not initialize variable c, which is expected
to be set to a trailing character by proc_get_long().

However, proc_get_long() only sets c when the input buffer contains a
trailing character after the parsed value.

If c is not initialized it may happen to contain a '-'. If this is the
case proc_do_large_bitmap() expects to be able to parse a second part of
the input buffer. If there is no second part an unjustified -EINVAL will
be returned.

Initialize c to 0 to prevent returning -EINVAL on valid input.

Fixes: 9f977fb7ae9d ("sysctl: add proc_do_large_bitmap")
Signed-off-by: Marc Buerg <buermarc@googlemail.com>
Reviewed-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 79e6cb1d5c48f..de58128fa5212 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1369,7 +1369,7 @@ int proc_do_large_bitmap(const struct ctl_table *table, int write,
 	unsigned long bitmap_len = table->maxlen;
 	unsigned long *bitmap = *(unsigned long **) table->data;
 	unsigned long *tmp_bitmap = NULL;
-	char tr_a[] = { '-', ',', '\n' }, tr_b[] = { ',', '\n', 0 }, c;
+	char tr_a[] = { '-', ',', '\n' }, tr_b[] = { ',', '\n', 0 }, c = 0;
 
 	if (!bitmap || !bitmap_len || !left || (*ppos && !write)) {
 		*lenp = 0;
-- 
2.53.0



