Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BC11FCF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyH7/UEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90985C4E778;
	Wed, 15 Nov 2023 20:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081825;
	bh=0jxvmgpxfi8jKrU6vQOqUyT5SKSgdJBaum+44aF9/ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyH7/UEmd+EluN0BfnuFf0EJVMkoMlILi269W3PjivnIRZNx8Mps10qRzXxgDtb/0
	 VD7KQIkKkGI9ssWynpHK36rlDdLeVku2iOj9YGucufjpEm9jRRJANyHJUYESb4F3jQ
	 XTlN7tfYslFnz+Lb89QseRHZI21ZfI1WNvs4klEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/191] tools: iio: iio_generic_buffer ensure alignment
Date: Wed, 15 Nov 2023 15:46:47 -0500
Message-ID: <20231115204652.447174066@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 2d3dff577dd0ea8fe9637a13822f7603c4a881c8 ]

The iio_generic_buffer can return garbage values when the total size of
scan data is not a multiple of the largest element in the scan. This can be
demonstrated by reading a scan, consisting, for example of one 4-byte and
one 2-byte element, where the 4-byte element is first in the buffer.

The IIO generic buffer code does not take into account the last two
padding bytes that are needed to ensure that the 4-byte data for next
scan is correctly aligned.

Add the padding bytes required to align the next sample with the scan size.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: e58537ccce73 ("staging: iio: update example application.")
Link: https://lore.kernel.org/r/ZRvlm4ktNLu+qmlf@dc78bmyyyyyyyyyyyyydt-3.rev.dnainternet.fi
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_generic_buffer.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/iio/iio_generic_buffer.c b/tools/iio/iio_generic_buffer.c
index e38c72fd58ccf..2fd10eab75b53 100644
--- a/tools/iio/iio_generic_buffer.c
+++ b/tools/iio/iio_generic_buffer.c
@@ -52,9 +52,12 @@ enum autochan {
 static unsigned int size_from_channelarray(struct iio_channel_info *channels, int num_channels)
 {
 	unsigned int bytes = 0;
-	int i = 0;
+	int i = 0, max = 0;
+	unsigned int misalignment;
 
 	while (i < num_channels) {
+		if (channels[i].bytes > max)
+			max = channels[i].bytes;
 		if (bytes % channels[i].bytes == 0)
 			channels[i].location = bytes;
 		else
@@ -64,6 +67,14 @@ static unsigned int size_from_channelarray(struct iio_channel_info *channels, in
 		bytes = channels[i].location + channels[i].bytes;
 		i++;
 	}
+	/*
+	 * We want the data in next sample to also be properly aligned so
+	 * we'll add padding at the end if needed. Adding padding only
+	 * works for channel data which size is 2^n bytes.
+	 */
+	misalignment = bytes % max;
+	if (misalignment)
+		bytes += max - misalignment;
 
 	return bytes;
 }
-- 
2.42.0



