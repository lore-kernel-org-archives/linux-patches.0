Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36327188701;
	Fri, 15 Nov 2024 06:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653024; cv=none; b=CsJXVBbOeOTCUfiN+nvsua/gFATndgoK4iHqEZtnxh6xt4xUmE4ydJ6XQwHjvVYjwWb5i+HG7FB2sl1/J296KQxVWWY6DWOSEzNS4ZO1PtuY+0p55geOwsJqAFAi3ywqi1I1uL1JwBR8jsmhoxwxy03cbzLi++lhn6ewfA9StdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653024; c=relaxed/simple;
	bh=oKAPjPwbgxXM9R0sQF1uD1+nLokmFH5t430inA9VAYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAXOAYW+84/JDjH0qWFRGfEY2Og2eR7/8AyTKKwECAnz48hDBhAgBpdQms+1eb8QVWJRwvX4kUPsSIKTFXhjl2UhhtJoFGeFy9Gc8MObh/8p1DHtUnmKh/Al30hLAMDskcscr8Y7M7m//aFe1BkuW3WwmA0OcIwzkidpvn8KXqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XV8pvCPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XV8pvCPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4456C4CECF;
	Fri, 15 Nov 2024 06:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653024;
	bh=oKAPjPwbgxXM9R0sQF1uD1+nLokmFH5t430inA9VAYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XV8pvCPzfcMe7pz6VMFuVu2fMmE9STFQieMMWpF4nQWoYIHMHajlDP3UZ9zlx8Cfn
	 42gPrLUQEbv0UcrsqsvVrq7Pg3OPQtVnM/k1K4tBwdszvKydVrVe8LMEI6ohLXCdoM
	 XrMhcydKIlA1K6w6pkkcG117ntyO1depcdKNG+74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.4 31/66] dm-unstriped: cast an operand to sector_t to prevent potential uint32_t overflow
Date: Fri, 15 Nov 2024 07:37:40 +0100
Message-ID: <20241115063723.966048965@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zichen Xie <zichenxie0106@gmail.com>

commit 5a4510c762fc04c74cff264cd4d9e9f5bf364bae upstream.

This was found by a static analyzer.
There may be a potential integer overflow issue in
unstripe_ctr(). uc->unstripe_offset and uc->unstripe_width are
defined as "sector_t"(uint64_t), while uc->unstripe,
uc->chunk_size and uc->stripes are all defined as "uint32_t".
The result of the calculation will be limited to "uint32_t"
without correct casting.
So, we recommend adding an extra cast to prevent potential
integer overflow.

Fixes: 18a5bf270532 ("dm: add unstriped target")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-unstripe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -84,8 +84,8 @@ static int unstripe_ctr(struct dm_target
 	}
 	uc->physical_start = start;
 
-	uc->unstripe_offset = uc->unstripe * uc->chunk_size;
-	uc->unstripe_width = (uc->stripes - 1) * uc->chunk_size;
+	uc->unstripe_offset = (sector_t)uc->unstripe * uc->chunk_size;
+	uc->unstripe_width = (sector_t)(uc->stripes - 1) * uc->chunk_size;
 	uc->chunk_shift = is_power_of_2(uc->chunk_size) ? fls(uc->chunk_size) - 1 : 0;
 
 	tmp_len = ti->len;


