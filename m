Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE916FBE
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED97C433C1;
	Wed, 30 Nov 2022 18:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833653;
	bh=HQnziATy9GXeouqLcZTi0GRYACLnIQvqj6pEI65EoMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pT+pbY8lGMwbjCBYmXHtEK7QGWrxQGoeiWkljL8JAZvFYb1O4hN0WX2H9CfuaGplQ
	 7O5ALE4W4N/SFGoOqCIYrqfPQdivCwn3mdQUPP83q6dB2VSNY2bq7D0/YqK6JEb+rE
	 h4UiYGo5hZm5+xL2h0zJJ2CTLjcTvC43edz+xKQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/206] tools: iio: iio_generic_buffer: Fix read size
Date: Wed, 30 Nov 2022 19:23:38 +0100
Message-Id: <20221130180537.253324399@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 7c919b619bcc68158921b1bd968f0e704549bbb6 ]

When noevents is true and small buffer is used the allocated memory for
holding the data may be smaller than the hard-coded 64 bytes. This can
cause the iio_generic_buffer to crash.

Following was recorded on beagle bone black with v6.0 kernel and the
digit fix patch:
https://lore.kernel.org/all/Y0f+tKCz+ZAIoroQ@dc75zzyyyyyyyyyyyyycy-3.rev.dnainternet.fi/
using valgrind;

==339== Using Valgrind-3.18.1 and LibVEX; rerun with -h for copyright info
==339== Command: /iio_generic_buffer -n kx022-accel -T0 -e -l 10 -a -w 2000000
==339== Parent PID: 307
==339==
==339== Syscall param read(buf) points to unaddressable byte(s)
==339==    at 0x496BFA4: read (read.c:26)
==339==    by 0x11699: main (iio_generic_buffer.c:724)
==339==  Address 0x4ab3518 is 0 bytes after a block of size 160 alloc'd
==339==    at 0x4864B70: malloc (vg_replace_malloc.c:381)
==339==    by 0x115BB: main (iio_generic_buffer.c:677)

Fix this by always using the same size for reading as was used for
data storage allocation.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/Y0kMh0t5qUXJw3nQ@dc75zzyyyyyyyyyyyyycy-3.rev.dnainternet.fi
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_generic_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/iio/iio_generic_buffer.c b/tools/iio/iio_generic_buffer.c
index 2491c54a5e4f..f8deae4e26a1 100644
--- a/tools/iio/iio_generic_buffer.c
+++ b/tools/iio/iio_generic_buffer.c
@@ -715,12 +715,12 @@ int main(int argc, char **argv)
 				continue;
 			}
 
-			toread = buf_len;
 		} else {
 			usleep(timedelay);
-			toread = 64;
 		}
 
+		toread = buf_len;
+
 		read_size = read(buf_fd, data, toread * scan_size);
 		if (read_size < 0) {
 			if (errno == EAGAIN) {
-- 
2.35.1



