Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3D51C93AF;
	Tue, 27 Aug 2024 15:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772523; cv=none; b=DvI5/OxnbwKJuA3hS8SAg96BjJ9wCmHNeRW30c+fXSgZXi9tsDbITQhv9m/O90Digx9yEa5Y3+wlqFrrAIDchlB6cY+5dVW5ksol4r/KqbZY+kQmNU7YEd0EVw2AsVn0XJEziuQGmp86CHQWdIIfkscUIHEsxJKrL6hIBPD/H4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772523; c=relaxed/simple;
	bh=HNquGm0+89SHVFFm3mgao/1E5EWNex/Qg35CJGqs/ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9lXJSK4OSmJ1P0VBNExjZd3wnS9Ml3o5NNEOPbjeyRfUUBbH7NRFfTqwUs7CVkVNC7FvDwa8ZHWgPJm7dIEoSH61kB+ILS3EjWH6s9yvdKH5QpZPC7LANgCN1GAAdw5ruNaKar2h14cCakFt40X3fbZGYeH2TzmvAeKBS9cCrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B007V0wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B007V0wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D631C4AF15;
	Tue, 27 Aug 2024 15:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772522;
	bh=HNquGm0+89SHVFFm3mgao/1E5EWNex/Qg35CJGqs/ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B007V0wvJ6SRJS/uFekppdcV1jF/qG6LLvfNAMA2Km6N9Zp1WoAoUXk/VKk9umr+j
	 PRkReV3VxBNWRdZRcDz+uH/3ezrHbLflUkd/zT96FGV9W1WTO/ti2h9z42ERtkYhS4
	 cPCkRJn7+j+8GcnDS6V4iFoo1DrrYVUb38CiHAzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@gmail.com>,
	David Laight <David.Laight@ACULAB.COM>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.1 209/321] media: solo6x10: replace max(a, min(b, c)) by clamp(b, a, c)
Date: Tue, 27 Aug 2024 16:38:37 +0200
Message-ID: <20240827143846.188240589@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
Cc: Salvatore Bonaccorso <carnil@debian.org>
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


