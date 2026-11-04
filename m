Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827154;
	b=PyvjHeM9u6ZWMRMSMB6JhdyX6AC/AL4BeIQ5IgHE7iNXh11dlrx4MIfjx+HlL5tWdejx
	 U/duFTP4VmFTazpye5nVxRUmolPpLchqpkzTPBLSSq5SXUCPKKKi2NEjX3rcluYwvw4Cf
	 SfiQjetNqbwGchm722xfVKVb0mViXvgKimF0TRZ4/pxaY9qgSikDHtDoiu1lsKiYBetP9
	 UX6LCJvodDH/h0Cu/pVOQ+o+Ozouq2+JuQl3z5Q0p26yrixJMRJ1gd+qlJNVQPS7ykEJh
	 wKK5YpgaF+yDpZCtIInHHJnW1QNgBqhb9gqmBJPv9dVFVdjVTr1GmF9ud44Bp9Yx+EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KUaK5UVVDAwM2rxv3QQBBOgAkapCEvDQgczFJV8ChOM=;
	b=Vt+I+cpgrafEE0W5Nxp5gn1CKZvLkcaDzBX05BuJfloTF/yb+fPJxS4JLn3wLEjfBl03
	 +4dWtzb/4YTWabCWU0tigZPvQ7BZcN/29RGdz04WWU0qQ6o6NtJHrsf0I7Eq/L/YVJAEK
	 B/+/ombvs/U4ljEjsU1xjSMXwlDlL4wjDIbiXqCwZMXBEcvx6VYeJRxQ2DNKlEsdPj18V
	 TH6wdcjf1HVhW/ixYAEDbhZMyEEYvRzuMQsiFoT1QSyOvLsABgoesMDXEE+xMUruHsLpy
	 zAX+WNqHFxpwMUjIzZwh/Xn+SMdg77F+qKmF8axC0HjN6+p/rmxQChAqS4YF1+fdmew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8KlYy7a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8816074F82;
	Wed,  4 Nov 2026 21:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8KlYy7a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD17E1F00A16;
	Wed,  4 Nov 2026 21:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827154;
	bh=KUaK5UVVDAwM2rxv3QQBBOgAkapCEvDQgczFJV8ChOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8KlYy7azgt63Bb6OS/5Feo9IQ0haXeTOstRwYI8j+dhpTJYPZrXDgkb3skW3emcs
	 ULYfcoBmLS2Y0kQl2E9hZ4ZB8djO3h8n6wj+vZ+pUyN+B4P05XrmscFr2OVmaFYbyF
	 qjr7yeKCZC7weGPyxMV0NqQBAKXOBU0G02SI8wnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 220/547] iomap: dont resubmit an ioend after ->writeback_submit() failed
Date: Wed,  4 Nov 2026 16:06:44 -0500
Message-ID: <20261104211044.404647898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

commit 3f517370076f1fedaa38cd8c78ceb73616b79336 upstream.

iomap_add_to_ioend() submits the pending ioend through
->writeback_submit() before allocating a new one for the current range.
When the submission fails the helper completes the ioend with an error,
but iomap_add_to_ioend() returns the error without clearing
wpc->wb_ctx.  iomap_writepages() then submits whatever wpc->wb_ctx
points to, so the already completed ioend is submitted a second time.

For XFS the second bio_endio() lands in xfs_end_bio(), which
list_add_tail()s the already linked ioend into ip->i_ioend_list.  This
corrupts the list and leaves a use-after-free/double-free window against
the ioend completion worker.  Reproduced with a fault-injected
->writeback_submit() failure on a reflinked XFS file with several
CoW writeback ranges in flight: the unfixed kernel hits repeated
"list_add double add" warnings from __list_add_valid_or_report(),
the fixed kernel fails writeback cleanly.

Clear wpc->wb_ctx when ->writeback_submit() fails.  The old
iomap_submit_ioend() cleared the context unconditionally; that clear was
lost when submission moved to iomap_ioend_writeback_submit().  The final
->writeback_submit() call in iomap_writepages() needs no equivalent fix:
it is the last thing the function does before returning, and every
caller allocates its iomap_writepage_ctx on the stack for a single call,
so wpc->wb_ctx is never read again afterwards.

Fixes: f4fa7981fa26 ("iomap: hide ioends from the generic writeback code")
Cc: stable@vger.kernel.org # v6.17
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/90fbd42df4f51306e57a95830d2d53873f630eb9.1790342457.git.parri.andrea@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/ioend.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -246,8 +246,16 @@ ssize_t iomap_add_to_ioend(struct iomap_
 new_ioend:
 		if (ioend) {
 			error = wpc->ops->writeback_submit(wpc, 0);
-			if (error)
+			if (error) {
+				/*
+				 * ->writeback_submit() completed the ioend
+				 * with an error, so drop the stale context;
+				 * iomap_writepages() would otherwise submit
+				 * it a second time.
+				 */
+				wpc->wb_ctx = NULL;
 				return error;
+			}
 		}
 		wpc->wb_ctx = ioend = iomap_alloc_ioend(wpc, pos, ioend_flags);
 	}


