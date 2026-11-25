Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620341;
	b=B022pwShdk3GXJjAoewZ7hHyMGbEy9VlVLDnOT6wjVQdbBnQIIqvv9p1hT5i1dUBZlNZ
	 9F5G+We84rNUgiXDo/l6mcWZjiAGUXFF0eYRqdXoD3GyHOGWNNybOSW+EQcmkvoR9YRgX
	 YZzNaceI1Q8c3EG2+dYh4AOKhu5geNbrbKYS4C36cBN18b5HGnlHwrCcVE/1qmIoFGLrD
	 JYXwNqm+h/e+tpnOUai+yRrrEav7Tgn0VdDtUJZNtwXoU8Csy8myc0i5QSijMFV6WDFeL
	 OkdMkRre35ip/oNuueWeUnT7+S9qDfSKRUc1w1b6X8D+jShUQE+dfE5JCMBc4QF6tnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5HyryQSyG/8wabaTrwQKjn+eIqeWL3DuOCKNDNamuuo=;
	b=bNFPg4AwREonFE1xaWMECOV9m+mTet/qHcI6p0LIb0i3wH3Zi/Nclg03PV77xTv3nLIQ
	 /oZvth/KNl0CVhuRWsIHwVzaA5mJd1wyl8900Jpizs7nckWc5OG8H7YVoDkt7OAdVC3dA
	 N93786zP6cHh+PtlsHRVXU97Iw9HnfJl0wPb8r88CM8NXftVHQU3FGvrW1du/0s+9PHvz
	 ZPXfN88m4EoJ1XuLJ5+1wtZhrUdfOysOmcPTm4zHi684NEipTWKO24v8pEXgeRdJzsEav
	 Wa1IahiKx59nFSm4F8QV8aV+iIC9mWVl15fzWEm1naBOqkjsiV63DRo8BGs8E2PEtaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6dVNtCX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8472606A31E;
	Wed, 25 Nov 2026 15:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6dVNtCX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982F71F000CF;
	Wed, 25 Nov 2026 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620341;
	bh=5HyryQSyG/8wabaTrwQKjn+eIqeWL3DuOCKNDNamuuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6dVNtCXZt8oyNPcKYvXBAYZrVeysWMdlSPoDm3Q/hcNFSnFC50OHgzHhplk19+1p
	 pRmya2Ov8Irlmw0VICuCLvj/z9bUsDwPRMIV3zo190L0Dvqbh64RWvP6bA7/n0Z4xr
	 ZAU7MUXzVvcfFLYDL21Ni7D5gbL/KeAx2zIhqMHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0883/1005] dm-thin: fix data corruption if discard races with regular I/O
Date: Wed, 25 Nov 2026 15:37:01 +0100
Message-ID: <20261125143842.387046590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 62ee9c09366cad69410330087d990e469dd92314 upstream.

In the function break_up_discard_bio, if a discard hits the same block as
regular I/O, it was intended to skip the discard for the affected range.
However, the skip code only advances "data_begin", it doesn't advance
"virt_begin". So, the data_begin and virt_begin variables become
unsynchronized.

process_prepared_discard_passdown_pt1 calculates "data_end =
m->data_block + (m->virt_end - m->virt_begin);" - if m->data_block is
incremented and m->virt_begin isn't, it will overshoot the intended
discard range.

Cc: stable@vger.kernel.org
Fixes: e2dd8aca2d76 ("dm bio prison v1: improve concurrent IO performance")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1703,6 +1703,7 @@ static void break_up_discard_bio(struct
 			(void) build_key(tc->td, PHYSICAL, data_begin, data_begin + len, &data_key);
 			if (bio_detain(tc->pool, &data_key, NULL, &data_cell)) {
 				/* contention, we'll give up with this range */
+				virt_begin += len;
 				data_begin += len;
 				continue;
 			}


