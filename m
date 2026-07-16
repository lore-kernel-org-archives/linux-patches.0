Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478994229AB;
	Thu, 16 Jul 2026 13:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209346; cv=none; b=DffsovNIIEMYSXgHGhWnUCJt5m/u12JgNoHXI4nN0Qulai4IYmGCb89WOJfyRIgNHdYmANHRiQ4VOlchD1+Ba2rCklxC08awiFIgwI16uofaeMVOuE7/NH3brNkiTj+RhQ75dX62DnWoEnMRBIEtdKq6fEx614rPwkupg/4EQxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209346; c=relaxed/simple;
	bh=/Mg3z4qkshBCDi+TuUQOjhbJrdgED/9JLchkHR+zsLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meOu2CQFMbsKSJv7Zre8PIzkzJpkglI3w48nZfHeH7aPQw6zOvkcsSOJCORgouOqRet3VwSXKUxax+ieyrg3zh/aujtrcuL2Vlfe+3oHv7aVtRG/W6h4cbvLc8ujPC1hYj+A/o+wTIWKzAq7qFoWY2yBtCtUupWVqyas+T+cfTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+0S8WD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+0S8WD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E9B1F000E9;
	Thu, 16 Jul 2026 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209345;
	bh=mAiroLLcLUzXGQGzAbKY9cxD7L8RDxrWU06ds98JR3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v+0S8WD26QEfnhYGixuzXvcYmRxe2QBvaXQqroJHgV+fKqw8WsG/GxfDlZHtttoYx
	 Oue6/pom6WTllF2LEcLgAg/8KsqSxAivRQZ/XewkUWX24ygHgG/jpmoyi6U2kKx3sc
	 2SqsaleduaFQqEDRQu8TbyGfS6Ymy2r0zEDdumq4=
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
Subject: [PATCH 7.1 149/518] 6lowpan: fix NHC entry use-after-free on error path
Date: Thu, 16 Jul 2026 15:26:57 +0200
Message-ID: <20260716133051.108847043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


