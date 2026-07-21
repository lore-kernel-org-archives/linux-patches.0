Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711C22EBB8D;
	Tue, 21 Jul 2026 20:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666592; cv=none; b=BykI/ttbxj7+ZiywUsk4MWLAoVLSMUkvDQyWpq/FnD4GWHN3Q6OcJdoyskXLAarKBFrdneBZ4eEXWwe4AG3ZCd8CSIqwPXnAXXHJeR8nWwu7b8Q1k1hxDfhbv1hT40ucv0RW+9HFCN0TyA3vxtlVlkBKMc9FvM9GF/tjmmt+WYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666592; c=relaxed/simple;
	bh=kN2f6jnY3RYpMtCKRI5+hH+topaIS9rGWL0G0f1gfic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLDHou7PPg0JMVPZMZrj6etFgguxvMtYCGTHlLKlvXR8T6m1DlyMu2elQvF4ilzzXa9yJBcXH9CTSyzErjjOy/0aHnEks1w5DI6EkjU/rPON8AtPYYFny2x19RmCBq1I5dQOOjUJ8dyw+gXfy9xzwX7zRuF9h43LJDCYZRExSc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ff+Bxx1d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ff+Bxx1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D698C1F000E9;
	Tue, 21 Jul 2026 20:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666591;
	bh=xwVY0DQaBjVRjixnxAvmCw0ohvjXvnn0/3KjeAEYWik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ff+Bxx1dnRC4a+S2xLmjs7byX/MNpZzyGZJl/wvjz+VKTWr8n6YbyEaDhL7+PMZc1
	 QWlzxAzbKGgrnvmN5vOyGYmkrR87Me/KFaTVGfTX19cF7CHyJhMAFx/WWkwlMmchjy
	 6fFpyr0jIo8zGG/it2gomoDEZhVCW/88SuBmfO/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Kan Liang <kan.liang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0688/1266] tools lib api: Fix filename__write_int() writing uninitialized stack data
Date: Tue, 21 Jul 2026 17:18:45 +0200
Message-ID: <20260721152457.247489644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 438ece06185696e14c63c6113d5e2d34ec0a9680 ]

filename__write_int() formats an integer into a 64-byte buffer with
sprintf() then passes sizeof(buf) (64) as the write length.  This
writes all 64 bytes including uninitialized stack data past the
formatted string.  Most sysfs files reject the oversized write,
making the function always return -1.

Fix by capturing the sprintf() return value and using it as the
write length.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 3b00ea938653d136 ("tools lib api fs: Add sysfs__write_int function")
Cc: Kan Liang <kan.liang@intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fs/fs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index 1ea76e5ba9d482..60968d0a3bb445 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -404,12 +404,13 @@ int filename__write_int(const char *filename, int value)
 {
 	int fd = open(filename, O_WRONLY), err = -1;
 	char buf[64];
+	int len;
 
 	if (fd < 0)
 		return err;
 
-	sprintf(buf, "%d", value);
-	if (write(fd, buf, sizeof(buf)) == sizeof(buf))
+	len = sprintf(buf, "%d", value);
+	if (write(fd, buf, len) == len)
 		err = 0;
 
 	close(fd);
-- 
2.53.0



