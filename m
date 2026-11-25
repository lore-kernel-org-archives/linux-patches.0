Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625984;
	b=WdA923RXO4kgr0dZIvJrSe9cgFfZiX0hAmngjmHePRsETep/GylOFVL+v5C+zGECt5i/
	 hNxlLKUDY7f/OGibiuPJ4qEdIP/42b7n/bFud8cV8cbCMXzcOJ8l+8QOqRygYKCHS9IZn
	 55G9/exx8IXX3Z0aefIubYOwV7B2kuhMIow6hMY+1vzbKAgK4eEs7/Dwwd8tLXWheCrls
	 nS0PDOZNZGcRYmIJ7AaJDKJUw5cRw7oOdn4g6CyRIApvpIi7wCvqm7Krrg6UQD8OTQFcM
	 5tT3gVx2hU/7fuLW85DE5vc5+c6Lqewd7BSohSsU1JMVOVPdek8xyUDipGxAS4hkUzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MWMzctNGx2RSRu2X3nKxVumPkpg2Ln2o1sVtZ7YJ1Tc=;
	b=WorUgDXk/uRYyysJnzIrgQ3JKPm7x5DfzmJ9ALXN7W6AwUEVVRSe4/GRGMQy9vEsCWLq
	 r3OaoHcHbFM7K3nKgS0AqiC70oMgpPwKPNFwFp2/FN2WKE9B2XDQ4LjgaVU73NwXa8JUG
	 KshVEM7oUavEJ8HeEr/0SItDAej/kNPwHDyo742e1Yvx3d70PNVLCCShwEmgzO9T5tHi5
	 FnKrtSTvY3l6mtildkI3HU/vdEsln2YtITDeWwpu/hadA9Zd+BMUZMF9oeNCp2nhbI296
	 C98dvGgSW/ZzUri9LcZH01Xw/PYHcwvzVS8gsF9vQin0SqHOuuq4ce7aYwISQNpYfCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gBCJgpjH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5081D606A326;
	Wed, 25 Nov 2026 16:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gBCJgpjH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2943D1F000C0;
	Wed, 25 Nov 2026 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625983;
	bh=MWMzctNGx2RSRu2X3nKxVumPkpg2Ln2o1sVtZ7YJ1Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBCJgpjHbgnQBoiS86FrE4sKB4rSFi6iE5uv4Szo+N5groun71JsYBjiFW+/Nu5k/
	 Q1i5NoMLViFiLP9gSAKA+P+EBhdJnYY1to7EIxr0q6D08HrC4x7Wm7wsBBGjFNyC2v
	 76tD9LFGVrD20jMecEoPiBQq70noXDAOYNklqrkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaohan Li <shunsheng1218@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 692/816] dm: avoid double-dropping the zone reset submission reference
Date: Wed, 25 Nov 2026 15:37:20 +0100
Message-ID: <20261125143905.203441991@linuxfoundation.org>
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

From: Yaohan Li <shunsheng1218@gmail.com>

commit c4965effbe15f837a8089e79c0fc17ab19363cce upstream.

On an error in __send_zone_reset_all(), the submission reference
held by the dm_io can be decremented there and again by the caller's
error path. If another clone is still outstanding, the second drop
can release the dm_io before that clone completes.

Only drop the submission reference in __send_zone_reset_all() on
success. On failure, leave the reference for the caller's existing
error handling to release once.

The error path was reproduced under KASAN with an injected GFP_NOIO
allocation failure while another zone-reset clone remained in
flight. With the change, the same failure was reported normally,
without the observed use-after-free, and ordinary zone resets
continued to work.

Fixes: 81e7706345f06 ("dm: handle REQ_OP_ZONE_RESET_ALL")
Cc: stable@vger.kernel.org
Assisted-by: ZCode:GLM-4
Signed-off-by: Yaohan Li <shunsheng1218@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1945,8 +1945,13 @@ static blk_status_t __send_zone_reset_al
 			break;
 	}
 
-	/* Release the reference that alloc_io() took for submission. */
-	atomic_sub(1, &ci->io->io_count);
+	/*
+	 * Release the reference that alloc_io() took for submission. On error,
+	 * that reference was not consumed: dm_split_and_process_bio() releases
+	 * it on the error path, so do not release it here a second time.
+	 */
+	if (sts == BLK_STS_OK)
+		atomic_dec(&ci->io->io_count);
 
 	return sts;
 }


