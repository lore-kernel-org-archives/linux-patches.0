Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215489;
	b=AU6TFzbX1VULCqwBgqH7y/xZZCK7JNVOXQr5sBvk4AImUOrhwVMhCwNc1K87yYG1STZZ
	 iybfYNPJFFNQvkMychKwzYMc23BWzJZ+WcDz+EMc7VpgOuN5daHH3h4JpcfxIc1lSfdpq
	 hPMzol45k0wl4DsDwK2cIlxUnZBTkcGx2vNDq90PLEdilm0dapkCEi9ymATVcP97pznh1
	 nLi73qKAIsOzACnlPA79G383Dra6MMFoaamqMukp4n5iRJaX1tMhmY8V2eZLUqVCC/GpX
	 2YT4HwEWqfeIhLn2dlo0MrQfWZb9r/z3L7/Dt+yp44RNbBTeXh9ETgDCAfokQl21QiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1sy1oz9D3kYbL5zGdcqpjLvZ03tRXqv7WAghG0bEdg4=;
	b=avdEMPu4A3FC/eyJPxMPK3KVRUhhY4td4xRmtMZQiSjEHt+m//DhW6kDSf0ufrhiiBDa
	 vGw/FQS9WGZv58UWsD8eIwBOyAcgFQp4vRVMYDcjuLHP6sfswqd1uMBWqSRhJzfViikqp
	 KSf0IsfcKLDC9tO41er6GpV+SvFhx9xret9TIjio3y1PmD1ARd80yHEc4p2Yr997vHssW
	 NmtKjtcSeo8DjlcqiOKPt+6bUgi0zbFmkO8W24QchkpYmOxVUhXpPGJ4ebc2IH7ntD/lT
	 EzZitfFwlWABS5d1DkpHdgDfB949qHX0apSLQARUXt49aYCiog60AyDCCvkNi7SHefA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPlZRRXm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E171B606A31A;
	Wed, 28 Oct 2026 19:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPlZRRXm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5691F01825;
	Wed, 28 Oct 2026 19:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215488;
	bh=1sy1oz9D3kYbL5zGdcqpjLvZ03tRXqv7WAghG0bEdg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPlZRRXmrg/rHHe+YDZBLS2OO5jOK+PMlzHXHJc+rv6a0RwQyi8OR3Z/UW2RwFKKy
	 RLjO1j4KOqOIkJCgAvXVQFGBZvoFbCSxKTIDyOTV4SiqITuegLdo61a2OWkx72aLpY
	 QF+qhaNXSESt+cbF9pIlxt6AA2b/AhPUXxGHWHpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1185/1887] firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
Date: Wed, 28 Oct 2026 17:54:41 +0100
Message-ID: <20261028170526.372340681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 3383ffb7ef937317361713ffcc21921a7848511a ]

Sashiko (locally) reports multiple out-of-bound issues in
ffa_setup_and_transmit:
1) Writing ep_mem_access->reserved can write out of bounds for FFA
   versions < 1.2 as ffa_emad_size_get() returns 16 bytes in that case
   while reserved has an offset of 24.
   Instead of zeroing fields, memset the struct to zero first based on
   the FFA version.

2) Make sure there is enough size to write constituents.

While at it, convert the only sizeof() in the driver that uses a
type instead of variable.

Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Fixes: 111a833dc5cb ("firmware: arm_ffa: Set reserved/MBZ fields to zero in the memory descriptors")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Link: https://patch.msgid.link/20260702103848.1647249-2-sebastianene@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 67ab5698a1424..5f0eb6442e9d7 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -554,7 +554,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 			constituents = buffer;
 		}
 
-		if ((void *)constituents - buffer > max_fragsize) {
+		if ((void *)constituents + sizeof(*constituents) - buffer > max_fragsize) {
 			pr_err("Memory Region Fragment > Tx Buffer size\n");
 			return -EFAULT;
 		}
@@ -563,7 +563,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 		constituents->pg_cnt = args->sg->length / FFA_PAGE_SIZE;
 		constituents->reserved = 0;
 		constituents++;
-		frag_len += sizeof(struct ffa_mem_region_addr_range);
+		frag_len += sizeof(*constituents);
 	} while ((args->sg = sg_next(args->sg)));
 
 	return ffa_transmit_fragment(func_id, addr, buf_sz, frag_len,
-- 
2.53.0



