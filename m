Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E3F2AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9769DC433C8;
	Wed, 20 Sep 2023 11:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211089;
	bh=G8dEks/Ds08kZ3s/k+/8uFqdVgonlCVrte17iBYme68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iov8MMQlcubbY4Y/7f7dbcFDwtf3zRJOe8JxVIawOnA+z6zTf0GIKxIkwmifVGVsY
	 dgfYd+d9X1P7lUpEx4zRjePTgk5KYPn8GJnXN4lNVqNwD0bcyVj+5zQ9C0fFVam6/g
	 fTk0Aa2mN/jd2elp6/9apABaU5RyT0q++VrKv5N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Mi <michenyuan@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/139] tools: iio: iio_generic_buffer: Fix some integer type and calculation
Date: Wed, 20 Sep 2023 13:30:11 +0200
Message-ID: <20230920112838.540468511@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

From: Chenyuan Mi <michenyuan@huawei.com>

[ Upstream commit 49d736313d0975ddeb156f4f59801da833f78b30 ]

In function size_from_channelarray(), the return value 'bytes' is defined
as int type. However, the calcution of 'bytes' in this function is designed
to use the unsigned int type. So it is necessary to change 'bytes' type to
unsigned int to avoid integer overflow.

The size_from_channelarray() is called in main() function, its return value
is directly multipled by 'buf_len' and then used as the malloc() parameter.
The 'buf_len' is completely controllable by user, thus a multiplication
overflow may occur here. This could allocate an unexpected small area.

Signed-off-by: Chenyuan Mi <michenyuan@huawei.com>
Link: https://lore.kernel.org/r/20230725092407.62545-1-michenyuan@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_generic_buffer.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/iio/iio_generic_buffer.c b/tools/iio/iio_generic_buffer.c
index f8deae4e26a15..44bbf80f0cfdd 100644
--- a/tools/iio/iio_generic_buffer.c
+++ b/tools/iio/iio_generic_buffer.c
@@ -51,9 +51,9 @@ enum autochan {
  * Has the side effect of filling the channels[i].location values used
  * in processing the buffer output.
  **/
-static int size_from_channelarray(struct iio_channel_info *channels, int num_channels)
+static unsigned int size_from_channelarray(struct iio_channel_info *channels, int num_channels)
 {
-	int bytes = 0;
+	unsigned int bytes = 0;
 	int i = 0;
 
 	while (i < num_channels) {
@@ -348,7 +348,7 @@ int main(int argc, char **argv)
 	ssize_t read_size;
 	int dev_num = -1, trig_num = -1;
 	char *buffer_access = NULL;
-	int scan_size;
+	unsigned int scan_size;
 	int noevents = 0;
 	int notrigger = 0;
 	char *dummy;
@@ -674,7 +674,16 @@ int main(int argc, char **argv)
 	}
 
 	scan_size = size_from_channelarray(channels, num_channels);
-	data = malloc(scan_size * buf_len);
+
+	size_t total_buf_len = scan_size * buf_len;
+
+	if (scan_size > 0 && total_buf_len / scan_size != buf_len) {
+		ret = -EFAULT;
+		perror("Integer overflow happened when calculate scan_size * buf_len");
+		goto error;
+	}
+
+	data = malloc(total_buf_len);
 	if (!data) {
 		ret = -ENOMEM;
 		goto error;
-- 
2.40.1



