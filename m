Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773CA45BE3;
	Fri,  6 Dec 2024 14:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496326; cv=none; b=BO5yihBzgL3Vhor95wSnpcOYGyrOiKZO6j6mw2427zVpeLWnlmJizefg2qKUYFhJb5+V4tQxCOM4MownKCE/IhAL701YEMyMAaUjyMWS9S9449eLHufmvfH5hixL4voqvgNph6Y/DjcaziNqN/gRUdPsCRylLxakBhF7cU/P7LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496326; c=relaxed/simple;
	bh=A/3XTpnvTuoXBIeNUFYtdzP9K2un/ONr54Yko/OuiYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQRBR7U20dLgBBmakelcnL/4Ea3pp4JTCUb3RzA2Fk4qRIyDj9MK6884/6k64iy+ldr6mVAGSSTk7q+b8gfMpBDkPTugTnMfMcuJdE/5fkMWi7VCKtBo69g0LaDF92hesEV5HBQzKvahuZ2PwMEY499H2cURGS8lPVFfgbVyluc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCGzjZpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCGzjZpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA876C4CED1;
	Fri,  6 Dec 2024 14:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496326;
	bh=A/3XTpnvTuoXBIeNUFYtdzP9K2un/ONr54Yko/OuiYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCGzjZpW14qYnUpKMvqVDezjX2l1K9vvgiboguYNc6BIdCo+dQIukoZQEe7cjJoyf
	 aZvZDHL+gvJWZlPnyURPdum1EvdLS+C+PLT1JNGCz05xu36eYBKLH7LFZjeZur+eus
	 q/fB3/8FpwxzJHxgnVLt7kgk7B+R6+OgTBzOVu0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 088/146] slab: Fix too strict alignment check in create_cache()
Date: Fri,  6 Dec 2024 15:36:59 +0100
Message-ID: <20241206143531.045229400@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 9008fe8fad8255edfdbecea32d7eb0485d939d0d upstream.

On m68k, where the minimum alignment of unsigned long is 2 bytes:

    Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
    CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-atari-03776-g7eaa1f99261a #1783
    Stack from 0102fe5c:
	    0102fe5c 00514a2b 00514a2b ffffff00 00000001 0051f5ed 00425e78 00514a2b
	    0041eb74 ffffffea 00000310 0051f5ed ffffffea ffffffea 00601f60 00000044
	    0102ff20 000e7a68 0051ab8e 004383b8 0051f5ed ffffffea 000000b8 00000007
	    01020c00 00000000 000e77f0 0041e5f0 005f67c0 0051f5ed 000000b6 0102fef4
	    00000310 0102fef4 00000000 00000016 005f676c 0060a34c 00000010 00000004
	    00000038 0000009a 01000000 000000b8 005f668e 0102e000 00001372 0102ff88
    Call Trace: [<00425e78>] dump_stack+0xc/0x10
     [<0041eb74>] panic+0xd8/0x26c
     [<000e7a68>] __kmem_cache_create_args+0x278/0x2e8
     [<000e77f0>] __kmem_cache_create_args+0x0/0x2e8
     [<0041e5f0>] memset+0x0/0x8c
     [<005f67c0>] io_uring_init+0x54/0xd2

The minimal alignment of an integral type may differ from its size,
hence is not safe to assume that an arbitrary freeptr_t (which is
basically an unsigned long) is always aligned to 4 or 8 bytes.

As nothing seems to require the additional alignment, it is safe to fix
this by relaxing the check to the actual minimum alignment of freeptr_t.

Fixes: aaa736b186239b7d ("io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache")
Fixes: d345bd2e9834e2da ("mm: add kmem_cache_create_rcu()")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net
Cc: <stable@vger.kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -230,7 +230,7 @@ static struct kmem_cache *create_cache(c
 	if (args->use_freeptr_offset &&
 	    (args->freeptr_offset >= object_size ||
 	     !(flags & SLAB_TYPESAFE_BY_RCU) ||
-	     !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
+	     !IS_ALIGNED(args->freeptr_offset, __alignof__(freeptr_t))))
 		goto out;
 
 	err = -ENOMEM;


