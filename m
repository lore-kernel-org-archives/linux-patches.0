Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B723A6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15354C433EF;
	Mon, 16 Jan 2023 17:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888637;
	bh=HiQgfMtdrmKFp+G9IjrF+J61ktpyirNZMNi/eLUU7UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCoRhi/+jCVRhULnWpU21zXXCgAqSasS2gpJ9/l55TdadUGEbMd7ix9FN7UlYz1QZ
	 +QgqJL491Px/SDa97thARR4w//lDyc3vner2EnrNOtuAu9+6+o9T5scL7knI/oW73Z
	 S9LQA7jOY1NwCFcknku5HNQ2ZSKT8UQ7cdAzDNOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Zhao Gongyi <zhaogongyi@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Oscar Salvador <osalvador@suse.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 053/338] lib/notifier-error-inject: fix error when writing -errno to debugfs file
Date: Mon, 16 Jan 2023 16:48:46 +0100
Message-Id: <20230116154823.141642406@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit f883c3edd2c432a2931ec8773c70a570115a50fe ]

The simple attribute files do not accept a negative value since the commit
488dac0c9237 ("libfs: fix error cast of negative value in
simple_attr_write()").

This restores the previous behaviour by using newly introduced
DEFINE_SIMPLE_ATTRIBUTE_SIGNED instead of DEFINE_SIMPLE_ATTRIBUTE.

Link: https://lkml.kernel.org/r/20220919172418.45257-3-akinobu.mita@gmail.com
Fixes: 488dac0c9237 ("libfs: fix error cast of negative value in simple_attr_write()")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Zhao Gongyi <zhaogongyi@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/notifier-error-inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/notifier-error-inject.c b/lib/notifier-error-inject.c
index eb4a04afea80..125ea8ce23a4 100644
--- a/lib/notifier-error-inject.c
+++ b/lib/notifier-error-inject.c
@@ -14,7 +14,7 @@ static int debugfs_errno_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(fops_errno, debugfs_errno_get, debugfs_errno_set,
+DEFINE_SIMPLE_ATTRIBUTE_SIGNED(fops_errno, debugfs_errno_get, debugfs_errno_set,
 			"%lld\n");
 
 static struct dentry *debugfs_create_errno(const char *name, umode_t mode,
-- 
2.35.1



