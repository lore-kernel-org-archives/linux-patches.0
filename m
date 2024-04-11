Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB68E14601D;
	Thu, 11 Apr 2024 10:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830912; cv=none; b=T0tsvDHhZ0LkqtWm4NV1XcA5II/vpy8oFbPh8VXAW6X/0sKJHYO+HHe+esTeZoBkpile05i538+NNIYSsREI2nDzEKjrwfCff00Nqe5FocVyKIBzMJdW99tC1I7FeApyHXoP28x8U26Q7vb2YgtzQiU7qdeOE3boDhzXdk5SE1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830912; c=relaxed/simple;
	bh=ff/MV0EIbBtBr9LWLAjVECCbInZcat+fI14wHz7o6Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOfAPV6fvVxzQr0meuQAw9BPh34cEDSr7YbdZOD5HbeQC4oAb9fwdTua32DYvzngEjCyEjayl2x58bAmyaSIkp0smMq+HxjUNQFGYar2NHlZwwy6I4rZokrGUgcj93Y0kRVUOGUml28dVNCxbe3tDefGaIoJaznqnRnE2NsBeU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2F/7tm5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2F/7tm5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2721C433F1;
	Thu, 11 Apr 2024 10:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830912;
	bh=ff/MV0EIbBtBr9LWLAjVECCbInZcat+fI14wHz7o6Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2F/7tm5BH0yNDyjCP/cNwyxXNM+ZSB85RtqO2kWSIgrnOSMDC1SynZohT01HsESvJ
	 A4o/RE/cIlTfrCGNy30075jfn40XANSglrpTy8s1qvgYmCBVhfo88Y8j7uKnPsye1F
	 LG9m7CBY3g0gCHqeJPqZdTxtoWV5WFWb7C00Wa9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Sperbeck <jsperbeck@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 161/215] init: open /initrd.image with O_LARGEFILE
Date: Thu, 11 Apr 2024 11:56:10 +0200
Message-ID: <20240411095429.716171781@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Sperbeck <jsperbeck@google.com>

[ Upstream commit 4624b346cf67400ef46a31771011fb798dd2f999 ]

If initrd data is larger than 2Gb, we'll eventually fail to write to the
/initrd.image file when we hit that limit, unless O_LARGEFILE is set.

Link: https://lkml.kernel.org/r/20240317221522.896040-1-jsperbeck@google.com
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/initramfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 1bc854fdf8302..b362b57c047d5 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -630,7 +630,7 @@ static void __init populate_initrd_image(char *err)
 
 	printk(KERN_INFO "rootfs image is not initramfs (%s); looks like an initrd\n",
 			err);
-	file = filp_open("/initrd.image", O_WRONLY | O_CREAT, 0700);
+	file = filp_open("/initrd.image", O_WRONLY|O_CREAT|O_LARGEFILE, 0700);
 	if (IS_ERR(file))
 		return;
 
-- 
2.43.0



