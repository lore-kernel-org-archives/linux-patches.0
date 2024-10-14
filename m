Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774C51AAC4;
	Mon, 14 Oct 2024 14:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916145; cv=none; b=KYXOhCD/AaQDOSivCCp81qCx8jgLvcftGIqbeQ/J+Ko+oWxwYR6to+VBNBCNhvJpks2ROyq6k9+T8MQmMWXNhQJrUJEFA0ZdVH822AlclrcwIfSWuI1Ljm8ALp0JJbESs3Dfb+chsGQdiMSc61BmhEYhBPLRD4fz5HvSrrNKV80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916145; c=relaxed/simple;
	bh=7Z1xa+Lhwr0GaafrAoyUoR4zVjwS26npvgRxowU85WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ul9vNJlzjWVkK81Vxmw66lUAKVhZ8FDL+73Zy8NYMIcdzc+R7FrYYKG8AfJodGk/G2ZalPFHPbF/cYfFeYYrRcm8KYu1tuto0svBoG4DB7bb8zHCzD8+UZWftQMyxZydSZsNvMQGX2P/0UTe8fgkvQLVBvPoPUqNdtUuybVsXmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXnY1A67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXnY1A67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9736EC4CEC3;
	Mon, 14 Oct 2024 14:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916145;
	bh=7Z1xa+Lhwr0GaafrAoyUoR4zVjwS26npvgRxowU85WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXnY1A67AcS/bPCYcqDQVq+mfYVcVq8xMVjYr5/VIjuHb15al+CZQq0xB/DfzSTBL
	 CxDMaGdw6QL1tp+X4iGw0k8OtOxdwCh3BJ7o5D4QHpMuIV/7vXFjU9XHqHnVUDY4/8
	 +QO0D4jSA1rM976/As6+rZ9/s7JGkxriCfiB4Lqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 066/214] tools/iio: Add memory allocation failure check for trigger_name
Date: Mon, 14 Oct 2024 16:18:49 +0200
Message-ID: <20241014141047.567089076@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



