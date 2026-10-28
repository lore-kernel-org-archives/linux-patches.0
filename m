Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207875;
	b=jK6MRXWrW4YDg2gj0gVFmb98WTh8uioj6/4HNrSSrYTNv52DlANUK0759yiN0k8xd0eH
	 C7yAt+AvGVdzGNbqVyMOYb2dPAdrnSLFf3ANDDlN0DgLsl/W45RtyaQmJX96hpSRgKhDu
	 O/LvfaQa8uswDXh0/mYN453Gas4cpPvf6JNz+RrMSvbqHuIRYNeyne4VXhfCnz1Tfl2OV
	 99LfMfFoGlOaLanlGRMjkr91pvym+JcMhScsBHx+NBGDgBlcFgX2cDnePEuV3XvZ3qmqe
	 tmQ/1mXkxxMx9frArVXDXsuXtqJZBpLQOd8/OBLsxli+FcyZNUlrd8w19C03ydrNzIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q/iyakcc44uQGfkDO9sVhLz0+RbXmprSXnLNerEZHQg=;
	b=nObM8nBPfPbqfXlgkAYcPp/h1hFpTRAXQa/qkbFpsHFT+Z598ZgNdPNiax9Fup4X448p
	 CQj8ucsOR1hHaZsyJsoY0zoyboRMYJm0Ilsa/X9Q6ZnClC5oG5fn60ySpFmPd22KpIreJ
	 jFXAxkeHNX5oYAwe+9kJZtWRdQEk44+9rwCZxA0noIK5jJ/ZZN9CoZPQW0sTyNH4K23qr
	 CbAcOh7Tw9iCJfOSMuD3EBtnh0L8riiQ8za8pR/xSn3bs23n0BSdAoxEaok9dHtUN9yia
	 zrcCtOCSJ0UF+JN4s/Jmb3sBHgLTuqEBEiGnDLFp0OHXbTS+EubEE0CRDVrr9b/lFJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IBCuHyDc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE48606A31F;
	Wed, 28 Oct 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IBCuHyDc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B891F031E2;
	Wed, 28 Oct 2026 17:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207875;
	bh=Q/iyakcc44uQGfkDO9sVhLz0+RbXmprSXnLNerEZHQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBCuHyDc6Npo5j1o73Iv2kLj6LU/O/nEVgNtHkt+0sjykI2Zo79EpTXoPyX5pXLQP
	 Y6VGXPhjAFZq6QktyKChB4rjgkoimKign1iECLC0PNfv2ntV4zET5ksvzM0GyeQ6XR
	 Eb4BPIwdTO/3FSRZO/WHJiH0jOFmK3yW9cZ1Eb1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/247] netrom: fix nr_node leak when nr_del_node() removes the last route
Date: Wed, 28 Oct 2026 17:59:31 +0100
Message-ID: <20261028165951.399529802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

nr_del_node() takes a reference on the node with its lookup. When the
route it deletes is not the last one, it drops that reference before
returning. When it is the last one, it only unlinks the node with
nr_remove_node_locked(), which drops the list's reference, and returns
still holding its own: the unlinked node is never freed.

Seen with kmemleak on a live node after adding and then deleting a
route to a dummy node with nrparms (SIOCADDRT then SIOCDELRT): the
96-byte nr_node allocated by nr_add_node(), callsign and mnemonic of
the dummy node in its hex dump, is reported as unreferenced.

Drop the lookup reference in both cases.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit a4b96115783fdefae9599f9a84a39e24fb288d6b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 98ba317ada637..288c4a91ea9b7 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -388,8 +388,9 @@ static int nr_del_node(ax25_address *callsign, ax25_address *neighbour, struct n
 				case 2:
 					break;
 				}
-				nr_node_put(nr_node);
 			}
+			/* Drop the reference taken by __nr_node_get() */
+			nr_node_put(nr_node);
 			ret = 0;
 			goto out;
 		}
-- 
2.53.0



