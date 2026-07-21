Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1431046AA62;
	Tue, 21 Jul 2026 15:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647985; cv=none; b=FaudSsUbgzrysLjJkzLvL5TzEkju7TESKoz3vuZXo5COGMBoFuoqlN+Eb0RwP8WIdqU+66aKtbCo7Cl+E6KwXBbOO3E0w7QbKUgdjDcuIGcHktQwG/OHHrEgmBzZpnPMYdBY3Fy2Za7HvrNaZdZyG2vMD5L2J32mII5O2bUB9Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647985; c=relaxed/simple;
	bh=0bEl4wGKmSeesM62c6mp2G+dCJxHP6ogGzKaSANEU08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lO4Iitr3Xa+zuEV109/o4yGfg75K52LD3/xhv3HL8mBDiwq2yHN66Sw/OnerHBPbh05sljWlE0+KwEl0PMNV56BloD3KjGIVx+UW+tNOderc5ZZXvqR6YHLuLftwpg/0hhCgViqkgFEO7INIQuIeO9aZs6dWTMAZrl68NSc3G3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EghQD7MJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EghQD7MJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F60C1F000E9;
	Tue, 21 Jul 2026 15:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647984;
	bh=ssvwz1iFLD0S1Au7q+shvjJ3F/2TnniXtME37Z7u3Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EghQD7MJUhgQ+dqoFCB3nq8ZLo9nOavMo9QmKrL3ls/8thHgZ2akiv70UW/1v3yab
	 xpNtAJPV2NEaPfTW6+sd7IcY89FA8+H42NZYXBv7rwnPoOvB3paNU6dIKI4Cgaq56l
	 NHvlu/RhTNVM7lAdyYSzlJMR41HMqqAQoXxv3CFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 0028/2077] rxrpc: Fix rxrpc_rotate_tx_rotate() to check theres something to rotate
Date: Tue, 21 Jul 2026 16:55:01 +0200
Message-ID: <20260721152553.340282312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit a5462da5a349fc7f17ad5ebd899380260d03e7ed upstream.

Fix rxrpc_rotate_tx_rotate() to check that there's something in the
transmission buffer to be rotated before it attempts to rotate anything.

Fixes: b341a0263b1b ("rxrpc: Implement progressive transmission queue struct")
Link: https://sashiko.dev/#/patchset/20260618134802.2477777-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-12-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -236,6 +236,9 @@ static bool rxrpc_rotate_tx_window(struc
 		call->acks_lowest_nak = to;
 	}
 
+	if (after(seq, to))
+		return false;
+
 	/* We may have a left over fully-consumed buffer at the front that we
 	 * couldn't drop before (rotate_and_keep below).
 	 */


