Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D019125EFA9;
	Tue, 11 Mar 2025 15:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707480; cv=none; b=kKw5zJFoGK9j7EDwk1oD/cHrHG8i8tLycREaEcUq18zivxq1sloXKPKGp7C8OpLD2CmFmdcXGWVXcX86bd8Dnf8NEnbuSL8K6t9HPYKcG27zzMLvoz/PnkiV9kaRgEY//LtuNQJvRi910UYaXOy2PU12/ASmSPbWBNqwENWZoag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707480; c=relaxed/simple;
	bh=IMV0XDeCQ0josajP0e7sY+tSrLQJyDrHcS5ZFFIvukk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVFPXsDwAgxqvdcy1hPP0Lgelai/igwLNKWMidKz+51RvwL9ZG11/ugsMO/8HdOBYzfUxqAz8T4f57FQ4mSTuzERs79O7zo5oqOH9zpMB3h4rMmuX75NHiWjiddO5jKetjMpuDM/4QD53TUbX5nCUb0R7ACunyuBQb/ZyevsN+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsxTPfkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsxTPfkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5680BC4CEE9;
	Tue, 11 Mar 2025 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707480;
	bh=IMV0XDeCQ0josajP0e7sY+tSrLQJyDrHcS5ZFFIvukk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UsxTPfkRtrsZmX9tOtx4rL+nxeJnzqYGV+43f8yev9wLJG5A0dGTWrh2fWF2pQ90G
	 u31ecOrHeENP8hPlkbWvENYnfR5NwcOZwB8Ma86dGMd7i5x7uHMNICvb9AvkS1PtOf
	 brYSqlnHj8tjWvL3jfcGHWfBrOsqGckaeYcRNfX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mulhern <amulhern@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Olivier Gayot <olivier.gayot@canonical.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 403/462] block: fix conversion of GPT partition name to 7-bit
Date: Tue, 11 Mar 2025 16:01:09 +0100
Message-ID: <20250311145814.255583717@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -672,7 +672,7 @@ static void utf16_le_to_7bit(const __le1
 	out[size] = 0;
 
 	while (i < size) {
-		u8 c = le16_to_cpu(in[i]) & 0xff;
+		u8 c = le16_to_cpu(in[i]) & 0x7f;
 
 		if (c && !isprint(c))
 			c = '!';


