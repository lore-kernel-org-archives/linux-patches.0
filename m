Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D154E25A321;
	Wed,  8 Apr 2026 19:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674917; cv=none; b=Z5Yl1iloXSNFkvsJmU8cmfxs6Cv3LM6zH2kS4S9thwBQMr6IGlTsLotuTsSz9QFfqMKyhcFg5N0tq3fgNq/GzFGmLJH1pBWhzzUFVPaS5gEByLpkcEfNtPMK+v6WT8upOA9PdQbnLGvHybg4Y/783Htn/t4rm1gcjSc8kVbjS2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674917; c=relaxed/simple;
	bh=Lgs6dgge1HmBGir5HJvH4mfvlejdrVuDdz/7dttHhn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpemrNKdZ54izYv0WbyEKxFGOrgieoGFoLDv+ePKbi3C++0piT0PaLQAklIPlqsF9BBzgGck6M2gbL1/3WR5cw+oue+zbrghqJYzKnJCsFnnQIVwFhfSrzQRSB3liJy20t4LlN7PTy9961j/cJCfYW2EKn8XhApyQFMA1fpPUpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KktUAU3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KktUAU3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65779C19421;
	Wed,  8 Apr 2026 19:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674917;
	bh=Lgs6dgge1HmBGir5HJvH4mfvlejdrVuDdz/7dttHhn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KktUAU3m8qyNYHNfxfhcuugoBtGEBfqY14xMWv1vFTjWrdFQOw/z42Bhz9yq1zxE6
	 hTX7+CBLcsSi7w70ZEQgzN5KMLeGtxYhaap2kDFAKsUzh3jjv9WRnEu2WDcq9CP2n7
	 +8W2ZrYUboWDs8Ob5uGjD1WIIfCmDAg/93k55IUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.19 250/311] auxdisplay: line-display: fix NULL dereference in linedisp_release
Date: Wed,  8 Apr 2026 20:04:10 +0200
Message-ID: <20260408175948.725212353@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 7f138de156b20d9f9da6f72f90b63c01941d97d3 upstream.

linedisp_release() currently retrieves the enclosing struct linedisp via
to_linedisp(). That lookup depends on the attachment list, but the
attachment may already have been removed before put_device() invokes the
release callback. This can happen in linedisp_unregister(), and can also
be reached from some linedisp_register() error paths.

In that case, to_linedisp() returns NULL and linedisp_release()
dereferences it while freeing the display resources.

The struct device released here is the embedded linedisp->dev used by
linedisp_register(), so retrieve the enclosing object directly with
container_of() instead.

Fixes: 66c93809487e ("auxdisplay: linedisp: encapsulate container_of usage within to_linedisp")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/auxdisplay/line-display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/auxdisplay/line-display.c b/drivers/auxdisplay/line-display.c
index 81b4aac65807..fb6d9294140d 100644
--- a/drivers/auxdisplay/line-display.c
+++ b/drivers/auxdisplay/line-display.c
@@ -365,7 +365,7 @@ static DEFINE_IDA(linedisp_id);
 
 static void linedisp_release(struct device *dev)
 {
-	struct linedisp *linedisp = to_linedisp(dev);
+	struct linedisp *linedisp = container_of(dev, struct linedisp, dev);
 
 	kfree(linedisp->map);
 	kfree(linedisp->message);
-- 
2.53.0



