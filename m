Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E84413B2B3;
	Tue, 27 Feb 2024 14:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043368; cv=none; b=i+PrDMoBHBeuByPjZb6w3OD1QFMmhIR/YNNEcWpmCgX2koWpFepKUGcEQtEKY44RdoFdUxHtJQynAG/jwBRJePsnDw57imhCC4HqODPZxSf5BRvl1ZzpLHbSiAXJgjcE851WGp8UjImky7w89jn+xDgSNq+90cKqryK+JSqsBzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043368; c=relaxed/simple;
	bh=9+wLVyX8Qggs+IQr408V3Sni0pBD6I2ARpdgFc2qli4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5EJ3ogxSKGNq6o+Y3M73GqkqSz92UrSIaEqsRTPTlnWuJ7J49rzA6a2teW8B+qODSJvMKd4lG4C1MXZYEDz8QyyyzKFg9FtrdQQxbhZSG/ZrHmAgs3E5tB1TX8ZKzGyQ8otS56/brqaYaguwM6aMugTNcV48o2pFhnndO7jyTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsNm8yW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsNm8yW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1082C433C7;
	Tue, 27 Feb 2024 14:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043368;
	bh=9+wLVyX8Qggs+IQr408V3Sni0pBD6I2ARpdgFc2qli4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsNm8yW+GpMlWwCKNeqjBHitP7Tg0zTCOK5wFatv4VbeXsUIPc6YqpQB9c4GJM7Cr
	 kaf9f9pvt3HJ3AVa5KNbKBWDsBtk1IGoG0G8MJo87JLDb3j8AmbtSjCkS8j4Th8v3X
	 7isBaRJVfL/nwFVqD/TyOWsMA4C5TR/zO0mhRGXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mats Kronberg <kronberg@nsc.liu.se>,
	Daniel Vacek <neelx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.1 083/195] IB/hfi1: Fix sdma.h tx->num_descs off-by-one error
Date: Tue, 27 Feb 2024 14:25:44 +0100
Message-ID: <20240227131613.227628685@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vacek <neelx@redhat.com>

commit e6f57c6881916df39db7d95981a8ad2b9c3458d6 upstream.

Unfortunately the commit `fd8958efe877` introduced another error
causing the `descs` array to overflow. This reults in further crashes
easily reproducible by `sendmsg` system call.

[ 1080.836473] general protection fault, probably for non-canonical address 0x400300015528b00a: 0000 [#1] PREEMPT SMP PTI
[ 1080.869326] RIP: 0010:hfi1_ipoib_build_ib_tx_headers.constprop.0+0xe1/0x2b0 [hfi1]
--
[ 1080.974535] Call Trace:
[ 1080.976990]  <TASK>
[ 1081.021929]  hfi1_ipoib_send_dma_common+0x7a/0x2e0 [hfi1]
[ 1081.027364]  hfi1_ipoib_send_dma_list+0x62/0x270 [hfi1]
[ 1081.032633]  hfi1_ipoib_send+0x112/0x300 [hfi1]
[ 1081.042001]  ipoib_start_xmit+0x2a9/0x2d0 [ib_ipoib]
[ 1081.046978]  dev_hard_start_xmit+0xc4/0x210
--
[ 1081.148347]  __sys_sendmsg+0x59/0xa0

crash> ipoib_txreq 0xffff9cfeba229f00
struct ipoib_txreq {
  txreq = {
    list = {
      next = 0xffff9cfeba229f00,
      prev = 0xffff9cfeba229f00
    },
    descp = 0xffff9cfeba229f40,
    coalesce_buf = 0x0,
    wait = 0xffff9cfea4e69a48,
    complete = 0xffffffffc0fe0760 <hfi1_ipoib_sdma_complete>,
    packet_len = 0x46d,
    tlen = 0x0,
    num_desc = 0x0,
    desc_limit = 0x6,
    next_descq_idx = 0x45c,
    coalesce_idx = 0x0,
    flags = 0x0,
    descs = {{
        qw = {0x8024000120dffb00, 0x4}  # SDMA_DESC0_FIRST_DESC_FLAG (bit 63)
      }, {
        qw = {  0x3800014231b108, 0x4}
      }, {
        qw = { 0x310000e4ee0fcf0, 0x8}
      }, {
        qw = {  0x3000012e9f8000, 0x8}
      }, {
        qw = {  0x59000dfb9d0000, 0x8}
      }, {
        qw = {  0x78000e02e40000, 0x8}
      }}
  },
  sdma_hdr =  0x400300015528b000,  <<< invalid pointer in the tx request structure
  sdma_status = 0x0,                   SDMA_DESC0_LAST_DESC_FLAG (bit 62)
  complete = 0x0,
  priv = 0x0,
  txq = 0xffff9cfea4e69880,
  skb = 0xffff9d099809f400
}

If an SDMA send consists of exactly 6 descriptors and requires dword
padding (in the 7th descriptor), the sdma_txreq descriptor array is not
properly expanded and the packet will overflow into the container
structure. This results in a panic when the send completion runs. The
exact panic varies depending on what elements of the container structure
get corrupted. The fix is to use the correct expression in
_pad_sdma_tx_descs() to test the need to expand the descriptor array.

With this patch the crashes are no longer reproducible and the machine is
stable.

Fixes: fd8958efe877 ("IB/hfi1: Fix sdma.h tx->num_descs off-by-one errors")
Cc: stable@vger.kernel.org
Reported-by: Mats Kronberg <kronberg@nsc.liu.se>
Tested-by: Mats Kronberg <kronberg@nsc.liu.se>
Signed-off-by: Daniel Vacek <neelx@redhat.com>
Link: https://lore.kernel.org/r/20240201081009.1109442-1-neelx@redhat.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/sdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -3158,7 +3158,7 @@ int _pad_sdma_tx_descs(struct hfi1_devda
 {
 	int rval = 0;
 
-	if ((unlikely(tx->num_desc + 1 == tx->desc_limit))) {
+	if ((unlikely(tx->num_desc == tx->desc_limit))) {
 		rval = _extend_sdma_tx_descs(dd, tx);
 		if (rval) {
 			__sdma_txclean(dd, tx);


