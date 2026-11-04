Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828901;
	b=u81lj4edUeozqjaHfRA8AUq9Kgq2Cx8GF9wzkctBrwC98jb8S5CtKnRkq+3J8iiyIbDz
	 WCxjMU6Is0v4nFJW7Nen/z6IMOEjb4XtZ8JIM9js2eFNizz74w+k6KVBotjGK7nAIuJgx
	 GHZqiE5Ij/FEPEjPqm2xkDJtx4in0VIOpbZi6AbEv1khlxKMNhZZ0t8MLee6NaTLUjmit
	 AtJSfOIDgvtOwqm5JUyS9fgyWBVVQ0FMAaH8iFhRsNstSbstOjm4fBYZ2q+LseHjrs1TQ
	 pJRwvksa37zuXL4/o6ekNcknt9JGat8LOZ2LFZjyQhlzq/SKbcZ15DmAlKrMKt5WFzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xXC3fVIec+SnbK6OkMXVdDME+kYU9TFUYOA7iNFFj24=;
	b=EDR+jJ3zsVApZeHaX+GptJDQyuKQmXWpKrrBVtWr9f+/z/+Ef6D6bz8sDQUy0TmBFEjA
	 J2OpKQuObBiYrSR1JXo02au1e3upEjHyBc9EC6l2q07PqVZOoffR/w60wlFhUml0bP2/Y
	 VFvBS6oVuD5ppL509ZfsQwBEE+mlXfOXNRnXJME4T0sxxxO1Jp6lmkSuFlRvH/f+f0A45
	 opbFfbjWJHZtAtkgHJtzHYliBJl5lxt15vLgfkz+XWPtpA4imec7tags94549wlaadjzj
	 qe16gMSkuVIV28xrhetuajHOzMYZOeSe+Cs3GDqXTCi7G0bo3HXLOg+Oq7dQ7T3Nb3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K76BIYoL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A549F606A33A;
	Wed,  4 Nov 2026 21:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K76BIYoL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD731F000C1;
	Wed,  4 Nov 2026 21:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828900;
	bh=xXC3fVIec+SnbK6OkMXVdDME+kYU9TFUYOA7iNFFj24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K76BIYoLs8TXZUUfW9KfTZ6d0rts0pjJkSQVEOTm3FHgE3HstGwQ8fdYjWAtzUeM2
	 WFhgpCvxh73UfEfs0wq54Cu38vyoE7F6G1Ku1Fd+Qh8yfY0RbXxFzgx+hfWOuBnH4Q
	 AsrkymOHy6U5otgIQPtNVVClbIWG2XWZeRUI7dr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 314/547] xfs: zero out di_metatype when removing the metadir file iflag
Date: Wed,  4 Nov 2026 16:08:18 -0500
Message-ID: <20261104211047.134819146@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit f5b4d8c8ce16675f77c25a4ff06caaa9a2739f31 upstream.

LOLLM pointed out that we should zero di_metatype (fka di_onlink) when
we're clearing the METADIR inode flag because the file is no longer a
metadata file.

Cc: stable@vger.kernel.org # v6.13
Fixes: 7297fd0bebbd70 ("xfs: enforce metadata inode flag")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -579,8 +579,10 @@ xrep_dinode_flags(
 
 		fa = xfs_dinode_verify_metadir(sc->mp, dip, mode, flags,
 				flags2);
-		if (fa)
+		if (fa) {
 			flags2 &= ~XFS_DIFLAG2_METADATA;
+			dip->di_metatype = cpu_to_be16(XFS_METAFILE_UNKNOWN);
+		}
 	}
 
 	dip->di_flags = cpu_to_be16(flags);


