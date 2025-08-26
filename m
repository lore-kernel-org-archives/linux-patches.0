Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3524321D3C0;
	Tue, 26 Aug 2025 11:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208577; cv=none; b=I7vSBljM70QQPeuRHQAirUEVOf8SuLERiX4dZ11lmVejGxANXphZtqKaSO4mMQkRThi6Brj6C+/eQNsXw3WlK7PohbgvVTRFEhLdTCMGfpSZE3zQrbzYCFiXHnq60C4eQj1Rp4l66U4yeW4pcFStMVN0puzZ+5jDl6Tk/XwS75k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208577; c=relaxed/simple;
	bh=km1kAcrntA8pLmP/QWWkEL4tKkHs1JFK28nNLu6bPo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irjGeSwX68h5kVibH3WR+SceT1pA96Tc3f3Dr9KpE7Oi/5QHgJTjEAC2KXSCLindort8jOmAO7+WW/AV2ybNmLpLBsJsdzicbOtNC7j2yv5cd8NBuzA+h9HhJg3a8U6vBT0injRSLfVvXp5Qt6M2cXQlq+4fIhMNus9c8k42Tzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0gg7w3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0gg7w3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93365C4CEF1;
	Tue, 26 Aug 2025 11:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208577;
	bh=km1kAcrntA8pLmP/QWWkEL4tKkHs1JFK28nNLu6bPo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0gg7w3q6BIpWLjipL5ZFeAKtnm61kpnU/MPo+HcIj8GWX5v14Tu5mQ6zBhoJZaec
	 MorqcyAGtrNtyvYZr0WGk07VuXETlp/LOKDNxRD/1VoiR0lMhBngbL79HAA6qeS/JZ
	 D17z9ye+BlkNbuxbdCJpTpzArg+xjRtCmFtwOhys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominique Martinet <asmadeus@codewreck.org>,
	Maximilian Bosch <maximilian@mbosch.me>,
	Ryan Lahfa <ryan@lahfa.xyz>,
	Christian Theune <ct@flyingcircus.io>,
	Arnout Engelen <arnout@bzzt.net>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 164/322] iov_iter: iterate_folioq: fix handling of offset >= folio size
Date: Tue, 26 Aug 2025 13:09:39 +0200
Message-ID: <20250826110919.880310488@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Dominique Martinet <asmadeus@codewreck.org>

commit 808471ddb0fa785559c3e7aee59be20a13b46ef5 upstream.

It's apparently possible to get an iov advanced all the way up to the end
of the current page we're looking at, e.g.

(gdb) p *iter
$24 = {iter_type = 4 '\004', nofault = false, data_source = false, iov_offset = 4096, {__ubuf_iovec = {
      iov_base = 0xffff88800f5bc000, iov_len = 655}, {{__iov = 0xffff88800f5bc000, kvec = 0xffff88800f5bc000,
        bvec = 0xffff88800f5bc000, folioq = 0xffff88800f5bc000, xarray = 0xffff88800f5bc000,
        ubuf = 0xffff88800f5bc000}, count = 655}}, {nr_segs = 2, folioq_slot = 2 '\002', xarray_start = 2}}

Where iov_offset is 4k with 4k-sized folios

This should have been fine because we're only in the 2nd slot and there's
another one after this, but iterate_folioq should not try to map a folio
that skips the whole size, and more importantly part here does not end up
zero (because 'PAGE_SIZE - skip % PAGE_SIZE' ends up PAGE_SIZE and not
zero..), so skip forward to the "advance to next folio" code

Link: https://lkml.kernel.org/r/20250813-iot_iter_folio-v3-0-a0ffad2b665a@codewreck.org
Link: https://lkml.kernel.org/r/20250813-iot_iter_folio-v3-1-a0ffad2b665a@codewreck.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Fixes: db0aa2e9566f ("mm: Define struct folio_queue and ITER_FOLIOQ to handle a sequence of folios")
Reported-by: Maximilian Bosch <maximilian@mbosch.me>
Reported-by: Ryan Lahfa <ryan@lahfa.xyz>
Reported-by: Christian Theune <ct@flyingcircus.io>
Reported-by: Arnout Engelen <arnout@bzzt.net>
Link: https://lkml.kernel.org/r/D4LHHUNLG79Y.12PI0X6BEHRHW@mbosch.me/
Acked-by: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>	[6.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/iov_iter.h | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/iov_iter.h b/include/linux/iov_iter.h
index c4aa58032faf..f9a17fbbd398 100644
--- a/include/linux/iov_iter.h
+++ b/include/linux/iov_iter.h
@@ -160,7 +160,7 @@ size_t iterate_folioq(struct iov_iter *iter, size_t len, void *priv, void *priv2
 
 	do {
 		struct folio *folio = folioq_folio(folioq, slot);
-		size_t part, remain, consumed;
+		size_t part, remain = 0, consumed;
 		size_t fsize;
 		void *base;
 
@@ -168,14 +168,16 @@ size_t iterate_folioq(struct iov_iter *iter, size_t len, void *priv, void *priv2
 			break;
 
 		fsize = folioq_folio_size(folioq, slot);
-		base = kmap_local_folio(folio, skip);
-		part = umin(len, PAGE_SIZE - skip % PAGE_SIZE);
-		remain = step(base, progress, part, priv, priv2);
-		kunmap_local(base);
-		consumed = part - remain;
-		len -= consumed;
-		progress += consumed;
-		skip += consumed;
+		if (skip < fsize) {
+			base = kmap_local_folio(folio, skip);
+			part = umin(len, PAGE_SIZE - skip % PAGE_SIZE);
+			remain = step(base, progress, part, priv, priv2);
+			kunmap_local(base);
+			consumed = part - remain;
+			len -= consumed;
+			progress += consumed;
+			skip += consumed;
+		}
 		if (skip >= fsize) {
 			skip = 0;
 			slot++;
-- 
2.50.1



