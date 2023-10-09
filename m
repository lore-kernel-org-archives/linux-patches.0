Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E297F339B4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXIWKrOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8ABC433C8;
	Mon,  9 Oct 2023 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859130;
	bh=mu4Odup+feenunaCqgHgw/8oPjUdaSurpJkjoR4be5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXIWKrOw622oL4afcGgK+p/JCN5OnZ0tSZMpPpn2U1CYFqg/+24PRZNgo1M3WNHqL
	 bosmIpM9sqvvDeOBtkThFNUEbQgEUcanalMaC3KQwwQHoK1BBn8Vt2/fpTiFehMrzR
	 ubukIC/S2G5Bn7kFzZ8nfoZIEcTMCLrh6ADyloHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.10 181/226] wifi: mwifiex: Fix tlv_buf_left calculation
Date: Mon,  9 Oct 2023 15:02:22 +0200
Message-ID: <20231009130131.366885671@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit eec679e4ac5f47507774956fb3479c206e761af7 upstream.

In a TLV encoding scheme, the Length part represents the length after
the header containing the values for type and length. In this case,
`tlv_len` should be:

tlv_len == (sizeof(*tlv_rxba) - 1) - sizeof(tlv_rxba->header) + tlv_bitmap_len

Notice that the `- 1` accounts for the one-element array `bitmap`, which
1-byte size is already included in `sizeof(*tlv_rxba)`.

So, if the above is correct, there is a double-counting of some members
in `struct mwifiex_ie_types_rxba_sync`, when `tlv_buf_left` and `tmp`
are calculated:

968                 tlv_buf_left -= (sizeof(*tlv_rxba) + tlv_len);
969                 tmp = (u8 *)tlv_rxba + tlv_len + sizeof(*tlv_rxba);

in specific, members:

drivers/net/wireless/marvell/mwifiex/fw.h:777
 777         u8 mac[ETH_ALEN];
 778         u8 tid;
 779         u8 reserved;
 780         __le16 seq_num;
 781         __le16 bitmap_len;

This is clearly wrong, and affects the subsequent decoding of data in
`event_buf` through `tlv_rxba`:

970                 tlv_rxba = (struct mwifiex_ie_types_rxba_sync *)tmp;

Fix this by using `sizeof(tlv_rxba->header)` instead of `sizeof(*tlv_rxba)`
in the calculation of `tlv_buf_left` and `tmp`.

This results in the following binary differences before/after changes:

| drivers/net/wireless/marvell/mwifiex/11n_rxreorder.o
| @@ -4698,11 +4698,11 @@
|  drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c:968
|                 tlv_buf_left -= (sizeof(tlv_rxba->header) + tlv_len);
| -    1da7:      lea    -0x11(%rbx),%edx
| +    1da7:      lea    -0x4(%rbx),%edx
|      1daa:      movzwl %bp,%eax
|  drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c:969
|                 tmp = (u8 *)tlv_rxba  + sizeof(tlv_rxba->header) + tlv_len;
| -    1dad:      lea    0x11(%r15,%rbp,1),%r15
| +    1dad:      lea    0x4(%r15,%rbp,1),%r15

The above reflects the desired change: avoid counting 13 too many bytes;
which is the total size of the double-counted members in
`struct mwifiex_ie_types_rxba_sync`:

$ pahole -C mwifiex_ie_types_rxba_sync drivers/net/wireless/marvell/mwifiex/11n_rxreorder.o
struct mwifiex_ie_types_rxba_sync {
	struct mwifiex_ie_types_header header;           /*     0     4 */

     |-----------------------------------------------------------------------
     |  u8                         mac[6];               /*     4     6 */  |
     |	u8                         tid;                  /*    10     1 */  |
     |  u8                         reserved;             /*    11     1 */  |
     | 	__le16                     seq_num;              /*    12     2 */  |
     | 	__le16                     bitmap_len;           /*    14     2 */  |
     |  u8                         bitmap[1];            /*    16     1 */  |
     |----------------------------------------------------------------------|
								  | 13 bytes|
								  -----------

	/* size: 17, cachelines: 1, members: 7 */
	/* last cacheline: 17 bytes */
} __attribute__((__packed__));

Fixes: 99ffe72cdae4 ("mwifiex: process rxba_sync event")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/06668edd68e7a26bbfeebd1201ae077a2a7a8bce.1692931954.git.gustavoars@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -977,8 +977,8 @@ void mwifiex_11n_rxba_sync_event(struct
 			}
 		}
 
-		tlv_buf_left -= (sizeof(*tlv_rxba) + tlv_len);
-		tmp = (u8 *)tlv_rxba + tlv_len + sizeof(*tlv_rxba);
+		tlv_buf_left -= (sizeof(tlv_rxba->header) + tlv_len);
+		tmp = (u8 *)tlv_rxba  + sizeof(tlv_rxba->header) + tlv_len;
 		tlv_rxba = (struct mwifiex_ie_types_rxba_sync *)tmp;
 	}
 }


