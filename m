Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0803FD4;
	Mon, 23 Jun 2025 21:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715257; cv=none; b=YfBuFwXc63W29MpAyF8num7ASN2DSAHAcg5GUyXAwmj8+tNLVefLssMp6kaNldThNlWZExCs4cwQptTB95msRYgoO9eGfvkKDl3H7sSNbcExxMqH2R//p1+rTi+wktVf+NWVwPqnVHunvcZiMytaLW34AZIiVQ4Q7jJ6qhd21AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715257; c=relaxed/simple;
	bh=3ACiB5gmA0LsUvKC47YYA19vhBUCPo+gK2ifjsHHbc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZ+Hsi7FEzyZxkiYz+HPiEi4Van7xhaq/ydRkG29Kzm5HXE2ZpRcWWZ6eEIoxM66w9ZjqVVNSAF+ckt2AxAwDC2bWoCYvrsRcaUqO2iLdSmTQbWdA1QcHkFhV0LLWw8gpIyyb30/pTO46J/2jp3G6Ip1tlz2++43d8ytT4spMVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zfh8YMdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zfh8YMdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B885AC4CEEA;
	Mon, 23 Jun 2025 21:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715257;
	bh=3ACiB5gmA0LsUvKC47YYA19vhBUCPo+gK2ifjsHHbc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zfh8YMdoQTGYjm9GMkuXCbodN3wtHbJV+9DZ+DYGVC1QL+EN3Fmqetb344i/d5/3y
	 b2E18tJ169CNqzPUaJoAWcZkymlIOoOCd1+orDMTE3wCbEiTbjLWfbxi1d2Dw0CV7W
	 BSfvfC5ZMB3wMfo/saDk5Xa2LZwbnmvYMZZhL3Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	maher azz <maherazz04@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 447/592] drivers/rapidio/rio_cm.c: prevent possible heap overwrite
Date: Mon, 23 Jun 2025 15:06:45 +0200
Message-ID: <20250623130711.062261389@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 50695153d7ddde3b1696dbf0085be0033bf3ddb3 upstream.

In

riocm_cdev_ioctl(RIO_CM_CHAN_SEND)
   -> cm_chan_msg_send()
      -> riocm_ch_send()

cm_chan_msg_send() checks that userspace didn't send too much data but
riocm_ch_send() failed to check that userspace sent sufficient data.  The
result is that riocm_ch_send() can write to fields in the rio_ch_chan_hdr
which were outside the bounds of the space which cm_chan_msg_send()
allocated.

Address this by teaching riocm_ch_send() to check that the entire
rio_ch_chan_hdr was copied in from userspace.

Reported-by: maher azz <maherazz04@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio_cm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/rapidio/rio_cm.c
+++ b/drivers/rapidio/rio_cm.c
@@ -789,6 +789,9 @@ static int riocm_ch_send(u16 ch_id, void
 	if (buf == NULL || ch_id == 0 || len == 0 || len > RIO_MAX_MSG_SIZE)
 		return -EINVAL;
 
+	if (len < sizeof(struct rio_ch_chan_hdr))
+		return -EINVAL;		/* insufficient data from user */
+
 	ch = riocm_get_channel(ch_id);
 	if (!ch) {
 		riocm_error("%s(%d) ch_%d not found", current->comm,


