Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1B32DF137;
	Thu, 16 Jul 2026 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209183; cv=none; b=HCIfXQu6OEHHb7XhRKeFaKjFmeYSnfSAkGEj0iohbD070xt+n8BC95wbjsMUE5UUBwwqDGRqVcTwOxnElQiishJJacqoTnz7bQqj3rCBwULN1kCaqzXM7BnWA1Y5oEODj/o8I7DyiITgFfyz7dZ8pAbJWvcRIjQKTpdzrygbDCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209183; c=relaxed/simple;
	bh=Tq47li3TLfYkq+/bE0R2L8FRd/WG9qGrFBDgsxCWBNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1e7TAcp6D4E1GVORZOnbod8Faw9Oy7PPoqzDfBhXNyYx+wpOHBLzEHWiMFtHsHJZBuqMpojzzQgpgEBui4a4YVIYOgt5JXIh3cvH1oPqneBCUgyf1/0MU9RARpf8XYVyKHJBBK+mGM5SHhs7Z01yaH3yRVCHb5bXLYmiceojEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjpVEB6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjpVEB6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1FD1F000E9;
	Thu, 16 Jul 2026 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209181;
	bh=ydAJ9liVVUQb4I9MtS8Fy6bNrB3LuUWckVrEYwNCgHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjpVEB6lzddb9EOrskNkHWQL7N7eswnNTnrYLrHCGUPeHhMShWfYM6+bmZIR2bJ9x
	 f+8ghv4NXUlkut3IXwy8S9aA3YOyC+X0E3tx/03EQkIVHw9XslRTjyonIQItUONTTo
	 tr0Q/HUVhQiqFTkOBIsXMl/c4yTxUxLxgjDdG4RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 089/518] ALSA: firewire: isight: bound the sample count to the packet payload
Date: Thu, 16 Jul 2026 15:25:57 +0200
Message-ID: <20260716133049.813909129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 29b9667982e4df2ed7744f86b1144f8bb58eb698 upstream.

isight_packet() takes the frame count from the device iso packet and
checks it only against the device claimed iso length.

	count = be32_to_cpu(payload->sample_count);
	if (likely(count <= (length - 16) / 4))
		isight_samples(isight, payload->samples, count);

length is the iso header data_length. It can be up to 0xffff. So the
gate allows a count up to about 16379. isight_samples() then copies
count frames out of payload->samples into the PCM DMA buffer.

payload->samples holds only 2 * MAX_FRAMES_PER_PACKET values. The
device multiplexes two samples per frame. A count past
MAX_FRAMES_PER_PACKET reads past the payload. A count past the buffer
size writes past runtime->dma_area. The smallest PCM buffer is larger
than MAX_FRAMES_PER_PACKET. Bounding the count to MAX_FRAMES_PER_PACKET
keeps both the read and the write in range.

A malicious or faulty Apple iSight on the FireWire bus reaches this
during a normal capture.

Add the MAX_FRAMES_PER_PACKET bound to the gate.

Fixes: 3a691b28a0ca ("ALSA: add Apple iSight microphone driver")
Suggested-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/178205454729.1900991.7807310178296762772@maoyixie.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/isight.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/firewire/isight.c
+++ b/sound/firewire/isight.c
@@ -179,7 +179,8 @@ static void isight_packet(struct fw_iso_
 	if (likely(length >= 16 &&
 		   payload->signature == cpu_to_be32(0x73676874/*"sght"*/))) {
 		count = be32_to_cpu(payload->sample_count);
-		if (likely(count <= (length - 16) / 4)) {
+		if (likely(count <= (length - 16) / 4 &&
+			   count <= MAX_FRAMES_PER_PACKET)) {
 			total = be32_to_cpu(payload->sample_total);
 			if (unlikely(total != isight->total_samples)) {
 				if (!isight->first_packet)


