Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EE564CC0;
	Thu, 11 Apr 2024 10:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831809; cv=none; b=hg8xvL0FKeQgoDWTqB9mo5UK7YnvSK28sOChJFbbxbIgYkQNyuy2snzEgmt9R6MnkoCnuHDLVWF9Ew16FKlGVfLltSAEEobctY8xbg/I1Ktc9p5nddAzr3zUGRZd81AfQUFB0fTAao4uGnoQhe1UrmXofzc6ao+1sUbdgJJESkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831809; c=relaxed/simple;
	bh=5KRJXDNXti/Guurlf05gIomO6vJefWfuvcFw8Yjp/HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/fZ/QdzoqpWQAvoWcDplqwq04cWFIsYFNKlYGmH360/vY3I8YNYUJl5qNPTySSSSErkTzGTlKc7VO6d1KkpGkl8xxL09JnEbM/BzxPxBziCOeX7Wc1byKbyeTzPjqcStZzNbi/NjVrNIcOAFJ3/+dRKJHMOhCgiIxEuSpTZD5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkzTn4ma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkzTn4ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EDDC433F1;
	Thu, 11 Apr 2024 10:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831808;
	bh=5KRJXDNXti/Guurlf05gIomO6vJefWfuvcFw8Yjp/HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkzTn4maegZFsjV19h9ZdBxmP8j+l30L9bbA37R1UFyPKk/a7jzin/V6SG+CdVz6u
	 H2ETOiE9XYFTRzZIRugixy9EQRUn3bPRfQJJF6u9Lc3OEywVUfvnwAOXML3ah9D24L
	 UZbftSm+/9BnOG/u35dVYLtS8kuAW1bnnx6CT/LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <nico@fluxnic.net>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 132/294] vt: fix unicode buffer corruption when deleting characters
Date: Thu, 11 Apr 2024 11:54:55 +0200
Message-ID: <20240411095439.633084935@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nico@fluxnic.net>

commit 1581dafaf0d34bc9c428a794a22110d7046d186d upstream.

This is the same issue that was fixed for the VGA text buffer in commit
39cdb68c64d8 ("vt: fix memory overlapping when deleting chars in the
buffer"). The cure is also the same i.e. replace memcpy() with memmove()
due to the overlaping buffers.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Fixes: 81732c3b2fed ("tty vt: Fix line garbage in virtual console on command line edition")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/sn184on2-3p0q-0qrq-0218-895349s4753o@syhkavp.arg
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -398,7 +398,7 @@ static void vc_uniscr_delete(struct vc_d
 		char32_t *ln = uniscr->lines[vc->state.y];
 		unsigned int x = vc->state.x, cols = vc->vc_cols;
 
-		memcpy(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
+		memmove(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
 		memset32(&ln[cols - nr], ' ', nr);
 	}
 }


