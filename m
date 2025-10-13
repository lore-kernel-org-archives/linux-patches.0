Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879923148BA;
	Mon, 13 Oct 2025 14:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367246; cv=none; b=edvLRywvMN5ugi63gwuxIyX+4PYBrooCvkIw2avKfT2dsBADQKvzn3AoCPHYgU3kjmjnAQAam0M8wItDmfQNFEIEP1FGro4l08F3X5WBGs+reznNacSHFShXvm5lcI+Bv+riu5UqXpINVDc8460ZTBzwiwbK1n3DXhsud+pQoww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367246; c=relaxed/simple;
	bh=kVADdgyoxBtsiO1zp2+75yla5n9Qc5VwdIjzBoVffFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSEfRy84JA48iR0JF3GG08GoWQJyMI5ndMY8sFIpG16eBeEs768+EDmg8cSzWIXUbrrnqp4hh7xCkr++9Swqav5SnwMlxz1FKvQDddV+JHFWTPcTV7iTH9lYi4aV8M0xuX7pbrqAaoakNfd6Dx0RXxRJrOqYYuzfyIG2Q4zEus4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exjtRQbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exjtRQbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F45EC19421;
	Mon, 13 Oct 2025 14:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367245;
	bh=kVADdgyoxBtsiO1zp2+75yla5n9Qc5VwdIjzBoVffFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exjtRQbBs2ZiTXRjpxc7fAFDKCkeHcPlGQO98fbMnV6qkUhsGOZu1aYmQnXJBFh4v
	 SiF0gT47VsqGihi/cHOZzMt6y7MHErzKiosEP93GdXvu/SHbF5gq0r1sEl4TGkIKdW
	 hf1DIXdBGGpemkpXVR55Uz/u0suTTCQBXqMYnxgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: [PATCH 6.1 142/196] sparc: fix accurate exception reporting in copy_to_user for Niagara 4
Date: Mon, 13 Oct 2025 16:45:15 +0200
Message-ID: <20251013144319.833989006@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

[ Upstream commit 5a746c1a2c7980de6c888b6373299f751ad7790b ]

The referenced commit introduced exception handlers on user-space memory
references in copy_from_user and copy_to_user. These handlers return from
the respective function and calculate the remaining bytes left to copy
using the current register contents. This commit fixes a bad calculation.
This will fix the return value of copy_to_user in a specific faulting case.
The behaviour of memcpy stays unchanged.

Fixes: 957077048009 ("sparc64: Convert NG4copy_{from,to}_user to accurate exception reporting.")
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de> # on Oracle SPARC T4-1
Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20250905-memcpy_series-v4-4-1ca72dda195b@mkarcher.dialup.fu-berlin.de
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/lib/NG4memcpy.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/lib/NG4memcpy.S b/arch/sparc/lib/NG4memcpy.S
index 7ad58ebe0d009..df0ec1bd19489 100644
--- a/arch/sparc/lib/NG4memcpy.S
+++ b/arch/sparc/lib/NG4memcpy.S
@@ -281,7 +281,7 @@ FUNC_NAME:	/* %o0=dst, %o1=src, %o2=len */
 	subcc		%o5, 0x20, %o5
 	EX_ST(STORE(stx, %g1, %o0 + 0x00), memcpy_retl_o2_plus_o5_plus_32)
 	EX_ST(STORE(stx, %g2, %o0 + 0x08), memcpy_retl_o2_plus_o5_plus_24)
-	EX_ST(STORE(stx, GLOBAL_SPARE, %o0 + 0x10), memcpy_retl_o2_plus_o5_plus_24)
+	EX_ST(STORE(stx, GLOBAL_SPARE, %o0 + 0x10), memcpy_retl_o2_plus_o5_plus_16)
 	EX_ST(STORE(stx, %o4, %o0 + 0x18), memcpy_retl_o2_plus_o5_plus_8)
 	bne,pt		%icc, 1b
 	 add		%o0, 0x20, %o0
-- 
2.51.0



