Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB50031F994;
	Mon, 13 Apr 2026 16:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099313; cv=none; b=nIj/G0N1zIMHGbTVWA27YLWVG5WsWvlju9NQW1fJb0mOO0T8PMB84M6h1fyonbIt6pYGH6p2nKKZRt0eVv8pn36tb7/kPX/YShp/xnh23plkUHGLpubKvmMkVlglltXfmfft25fN6aNC3OfYezQgOnLm52nYRrATzMNz7d7G3w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099313; c=relaxed/simple;
	bh=HrP9nK2ccJ5tksXM7ThFYs78dZXYWr6XfFeGCXMB9zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSze0pFnT4xxDdZW4S0inJ28Cm3Iwg4haQca5tK+mncqnLCkOMdM1TGHnMLBC22ife4dad8NcRt6dXKWlSBQNKPMvbpEUlkk0qOwPP+/k6Q/5Y5VZwe1cniEu1/R8fWbAGWCKfxlw9P/zsvFh34iYwD+D1CPLYTU8uhVVbBEaMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4Qqvdo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4Qqvdo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61759C2BCAF;
	Mon, 13 Apr 2026 16:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099313;
	bh=HrP9nK2ccJ5tksXM7ThFYs78dZXYWr6XfFeGCXMB9zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4Qqvdo2xgknwjpZBHEci8QlQ58u7/iu29Ai404ABE3GSKOmhPVz+5P/7SPOENBbO
	 l+7xCzEM7oNkeaXYG83ubEZQ3QQ9V0a4/e6ZIjx1GIVH+Pj87lA3g4gTlvluWlZGaz
	 p5kefkJPlauTUZwoWtgGsQmagMMlZSRWShaEEwHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Buerg <buermarc@googlemail.com>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/491] sysctl: fix uninitialized variable in proc_do_large_bitmap
Date: Mon, 13 Apr 2026 17:58:58 +0200
Message-ID: <20260413155830.014357711@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index abe0f16d53641..c2870c9cae14a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1549,7 +1549,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 	unsigned long bitmap_len = table->maxlen;
 	unsigned long *bitmap = *(unsigned long **) table->data;
 	unsigned long *tmp_bitmap = NULL;
-	char tr_a[] = { '-', ',', '\n' }, tr_b[] = { ',', '\n', 0 }, c;
+	char tr_a[] = { '-', ',', '\n' }, tr_b[] = { ',', '\n', 0 }, c = 0;
 
 	if (!bitmap || !bitmap_len || !left || (*ppos && !write)) {
 		*lenp = 0;
-- 
2.53.0



