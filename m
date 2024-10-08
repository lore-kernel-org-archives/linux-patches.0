Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094421DED60;
	Tue,  8 Oct 2024 13:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393338; cv=none; b=El3IMXy+NFezhvwOhCU9fkFxwG5rbtqNhDCvEouB+Wo/TCNe7hZvLJjn/PBtFImzUwC3QpGcdSnVjfAvcDWkb+Q2DIAYLRA/YLwke8dRmIrI7u7VnwhjNKBOgLRteC7s6H5sWvi1mQSpEimzOt7y/5dS5AEL3WUNU5/abTvlMqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393338; c=relaxed/simple;
	bh=lXTUbuTFAHa5i2GZAS7/Lv5vPtoXnIFNDPO8eOmSNQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ofqfw8ZYD6IFyuGSWp/Zn3u2frkWYrRtw0OTjVVLE8Ls9iZl4/8Ukgw8+G/iJp3hsi8hStnbXKNAGcpouQ42/SkAkhZlqfwLGAVSAHiMdD224hTHQZIOIXYdINY8Mqg4Khu9tqVRLi06afBoh1u8eCxJQC3CbL4sjCEBOg5Sh0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCFTn4j4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCFTn4j4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B51DC4CEC7;
	Tue,  8 Oct 2024 13:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393337;
	bh=lXTUbuTFAHa5i2GZAS7/Lv5vPtoXnIFNDPO8eOmSNQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCFTn4j43vJH9z+yiWBzzy5yGegNSh+TPBTDib91fb4/MiR6FNss8zNX2uvrQSvvP
	 RamXmbfakuzhHPbkVjOtR0cGyaTXoiLTwhyAVkpw58j6zIy5fK47oedCNSZXjMBJJp
	 fuw448NpybM4/uZr3hOZ2z/5+6Bp2aNy/FrapVDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/386] tools/nolibc: powerpc: limit stack-protector workaround to GCC
Date: Tue,  8 Oct 2024 14:06:05 +0200
Message-ID: <20241008115634.160521931@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 1daea158d0aae0770371f3079305a29fdb66829e ]

As mentioned in the comment, the workaround for
__attribute__((no_stack_protector)) is only necessary on GCC.
Avoid applying the workaround on clang, as clang does not recognize
__attribute__((__optimize__)) and would fail.

Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20240807-nolibc-llvm-v2-3-c20f2f5fc7c2@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-powerpc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/arch-powerpc.h b/tools/include/nolibc/arch-powerpc.h
index ac212e6185b26..41ebd394b90c7 100644
--- a/tools/include/nolibc/arch-powerpc.h
+++ b/tools/include/nolibc/arch-powerpc.h
@@ -172,7 +172,7 @@
 	_ret;                                                                \
 })
 
-#ifndef __powerpc64__
+#if !defined(__powerpc64__) && !defined(__clang__)
 /* FIXME: For 32-bit PowerPC, with newer gcc compilers (e.g. gcc 13.1.0),
  * "omit-frame-pointer" fails with __attribute__((no_stack_protector)) but
  * works with __attribute__((__optimize__("-fno-stack-protector")))
-- 
2.43.0



