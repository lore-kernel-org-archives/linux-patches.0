Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD72445C70B;
	Tue, 25 Aug 2026 13:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665981; cv=none; b=VbJdY7unVVmgsWNiTuxrkct1R3UiEPvjsDRifsvN37tspsACZZ9r6THA6fSk7JWHax79vbl/pH8CNR7fMrgp9MNYGbLeriyklBR/rl/LqQQNiSxCvfuBHipj5sbLbtsnQHAxyDC6Sq1I3FZir6F/4CIfgWbTMy3OT8xGSTOJFDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665981; c=relaxed/simple;
	bh=obxoiBp0T+NN6zIAFUGsHXd2Cd+7JGOXz10jmMD4xS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKbREuiV7q0Wpo7wKUcr8WcU5HC98ejoif9pwWF+OZSr63S11H+QGSjnVZABA9aTchwyno4ZpUwsb8t3sPrW/4yyqYVdzn7mzc++KuMlLuvj+ECJweC+mOqJ4dUZgyVrPkZStrWBobhLdHIbfMj/vrwz0NTuIh11rDBFuEeolZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9KhJn/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9KhJn/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F84B1F000E9;
	Tue, 25 Aug 2026 13:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665979;
	bh=z94dBFuqGG/pl6dLMg0N9buUZzEFlf/5hYlHVIjaqEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9KhJn/7QoqButBNCa6LFqAsQCGR0boyL6de5JYtnHbTKTnyydsB3GPaqMGteZHsh
	 SHHS6JKsloW4Wi7MrU0AB3fyFXWHwdHJ+aFi2z2Zc54cvzC2P8A4JxoBNfrbc2e0Jg
	 8GE0WRANcULmsxFFZCYdRCMcrU2fxM/wqvjJT53o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	syzbot@syzkaller.appspotmail.com,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 6.1 41/79] iomap: adjust read range correctly for non-block-aligned positions
Date: Tue, 25 Aug 2026 15:26:21 +0200
Message-ID: <20260825132543.316554020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

commit 7aa6bc3e8766990824f66ca76c19596ce10daf3e upstream.

iomap_adjust_read_range() assumes that the position and length passed in
are block-aligned. This is not always the case however, as shown in the
syzbot generated case for erofs. This causes too many bytes to be
skipped for uptodate blocks, which results in returning the incorrect
position and length to read in. If all the blocks are uptodate, this
underflows length and returns a position beyond the folio.

Fix the calculation to also take into account the block offset when
calculating how many bytes can be skipped for uptodate blocks.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Tested-by: syzbot@syzkaller.appspotmail.com
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -107,17 +107,24 @@ static void iomap_adjust_read_range(stru
 	 * to avoid reading in already uptodate ranges.
 	 */
 	if (iop) {
-		unsigned int i;
+		unsigned int i, blocks_skipped;
 
 		/* move forward for each leading block marked uptodate */
-		for (i = first; i <= last; i++) {
+		for (i = first; i <= last; i++)
 			if (!test_bit(i, iop->uptodate))
 				break;
-			*pos += block_size;
-			poff += block_size;
-			plen -= block_size;
-			first++;
+
+		blocks_skipped = i - first;
+		if (blocks_skipped) {
+			unsigned long block_offset = *pos & (block_size - 1);
+			unsigned bytes_skipped =
+				(blocks_skipped << block_bits) - block_offset;
+
+			*pos += bytes_skipped;
+			poff += bytes_skipped;
+			plen -= bytes_skipped;
 		}
+		first = i;
 
 		/* truncate len if we find any trailing uptodate block(s) */
 		for ( ; i <= last; i++) {


