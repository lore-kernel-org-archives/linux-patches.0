Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F54E1D31A0;
	Tue,  8 Oct 2024 12:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391656; cv=none; b=ZjMP1Lly9HIDGvhPObXbWDhU1QNMwF1VxNBQTrT78IHhKTDijAJwpIRceTxO0VLYnRx9gmomqgwG/Hg3FHQ097tmgRmB5/Hkk8cSc29zxNRAr/68vbtu0MFXdgIXfV/0ykCBDhmGnl8ELUOdwdX7c1lxzdH7aVAVj1ym2d/6yfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391656; c=relaxed/simple;
	bh=AJ+GzoxOIXr8XhyMA4gqSNh+MhIUZEymRIduCftP5Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CzGunL1YipmuhiZ6wg2Llt7QfxWWdArja0g4GABB6fOICguHAYtmtTIA3FIJF01ScIYL8UzD8TEzpfDsKBVxZSRmS3Uv8uorsHASMwX0bzhC1c4gjTBOd/18l+d8KVeq6xe0PAr2R59Jke4UvnPWLK4tlpsA7E0YEC5J100EhMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0lwJ0ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0lwJ0ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D603CC4CEC7;
	Tue,  8 Oct 2024 12:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391656;
	bh=AJ+GzoxOIXr8XhyMA4gqSNh+MhIUZEymRIduCftP5Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0lwJ0obs4j763FsSR6LMDkzB7l/TWStggcgABH8TWETJXV4gdsp+O7Ndv+BGAV9J
	 p2LCElEHl+FF6nA1lPM15OXUHzBzKb2IZn9GurZ5r4L5j9sB9FLjZ2KlgoOM29LRbL
	 HkW0wW+l231RER+9VR1S7B8pnScR4JjSSKV0FwNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 184/558] tools/nolibc: powerpc: limit stack-protector workaround to GCC
Date: Tue,  8 Oct 2024 14:03:34 +0200
Message-ID: <20241008115709.593364631@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



