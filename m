Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF2533F586;
	Mon, 20 Apr 2026 16:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701414; cv=none; b=l/wxCYgdgktawvxtDlwEFppJvcgBjp6Y/M4rIcr9IHZinpkc5TsAe2v0wjs2S12ZtryeG3UVapMDa3jVruwj1YKXM8FegMn5h5lbO4DPZIO2uMrIF57mUNcudZW6G4Ypm82Izjf9lriNaWAaJ5/rGedlrhVhI0DRzkt7u2SpGNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701414; c=relaxed/simple;
	bh=Er64kUKQw5Eoy96PC19VHuuOiI5wpLgsYgojeQs6g/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgQ1W5ecsrG/e8e2WrctYspTnA8WyNPw9qFVjyDVcBUzvGTIfddLwiIu4ms9Gf3sze6EEbe1PWw80N1yzbgewDYjoD2cmqyYhLCX8Osl5dh1xNp7ZaHaRt342UzmfbqMeGz2QiG9Y+OTSowQelw2zHKs3AijjLMx8yFOVOPhpyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyNRaF5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyNRaF5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7228C2BCB7;
	Mon, 20 Apr 2026 16:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701414;
	bh=Er64kUKQw5Eoy96PC19VHuuOiI5wpLgsYgojeQs6g/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyNRaF5pdMQT+xrNZnFuN6bKeMGJWiBN1YZfyoYdAedPB1jrxaqBxfhp5t48yDXJx
	 SjnZbJBOJBrjd/VcZTUax7Epo6fJzjPx2h2/f04XGwGIgetgd3x2GT9wkkdJBLv5Rf
	 3ZumXiJu+iY/PDnguIgl3wWVZDTGUlMTmRdh7tao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 104/162] usb: gadget: f_ncm: validate minimum block_len in ncm_unwrap_ntb()
Date: Mon, 20 Apr 2026 17:42:16 +0200
Message-ID: <20260420153930.807453800@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8f993d30b95dc9557a8a96ceca11abed674c8acb upstream.

The block_len read from the host-supplied NTB header is checked against
ntb_max but has no lower bound. When block_len is smaller than
opts->ndp_size, the bounds check of:
	ndp_index > (block_len - opts->ndp_size)
will underflow producing a huge unsigned value that ndp_index can never
exceed, defeating the check entirely.

The same underflow occurs in the datagram index checks against block_len
- opts->dpe_size.  With those checks neutered, a malicious USB host can
choose ndp_index and datagram offsets that point past the actual
transfer, and the skb_put_data() copies adjacent kernel memory into the
network skb.

Fix this by rejecting block lengths that cannot hold at least the NTB
header plus one NDP.  This will make block_len - opts->ndp_size and
block_len - opts->dpe_size both well-defined.

Commit 8d2b1a1ec9f5 ("CDC-NCM: avoid overflow in sanity checking") fixed
a related class of issues on the host side of NCM.

Fixes: 2b74b0a04d3e ("USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Link: https://patch.msgid.link/2026040753-baffle-handheld-624d@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1209,8 +1209,8 @@ parse_ntb:
 
 	block_len = get_ncm(&tmp, opts->block_length);
 	/* (d)wBlockLength */
-	if (block_len > ntb_max) {
-		INFO(port->func.config->cdev, "OUT size exceeded\n");
+	if ((block_len < opts->nth_size + opts->ndp_size) || (block_len > ntb_max)) {
+		INFO(port->func.config->cdev, "Bad block length: %#X\n", block_len);
 		goto err;
 	}
 


