Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625B9145FF0;
	Thu, 11 Apr 2024 10:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830880; cv=none; b=FMzk4ZXBpGQHvoSqwjmn4QZxg3JWVOe6NIWH47JYgKIklxYJT0s9tYQerZvcYBL0F08oc6hZZDJ4azWmL4g1k+ftYUkBzqi9ob3Lz34SeV8ndgwRwA6Y6/aqetI8K+z9jDM5j/fD2tlUysFvowBl71OfdBRmjdxKGWGetYeWfJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830880; c=relaxed/simple;
	bh=SWH1pUAgIX2iyqiAs6li9ABqhuoinZuDu46e+qZ3vg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZqvZkqqEapYhKARF+6S5866pwc6hBCq1TAHMAf10z9MUWwsfevbaHaARk1Duwm8b3lgI4LO2ECnEES7GzdLEr6XsxLHjHvbRx6Rx3ZXxP4UqbPVqWhdPl+JVcvVHPFZvMcmdUoZ4Ip0Lqge3rrL4NCt+K6nAf02ha2KBXGkSGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPYzvqEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPYzvqEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B55C433C7;
	Thu, 11 Apr 2024 10:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830879;
	bh=SWH1pUAgIX2iyqiAs6li9ABqhuoinZuDu46e+qZ3vg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPYzvqEFuJ3g0/p5v7qhv0d9HtBVCEc/LCB5xbnyZ3OMj1HlMxWM4KoW/bgZzg5Mm
	 8PdEC0k9X8eZcy6jPi8sWMazrR2sDo91Y41dioc71X2myESeMfkbAlSGrGRAB7OaEc
	 x72JVsGQLUDQ9M/Ay7fyCM3tJR2qPfA4IPfGSrA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yangxi Xiang <xyangxi5@gmail.com>,
	Kuntal Nayak <kuntal.nayak@broadcom.com>
Subject: [PATCH 5.4 110/215] vt: fix memory overlapping when deleting chars in the buffer
Date: Thu, 11 Apr 2024 11:55:19 +0200
Message-ID: <20240411095428.214925957@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: Yangxi Xiang <xyangxi5@gmail.com>

commit 39cdb68c64d84e71a4a717000b6e5de208ee60cc upstream.

A memory overlapping copy occurs when deleting a long line. This memory
overlapping copy can cause data corruption when scr_memcpyw is optimized
to memcpy because memcpy does not ensure its behavior if the destination
buffer overlaps with the source buffer. The line buffer is not always
broken, because the memcpy utilizes the hardware acceleration, whose
result is not deterministic.

Fix this problem by using replacing the scr_memcpyw with scr_memmovew.

Fixes: 81732c3b2fed ("tty vt: Fix line garbage in virtual console on command line edition")
Cc: stable <stable@kernel.org>
Signed-off-by: Yangxi Xiang <xyangxi5@gmail.com>
Link: https://lore.kernel.org/r/20220628093322.5688-1-xyangxi5@gmail.com
[ KN: vc_state is not a separate structure in LTS v4.19, v5.4. Adjusted the patch
  accordingly by using vc_x instead of state.x for backport. ]
Signed-off-by: Kuntal Nayak <kuntal.nayak@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -855,7 +855,7 @@ static void delete_char(struct vc_data *
 	unsigned short *p = (unsigned short *) vc->vc_pos;
 
 	vc_uniscr_delete(vc, nr);
-	scr_memcpyw(p, p + nr, (vc->vc_cols - vc->vc_x - nr) * 2);
+	scr_memmovew(p, p + nr, (vc->vc_cols - vc->vc_x - nr) * 2);
 	scr_memsetw(p + vc->vc_cols - vc->vc_x - nr, vc->vc_video_erase_char,
 			nr * 2);
 	vc->vc_need_wrap = 0;


