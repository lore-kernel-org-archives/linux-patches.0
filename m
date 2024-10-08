Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1002A1DEFE1;
	Tue,  8 Oct 2024 12:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390045; cv=none; b=SnJKOT6a5KFIYbG4VQ9Gx5ujRcpw5hIqgGwRGfrpDonYXk+GMII3mxdT5omlJl8CnE439kmvhpCv5A08MqeLnDI3ERIo4hwW3dnZiUp1EzzxoWY5d/QcYGbr/cbj+R5325uhnebWkg43uD7ItBq7cFkPNt40SE3RcQzkAcwOgs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390045; c=relaxed/simple;
	bh=EXOodgjms/EJcfQ4a4It5WHraUhcfnTODOj4DRl+4z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPKc/YfzcCd+wmDVEcg0at7lbxz394LgHdiUT5RFAR9s0RfDwxgN8AmBZvOUtYUdoeigbtN6g9Y/KR7k6WLRrUDqg+9TMmlsmcDu37gf686S5+eMiBAbOBi+Sig1txQmjLjChKB1Bpc4RsJ38M6DQq+QBPPxYF9ak/Lz6/kC4CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhPafhr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhPafhr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7566AC4CEC7;
	Tue,  8 Oct 2024 12:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390044;
	bh=EXOodgjms/EJcfQ4a4It5WHraUhcfnTODOj4DRl+4z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhPafhr6ZtrZ817IJg/+TnP/T285KItXNTrKa0AbBCpyHeNvRrUdW/e9iHzh9D0na
	 cd26/O8TowB3k4LzwlDue0/ryFUW/gs8tE+fi/lYee9xxOmdImrm8ayqKY/sxftdE9
	 VMr5qAYG3n4Bl5S1e+aoTMfwB4QdAUsGGfpBUsOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 156/482] tools/nolibc: powerpc: limit stack-protector workaround to GCC
Date: Tue,  8 Oct 2024 14:03:39 +0200
Message-ID: <20241008115654.445934050@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



