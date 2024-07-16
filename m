Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75BA17A93F;
	Tue, 16 Jul 2024 15:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145200; cv=none; b=hqOE4DIU+s4RPtR8UT5gIoJ3lR5nIlNV+y6iRLEN1u1g8iZuesXQzIAVhXDBd31bk38J4kkTbIM4EqxxkaCuiAQSL4DnTHkznLmdLYyYcqER6zPi9LBY0RJwZ/8lN2wElqPn4g/swAQT+eCCHvNsFe+w32I153S0HLsxYSOqtnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145200; c=relaxed/simple;
	bh=bQLndeYued1xskF7RURbiVo0SRWXA9UMXUpAjXVSO6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4neoCGiLySSrtOYeULwnbRaNMm1Zq+pJ+PdF5W3eZlEU2MsZGtYJ8iskVlYGFYrPRK995w+I5wGU3Q4+eKIKn2lABIfyWUhH0Uipe+rwImjsWQwvh6TpOb/HM4Bn77a+S+OwnudBoa6s4cGUFnLvXwcMrO7JTdfUCMMOeIWcNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/dpUIMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/dpUIMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE721C116B1;
	Tue, 16 Jul 2024 15:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145200;
	bh=bQLndeYued1xskF7RURbiVo0SRWXA9UMXUpAjXVSO6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/dpUIMFt7nG3M96bBfGpSRzMKjUU/l7G4L0XLaUUJnuWn1BKMphryZh/oYk5LZ+M
	 UYtvTZ7/bcteFMANmoPQ5p2jsQRVPaQrui+oRm/Y4NCnAORDg2pUJDXx/AdVkf9tZ5
	 UyKKcKTa7bFrCkSqpQSZ8J8KfqAsuN6+TWha65bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.9 099/143] nvmem: rmem: Fix return value of rmem_read()
Date: Tue, 16 Jul 2024 17:31:35 +0200
Message-ID: <20240716152759.787024666@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joy Chakraborty <joychakr@google.com>

commit 28b008751aa295612318a0fbb2f22dd4f6a83139 upstream.

reg_read() callback registered with nvmem core expects 0 on success and
a negative value on error but rmem_read() returns the number of bytes
read which is treated as an error at the nvmem core.

This does not break when rmem is accessed using sysfs via
bin_attr_nvmem_read()/write() but causes an error when accessed from
places like nvmem_access_with_keepouts(), etc.

Change to return 0 on success and error in case
memory_read_from_buffer() returns an error or -EIO if bytes read do not
match what was requested.

Fixes: 5a3fa75a4d9c ("nvmem: Add driver to expose reserved memory as nvmem")
Cc: stable@vger.kernel.org
Signed-off-by: Joy Chakraborty <joychakr@google.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628113704.13742-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/rmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/nvmem/rmem.c
+++ b/drivers/nvmem/rmem.c
@@ -46,7 +46,10 @@ static int rmem_read(void *context, unsi
 
 	memunmap(addr);
 
-	return count;
+	if (count < 0)
+		return count;
+
+	return count == bytes ? 0 : -EIO;
 }
 
 static int rmem_probe(struct platform_device *pdev)


