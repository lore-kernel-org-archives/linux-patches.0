Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377051C9B81;
	Mon, 14 Oct 2024 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919825; cv=none; b=CSk98TjVueFukmnGpRyZ0Se1GAAc8BkpV7chEw+LkRhwqON4hLzGQkohZN8TdwF+UFTmaQh+xSxsqgbKQZrSBgnr+Aw1XE7PnzF4kCXe38JCpxTA982/1XBb4pqLgxDETEA7oNnFWZwY5pANXTrgIxRkt8n/c13+fC9JSaaZDd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919825; c=relaxed/simple;
	bh=IEcRA0H9ogbDN9Fd19C+H/LzVXE7fp/gK6uB8kyY6x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HroLqvTfhWHPVNaP6IzC/5fcsEg9Ev+H5oeBjkj/iwaxOdLfLgQ0MtVUn91jNUENsvIla4zn6KdsixCXhB0gwO9Smhp5I5XZ33e6hxvDnkD9NXJ361RCEEGCMSt9gMCzgFVqb68TKpss4yoAM+X8/xuFd/5nRvAYoo1Fe3vJ2TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYg2uftC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYg2uftC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7FAC4CEC7;
	Mon, 14 Oct 2024 15:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919824;
	bh=IEcRA0H9ogbDN9Fd19C+H/LzVXE7fp/gK6uB8kyY6x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYg2uftCjysHRVqC7lOTxt0DaOfa4kvGl3qTh9CqyGEROhoZE8XHFwA81sXnaMytJ
	 S8tSjajPEwJ8ZxpuH89BB9ThUVNJg+fRa/ygrQaSIItvGOlHlsD54zNILIMBKtSzfl
	 /Mjjqz7hbat8ItMW9abxUop0pAGjAM77iDoUKre4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 717/798] tools/iio: Add memory allocation failure check for trigger_name
Date: Mon, 14 Oct 2024 16:21:11 +0200
Message-ID: <20241014141246.234912254@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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



