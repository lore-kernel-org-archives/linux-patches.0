Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626070;
	b=hTKKaAeUPHyTxFAjHHeY4mViAMi0RZs2tR7yT/0YHviPdPASY6hUzVVx32gw5sIg0CQV
	 4vMEQ4FeuJl8c556U5LECM7hN2FPWAJzDx1xWA6km0fQkXtbVAzhX+RobI066UcKkmbze
	 IZY19NvbE9vi2IlD50L/4Kn7m4GZLhZTD9+cPmzXBWVO4/slalZ/drDFpucCTR+RbYjeB
	 RKHV1GXg1TSjgft5lDdXda5AmiJQj0OH8C2ntuzUCFTjpnsrBRVAmmw/j+KLceYGzDlm3
	 d69hrk4nz9+WBxV1/4ICVjUYkbedet9t+5xN6+nJetRjP7ppMLuK+O3eleP9pyX7VSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o4YZ5aZZnVc1iv3hCdwAw1dCUGAJX3Cl0b1AWJBl/EY=;
	b=SwYwU9PsXi0QKyyHHUcagKliXXRnAX77S6FgOy8/oaZ8rP9f7tMcHrLdqlHGV0I6kKj3
	 fnnICjYJakkb4Qdr2bvQO5dRPq1POMdByhjVD//2v9LoYRtySWvp5S3heDsAIsYORWTuK
	 PrQ2EqPvVckMJeGzPMWGSTYM4FWcdPPlPxyUIWuZvWlVrn+gcmkrhab/jlmf3NUX+Nkn7
	 tj97rASIpqD1MMI4nVuvJcxoSM243vBfGl90uqE30rF3OMuaLkg2d+0FycAV27cgnRz3U
	 hrKQfoZ7Vas7LP0yM3upJ4gU5fBQCCLQ9zDj+tr1S19JUoVumLxni5UFrx+tvGzXTgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DHz/7a1Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3E9606A31E;
	Wed, 25 Nov 2026 17:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DHz/7a1Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1942F1F000C4;
	Wed, 25 Nov 2026 17:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626070;
	bh=o4YZ5aZZnVc1iv3hCdwAw1dCUGAJX3Cl0b1AWJBl/EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHz/7a1YI0MaGX+yBuMN72jovzm/FRCPl8Y/3zDiOpoIydVGfOq899RRvti8zyfJJ
	 4pEv9aQ1OKA7wkZT94hnXM8lj1+ilNgVnwmQQ3d4/8x+phdpuZ5wo7wt1sUsqmF3JO
	 uNbZa05rIdKr/IHhc8EPIB46sG5Ifp2s/wgg/8dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 705/816] dm snapshot: split discards on chunk boundaries
Date: Wed, 25 Nov 2026 15:37:33 +0100
Message-ID: <20261125143905.497534552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

commit 4fe2c2baad01da64d47f1a0c8fc093df994bcef5 upstream.

dm-snapshot did not set ti->max_discard_granularity when it allows
discards, so a discard could reach the target unaligned, or spanning
several chunks.  Set the flag, so dm splits discards on chunk
boundaries.

Fixes: 2e6023850e17 ("dm snapshot: add optional discard support features")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-snap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1364,8 +1364,10 @@ static int snapshot_ctr(struct dm_target
 
 	ti->private = s;
 	ti->num_flush_bios = num_flush_bios;
-	if (s->discard_zeroes_cow)
+	if (s->discard_zeroes_cow) {
 		ti->num_discard_bios = (s->discard_passdown_origin ? 2 : 1);
+		ti->max_discard_granularity = true;
+	}
 	ti->per_io_data_size = sizeof(struct dm_snap_tracked_chunk);
 
 	/* Add snapshot to the list of snapshots for this origin */


