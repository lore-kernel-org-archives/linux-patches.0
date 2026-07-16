Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B793148C2;
	Thu, 16 Jul 2026 14:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210714; cv=none; b=n5WsAQbM9TlJEI0v/alwYqcy2HpXv/zRdRjT9feQnCw68RjSStlT6EL1EabbrsHcczFctCEeW2+JT7SQIHh9aDM2CO+mC8fWXqcWEXcJkfhot1a/gwUlFh+x+W7WAqNOksBqm53GiLMfNQKadDmUrWWny0fOhe24Cv700uVw91Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210714; c=relaxed/simple;
	bh=IACUrF0xObfDxpIz+vlxvFfwrvYHuH9yQkVGPDuSdg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYL8z7ozVKGt/N1oh7Qi/VIDo6Mmlmzj11+6xahj+qvYi6gSI4wO1mvMPWP3Z2CenD3SyxtnuWgNWLmK4wJIDzj+q6mM0d1SMzRspubyO5XDnef4KOHFiaUZd/9rsv86aTMevAkanUpBIPiZjxT3Xe+/Mpu2y7dA7pY3iT4hTu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijskvI47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijskvI47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E7C1F000E9;
	Thu, 16 Jul 2026 14:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210713;
	bh=fhwBf1reJzwJ3orFozmolnx6ZdGxXplDWYLxalBY2Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijskvI47ier/6IIo0KMxiTz6SfQBKNmDDRVoiWL6z7E4E74ZMye33290pfCzGHRh8
	 TQcdTlc5ScI4MSuYmiRklago+QyvjnxSNtOu3cPESWrE76zine0tTKysAeBKcZFwD/
	 T0x681gurUdTvw7i9sZf4CagR5q2jgQHrP0WMZ0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Alexander Aring <aahringo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 153/480] 6lowpan: fix NHC entry use-after-free on error path
Date: Thu, 16 Jul 2026 15:28:20 +0200
Message-ID: <20260716133048.016310086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

commit 1720db928e5a58ca7d75ac1d514c3b73fd7061a7 upstream.

lowpan_nhc_do_uncompression() looks up an NHC descriptor while holding
lowpan_nhc_lock.  If the descriptor has no uncompress callback, the error
path drops the lock before printing nhc->name.

lowpan_nhc_del() removes descriptors under the same lock and then relies
on synchronize_net() before the owning module can be unloaded.  That only
waits for net RX RCU readers.  lowpan_header_decompress() is also exported
and can be reached from callers that are not necessarily covered by the net
core RX critical section, for example the Bluetooth 6LoWPAN L2CAP receive
path.

This leaves a race where one task drops lowpan_nhc_lock in the error path,
another task unregisters and frees the matching descriptor after
synchronize_net() returns, and the first task then dereferences nhc->name
for the warning.

With the post-unlock window widened, KASAN reports:

  BUG: KASAN: slab-use-after-free in lowpan_nhc_do_uncompression+0x1f4/0x220
  Read of size 8
  lowpan_nhc_do_uncompression
  lowpan_header_decompress

Fix this by printing the warning before dropping lowpan_nhc_lock, so the
descriptor name is read while unregister is still excluded.  The malformed
packet is still rejected with -ENOTSUPP.

Fixes: 92aa7c65d295 ("6lowpan: add generic nhc layer interface")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://patch.msgid.link/20260609080054.4541-1-zhaoyz24@mails.tsinghua.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/6lowpan/nhc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/6lowpan/nhc.c
+++ b/net/6lowpan/nhc.c
@@ -117,9 +117,9 @@ int lowpan_nhc_do_uncompression(struct s
 				return ret;
 			}
 		} else {
-			spin_unlock_bh(&lowpan_nhc_lock);
 			netdev_warn(dev, "received nhc id for %s which is not implemented.\n",
 				    nhc->name);
+			spin_unlock_bh(&lowpan_nhc_lock);
 			return -ENOTSUPP;
 		}
 	} else {


