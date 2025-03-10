Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1624231A42;
	Mon, 10 Mar 2025 17:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626753; cv=none; b=cO3vr47zRCuWQ2SlBxXqbCh0zNwSfo1RoaYHKGggxLrIjIbBiTHm/bBrvQBSs3rMincdjpGOgDg3jQ84O3jyfYH21HcY6BD0YLRtSvyqgSEFQZDbZUVj0xrTKiR3eIBTwBz0ai5Wh1CMqCIJOm7ccKOqMFDeP5FuXhU5b9pXQVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626753; c=relaxed/simple;
	bh=r4KVN0nr5nuNTcjhTjsUC5wTrNaQNbjBiL31CqRxB5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ny90jFCsggNJZ1s339zCPU+RPlCduDKDZbtmPzJ79o+JvmdJCCx5JDQu8by2UXYEB8hJHdwu37d0dGWQAzf2Na3yvmz78M6jvjmyGMcS49VIN7BmY/1pHXVuuQ54pGACIMUiOtVCXW66YRfZk02Rcy9o7BG2RRUHdnc0MVar/tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzTQNW6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzTQNW6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69694C4CEE5;
	Mon, 10 Mar 2025 17:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626752;
	bh=r4KVN0nr5nuNTcjhTjsUC5wTrNaQNbjBiL31CqRxB5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzTQNW6TRJIw0nO36cEOdJXUFxhFyGGJofagclDL7X4WTHHodH+HYhafBcppoG+4o
	 2KSmgSZsR+OieqBbvM/97AwiddALGiEW57eA438/UpGQxvltmGdosKDoCPbj67wUOX
	 Odxgdw3aHe1FCY2d2yWQo3ugEM4vrFHR88JcKUnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mulhern <amulhern@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Olivier Gayot <olivier.gayot@canonical.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 073/207] block: fix conversion of GPT partition name to 7-bit
Date: Mon, 10 Mar 2025 18:04:26 +0100
Message-ID: <20250310170450.665666607@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Gayot <olivier.gayot@canonical.com>

commit e06472bab2a5393430cc2fbc3211cd3602422c1e upstream.

The utf16_le_to_7bit function claims to, naively, convert a UTF-16
string to a 7-bit ASCII string. By naively, we mean that it:
 * drops the first byte of every character in the original UTF-16 string
 * checks if all characters are printable, and otherwise replaces them
   by exclamation mark "!".

This means that theoretically, all characters outside the 7-bit ASCII
range should be replaced by another character. Examples:

 * lower-case alpha (ɒ) 0x0252 becomes 0x52 (R)
 * ligature OE (œ) 0x0153 becomes 0x53 (S)
 * hangul letter pieup (ㅂ) 0x3142 becomes 0x42 (B)
 * upper-case gamma (Ɣ) 0x0194 becomes 0x94 (not printable) so gets
   replaced by "!"

The result of this conversion for the GPT partition name is passed to
user-space as PARTNAME via udev, which is confusing and feels questionable.

However, there is a flaw in the conversion function itself. By dropping
one byte of each character and using isprint() to check if the remaining
byte corresponds to a printable character, we do not actually guarantee
that the resulting character is 7-bit ASCII.

This happens because we pass 8-bit characters to isprint(), which
in the kernel returns 1 for many values > 0x7f - as defined in ctype.c.

This results in many values which should be replaced by "!" to be kept
as-is, despite not being valid 7-bit ASCII. Examples:

 * e with acute accent (é) 0x00E9 becomes 0xE9 - kept as-is because
   isprint(0xE9) returns 1.
 * euro sign (€) 0x20AC becomes 0xAC - kept as-is because isprint(0xAC)
   returns 1.

This way has broken pyudev utility[1], fixes it by using a mask of 7 bits
instead of 8 bits before calling isprint.

Link: https://github.com/pyudev/pyudev/issues/490#issuecomment-2685794648 [1]
Link: https://lore.kernel.org/linux-block/4cac90c2-e414-4ebb-ae62-2a4589d9dc6e@canonical.com/
Cc: Mulhern <amulhern@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: stable@vger.kernel.org
Signed-off-by: Olivier Gayot <olivier.gayot@canonical.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250305022154.3903128-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/partitions/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -682,7 +682,7 @@ static void utf16_le_to_7bit(const __le1
 	out[size] = 0;
 
 	while (i < size) {
-		u8 c = le16_to_cpu(in[i]) & 0xff;
+		u8 c = le16_to_cpu(in[i]) & 0x7f;
 
 		if (c && !isprint(c))
 			c = '!';


