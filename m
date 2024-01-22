Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2408836B04;
	Tue, 23 Jan 2024 00:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969830; cv=none; b=jM8JRBx2482OlF39KxzPIIbVe5kdawZ4Ge21Stt8KSdmXKzfgqkMAi247Nyc/Avi9cLUZLl47fk4Y78fPZZZuSQFvtbY/ZHgL7cLXT9gs/4MtpCGgePSCSM+PtmcgHZzMxhX5pMJVoYrdVx9vSdBvZD0AkdP72JWlZnUD5zvQfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969830; c=relaxed/simple;
	bh=HjyjPtoKzsQ7g7RYFklPIUQs4olkvW5vb1ryIr+qH7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S27QmZl8rEovTqFA8lq+e9SA4r7nj0rnoa3AoiEssVwvznRJtiQ5ArGaa4Si3waGUhX93Ato9b+p3rp1xriktgKhgqYX9P0QVexklhS/tw48NzF1R++EI/1D/teiJyhbmPoeuANMWxMp6xb10HhKvbvMQX3Q85dzlE7xCdqMbao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFkJMjVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFkJMjVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80AAC43394;
	Tue, 23 Jan 2024 00:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969830;
	bh=HjyjPtoKzsQ7g7RYFklPIUQs4olkvW5vb1ryIr+qH7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFkJMjVMXPcSaPEMRy8uQN4Xp4bvBIsbQAoouwwGFCfn2srGJ1InlnaEHhjwWqwQc
	 uQzEuLUPKWrjRrVVLdibCaT6kGBzHcPYxkBEWbqi0jl51O3rIUA054z7MO3s9jg3Zc
	 /2pQpn4ttn2LAeZMjd+cxHV8uq+yHE0WHcAl2pAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@gmail.com>,
	David Laight <David.Laight@ACULAB.COM>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.7 451/641] media: solo6x10: replace max(a, min(b, c)) by clamp(b, a, c)
Date: Mon, 22 Jan 2024 15:55:55 -0800
Message-ID: <20240122235832.133784775@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

commit 31e97d7c9ae3de072d7b424b2cf706a03ec10720 upstream.

This patch replaces max(a, min(b, c)) by clamp(b, a, c) in the solo6x10
driver.  This improves the readability and more importantly, for the
solo6x10-p2m.c file, this reduces on my system (x86-64, gcc 13):

 - the preprocessed size from 121 MiB to 4.5 MiB;

 - the build CPU time from 46.8 s to 1.6 s;

 - the build memory from 2786 MiB to 98MiB.

In fine, this allows this relatively simple C file to be built on a
32-bit system.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Closes: https://lore.kernel.org/lkml/18c6df0d-45ed-450c-9eda-95160a2bbb8e@gmail.com/
Cc:  <stable@vger.kernel.org> # v6.7+
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: David Laight <David.Laight@ACULAB.COM>
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/solo6x10/solo6x10-offsets.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/media/pci/solo6x10/solo6x10-offsets.h
+++ b/drivers/media/pci/solo6x10/solo6x10-offsets.h
@@ -57,16 +57,16 @@
 #define SOLO_MP4E_EXT_ADDR(__solo) \
 	(SOLO_EREF_EXT_ADDR(__solo) + SOLO_EREF_EXT_AREA(__solo))
 #define SOLO_MP4E_EXT_SIZE(__solo) \
-	max((__solo->nr_chans * 0x00080000),				\
-	    min(((__solo->sdram_size - SOLO_MP4E_EXT_ADDR(__solo)) -	\
-		 __SOLO_JPEG_MIN_SIZE(__solo)), 0x00ff0000))
+	clamp(__solo->sdram_size - SOLO_MP4E_EXT_ADDR(__solo) -	\
+	      __SOLO_JPEG_MIN_SIZE(__solo),			\
+	      __solo->nr_chans * 0x00080000, 0x00ff0000)
 
 #define __SOLO_JPEG_MIN_SIZE(__solo)		(__solo->nr_chans * 0x00080000)
 #define SOLO_JPEG_EXT_ADDR(__solo) \
 		(SOLO_MP4E_EXT_ADDR(__solo) + SOLO_MP4E_EXT_SIZE(__solo))
 #define SOLO_JPEG_EXT_SIZE(__solo) \
-	max(__SOLO_JPEG_MIN_SIZE(__solo),				\
-	    min((__solo->sdram_size - SOLO_JPEG_EXT_ADDR(__solo)), 0x00ff0000))
+	clamp(__solo->sdram_size - SOLO_JPEG_EXT_ADDR(__solo),	\
+	      __SOLO_JPEG_MIN_SIZE(__solo), 0x00ff0000)
 
 #define SOLO_SDRAM_END(__solo) \
 	(SOLO_JPEG_EXT_ADDR(__solo) + SOLO_JPEG_EXT_SIZE(__solo))


