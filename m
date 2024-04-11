Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0B11422C4;
	Thu, 11 Apr 2024 10:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829853; cv=none; b=BwNL+oFMl/JlINCkrXAEoWhkdiRNm0uzw3TQhxhJ2624His/YNCbUqgtfJ2uxgqyamchkKBXAfAuWJLlR+KIYrbOFeH5PfwR90PDgHWu8fIXsR7fMucL085ZS30t3j/bgMPEo2t+0krDZ1kjnbd9DGyNMsYWdEdwVfe13iok6Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829853; c=relaxed/simple;
	bh=0fYX16WN25ghJGIO4jIgzDwjRTEpSc6penTLr1Q4u94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tILKg9E6Kyep804nR99QQyrgFUpEK8cJR0QUeyvRE5syPzQ5hYQ1OAh2nUVM77pjz6QKgoabLKytKAkH5g1iB5bONczA8Tnqq5aDAXBRyxOUY0O1FPJRNcYfUsbFwxmR6o080j86vN9FEmR2H+ZSNsqTf7AcbQVgzGwoFCI0C/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoTniZLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoTniZLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE85C433C7;
	Thu, 11 Apr 2024 10:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829852;
	bh=0fYX16WN25ghJGIO4jIgzDwjRTEpSc6penTLr1Q4u94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoTniZLqp5Mi3/SfdMfJQYcTna17RtixlBLtxcxiCvESGTdB2E1Tj01ySsWm37ewx
	 Efy95MtxIepy8Fu53iUpe8FvLkYToFrRd7+7OJhy9W1sfwIgLK9Vyt74UeN/iPKDsU
	 a3+rTOHNRVBiemEhYxRLknOXA2o+wlDsHXZ8mWGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yangxi Xiang <xyangxi5@gmail.com>,
	Kuntal Nayak <kuntal.nayak@broadcom.com>
Subject: [PATCH 4.19 079/175] vt: fix memory overlapping when deleting chars in the buffer
Date: Thu, 11 Apr 2024 11:55:02 +0200
Message-ID: <20240411095421.941153311@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


