Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E41F1FE44A;
	Thu, 30 Jul 2026 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423058; cv=none; b=swz8mI2ZcM2RBpVrmDJLqWmAubZ/xW2F3zJMn1JD0OC4gbRIv8LsXDP+gpvprvOuM+UCCal0l52rVCSoEOonvNjSLyM6QhRSUYNBQyH3EkX1gRmQ93J4ZiYQ7dP4Hriq84pBoxgPy9a6cQh0RYW63msEMWXd+gJB/MlHYP8BMC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423058; c=relaxed/simple;
	bh=kJDNFDQiupU58DZaeSF2zdg7xW8wEvlDIwiIPOgawHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ck9vuZjUpaseu641k3E0kY5oYakS9XWD9kdvmwMT/IxwmJ8163OlDlqXyOGN97LpxuDPXL3bSJiSOREvwmbLUn0JtfyeUE8DVmZoCRermGVQKLo+PetXDSzqtf2xB0F3bHlRJU4/wIRPP8RTe8c4IX78JrLjzKIEd6l+u5cQ+64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AB8tXYa7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AB8tXYa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692691F000E9;
	Thu, 30 Jul 2026 14:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423056;
	bh=xhkxXXuOc5vMrA+3gD+uyHLRXVW9XxKWZbD/kGsM80M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AB8tXYa7l5k+mOGQRiTw+yu0Pq7FxSwQH91zjfqTjWAXD3Tkznbr2vA1QHSgZeiF2
	 KQ5jwqrzeciTYJs0biDXR1QkCooMQlA6/s2KLKEEGx7zk74FmVrnCZ5LfYiq5jSsOl
	 TQ7xOsC31S871jCJGCYCvCxSh38TEWT8PCxrYw/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Ranner <frank.ranner@intel.com>,
	kernel test robot <lkp@intel.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 607/744] mptcp: fix BUILD_BUG_ON on legacy ARM config
Date: Thu, 30 Jul 2026 16:14:40 +0200
Message-ID: <20260730141457.176159318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 133cca19d75b9264bc2bbcdf2c3b80e3da207649 upstream.

The 0-day bot managed to find kernel configs that cause build failures,
e.g. when using the StrongARM SA1100 target (ARMv4).

On such legacy ARM architecture, all structures are apparently aligned
to 32 bits, causing build issue here. Indeed, on such architecture,
'flags' size is not equivalent to sizeof(u16) as expected, but to
sizeof(u32).

Instead, use memset(). It was not used before to ensure a simple clear
operation was used by the compiler. But at the end, it shouldn't matter,
and the compiler should optimise this to the same operation with or
without memset() when -O above 0 is used. So let's switch to memset() to
fix this issue, and reduce this complexity.

Fixes: 5e939544f9d2 ("mptcp: fix uninit-value in mptcp_established_options")
Cc: stable@vger.kernel.org
Suggested-by: Frank Ranner <frank.ranner@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605312026.Srgsz7Tp-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202607031100.upQfRZTM-lkp@intel.com/
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260722-net-mptcp-misc-fixes-7-2-rc5-v1-5-6fb595bc86ef@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -573,10 +573,7 @@ static bool mptcp_established_options_ds
 	bool ret = false;
 
 	/* Zero `use_ack` and `use_map` flags with one shot. */
-	BUILD_BUG_ON(sizeof_field(struct mptcp_ext, flags) != sizeof(u16));
-	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct mptcp_ext, flags),
-				 sizeof(u16)));
-	*(u16 *)&opts->ext_copy.flags = 0;
+	memset(&opts->ext_copy.flags, 0, sizeof(opts->ext_copy.flags));
 	opts->csum_reqd = READ_ONCE(msk->csum_enabled);
 	mpext = skb ? mptcp_get_ext(skb) : NULL;
 


