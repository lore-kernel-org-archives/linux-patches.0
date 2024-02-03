Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD46B134C1;
	Sat,  3 Feb 2024 04:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933368; cv=none; b=jjA8WPp/7qw0BrAxF+zGfwZLvK/OlnsEDJbQXD2H6jphxCl2eJGoAPISfcIcPDC0RwTzNiP0P4lq4MeQMN94Wj6GAVTPGr6/q1eDhbLJvKqn2Ums3OSdt3PNcHW9Ot8qHBUw6v1WiM2UDoFfyiNAeh9hRzpV3G555NwttZXdZNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933368; c=relaxed/simple;
	bh=E65ZQWj9d7qoRpfMa8Jzb593JJBcZ7p4ukRtey2e9I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVDMBi27LdpPTH5TJ4ywaJ5pHOnE5CFx+PbA3se5GHarOsYiySTDbeas65cG2QGFvlonW7nEWNQRH6d8zArnOm5x6Gni6sCgwgUWuqYyU6yNpaaLolqfMPuN8eX1f68aMTFLY51M8yflrVc+4YlSnjBMcoHUsTgGZ7RNCBrPqWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Se0PVhJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Se0PVhJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95092C433C7;
	Sat,  3 Feb 2024 04:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933368;
	bh=E65ZQWj9d7qoRpfMa8Jzb593JJBcZ7p4ukRtey2e9I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Se0PVhJPI3bwnNO9dTgQJyjsMQ3DHjzFD5YhrlSkwP2fe2flSvGxlSclYHLMsq4gS
	 +UDKxAdqtmXKosRzSS3JSZCjtCRaxTsrkbbRYWUn6UR5xlFg0AMmaVKcaVUYadi1yb
	 prpwwZslios40PAbn28NXzjzoTM23BTUVf90HTsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/219] block/rnbd-srv: Check for unlikely string overflow
Date: Fri,  2 Feb 2024 20:04:09 -0800
Message-ID: <20240203035327.793760130@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 9e4bf6a08d1e127bcc4bd72557f2dfafc6bc7f41 ]

Since "dev_search_path" can technically be as large as PATH_MAX,
there was a risk of truncation when copying it and a second string
into "full_path" since it was also PATH_MAX sized. The W=1 builds were
reporting this warning:

drivers/block/rnbd/rnbd-srv.c: In function 'process_msg_open.isra':
drivers/block/rnbd/rnbd-srv.c:616:51: warning: '%s' directive output may be truncated writing up to 254 bytes into a region of size between 0 and 4095 [-Wformat-truncation=]
  616 |                 snprintf(full_path, PATH_MAX, "%s/%s",
      |                                                   ^~
In function 'rnbd_srv_get_full_path',
    inlined from 'process_msg_open.isra' at drivers/block/rnbd/rnbd-srv.c:721:14: drivers/block/rnbd/rnbd-srv.c:616:17: note: 'snprintf' output between 2 and 4351 bytes into a destination of size 4096
  616 |                 snprintf(full_path, PATH_MAX, "%s/%s",
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  617 |                          dev_search_path, dev_name);
      |                          ~~~~~~~~~~~~~~~~~~~~~~~~~~

To fix this, unconditionally check for truncation (as was already done
for the case where "%SESSNAME%" was present).

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312100355.lHoJPgKy-lkp@intel.com/
Cc: Md. Haris Iqbal <haris.iqbal@ionos.com>
Cc: Jack Wang <jinpu.wang@ionos.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc:  <linux-block@vger.kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Link: https://lore.kernel.org/r/20231212214738.work.169-kees@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 2cfed2e58d64..ad451224e663 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -587,6 +587,7 @@ static char *rnbd_srv_get_full_path(struct rnbd_srv_session *srv_sess,
 {
 	char *full_path;
 	char *a, *b;
+	int len;
 
 	full_path = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!full_path)
@@ -598,19 +599,19 @@ static char *rnbd_srv_get_full_path(struct rnbd_srv_session *srv_sess,
 	 */
 	a = strnstr(dev_search_path, "%SESSNAME%", sizeof(dev_search_path));
 	if (a) {
-		int len = a - dev_search_path;
+		len = a - dev_search_path;
 
 		len = snprintf(full_path, PATH_MAX, "%.*s/%s/%s", len,
 			       dev_search_path, srv_sess->sessname, dev_name);
-		if (len >= PATH_MAX) {
-			pr_err("Too long path: %s, %s, %s\n",
-			       dev_search_path, srv_sess->sessname, dev_name);
-			kfree(full_path);
-			return ERR_PTR(-EINVAL);
-		}
 	} else {
-		snprintf(full_path, PATH_MAX, "%s/%s",
-			 dev_search_path, dev_name);
+		len = snprintf(full_path, PATH_MAX, "%s/%s",
+			       dev_search_path, dev_name);
+	}
+	if (len >= PATH_MAX) {
+		pr_err("Too long path: %s, %s, %s\n",
+		       dev_search_path, srv_sess->sessname, dev_name);
+		kfree(full_path);
+		return ERR_PTR(-EINVAL);
 	}
 
 	/* eliminitate duplicated slashes */
-- 
2.43.0



