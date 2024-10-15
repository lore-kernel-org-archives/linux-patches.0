Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9831B1EB9F1;
	Tue, 15 Oct 2024 12:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994237; cv=none; b=iNgGfY3KcHI4PGFTtY/AJKNwkfnTvTr6UXevT0AxeySwVZIoR15MkQLIDm0wGzO3GY6aQ7gTKp1HvW7KofABkZrmNEhzQBw9qLzN1BbLD/Jzt4Upk/F1oKs/PWw1oo+jnrrSRJecJQJqlAO5uRj0eh4tZBGk9hn/S7S3hKtMDSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994237; c=relaxed/simple;
	bh=smf2dSr3rUSI1+l1ksx8bzeIUJJhhK5eDbRUaeYo1oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHqpbCwe72/OT0xe/9D2RbRl/lbXo/XqfrFyA2H1830sA9oH6FQWgbTdKVpVrvKoFr5KEy+9k9ufMp8PH9arRST2Jwjytf//Yv5rbf5U43Fv1Ak2MX353DWwjFqbkD1BihGUXMABJJY9UAIyPzwpzS67iHlaqx6Mi7RYF/YvB08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2FMrRfT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2FMrRfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02363C4CEC6;
	Tue, 15 Oct 2024 12:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994237;
	bh=smf2dSr3rUSI1+l1ksx8bzeIUJJhhK5eDbRUaeYo1oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2FMrRfT5XSgv2sQrCn4wgDQjmtMKrpCAu7bvb5m6QXj6vk3331u9t++1wNj4+jxU
	 E5yaIrccixUjxDqAWq4FLA8b7aB2rLeKu2xX29qpWLrd35yLefqj7LD7vb4aHOhIDH
	 b8LHFfAls9CiuI5HfQ/TBQCjTovGXYfRoi1cjfv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 619/691] tools/iio: Add memory allocation failure check for trigger_name
Date: Tue, 15 Oct 2024 13:29:27 +0200
Message-ID: <20241015112504.901918857@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Jun <zhujun2@cmss.chinamobile.com>

[ Upstream commit 3c6b818b097dd6932859bcc3d6722a74ec5931c1 ]

Added a check to handle memory allocation failure for `trigger_name`
and return `-ENOMEM`.

Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
Link: https://patch.msgid.link/20240828093129.3040-1-zhujun2@cmss.chinamobile.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_generic_buffer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/iio/iio_generic_buffer.c b/tools/iio/iio_generic_buffer.c
index 0d0a7a19d6f95..9ef5ee087eda3 100644
--- a/tools/iio/iio_generic_buffer.c
+++ b/tools/iio/iio_generic_buffer.c
@@ -498,6 +498,10 @@ int main(int argc, char **argv)
 			return -ENOMEM;
 		}
 		trigger_name = malloc(IIO_MAX_NAME_LENGTH);
+		if (!trigger_name) {
+			ret = -ENOMEM;
+			goto error;
+		}
 		ret = read_sysfs_string("name", trig_dev_name, trigger_name);
 		free(trig_dev_name);
 		if (ret < 0) {
-- 
2.43.0



