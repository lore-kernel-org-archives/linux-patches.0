Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE641E534;
	Tue, 27 Feb 2024 13:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040928; cv=none; b=uHEjq7N2PrO9dO7VTXMa3CTo+Zcra7soeC9Jof9UehP6r7JQbGo3ai8SjISz/0XytshGXDiX/ZMTx9P2tGEISUsvfPIEUUdxTKCWD7RtulUTr0vUChDqVkZsfTl3t1L1KGmxqt3ByuouLZjMbX9ILNgGj2FfbZem7MVAiY3Oo9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040928; c=relaxed/simple;
	bh=nDdQxvZakzCbX7IAS2T2bVx0A8F2422u7dwfRekeEEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gShhY7IjpUj2jM1c5vD+XqW35LQ/CJsEeSK+Rnz7F9N3qgpGiAhTcvGooqnRkVhKrt+IKSXHt0dB5XWeckgILuuIvtTWsmHs0KX7nntfB86TaHcSgYlg2AQsOFPfXmwwvkOAQ6LvnAc6OeYExZrig+YKmRsrQui9GgXmnWnMovU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M98AJ4i4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M98AJ4i4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC871C433C7;
	Tue, 27 Feb 2024 13:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040928;
	bh=nDdQxvZakzCbX7IAS2T2bVx0A8F2422u7dwfRekeEEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M98AJ4i4kVsrNCmvLgtP6KzGk8wNuY/8V2OGi37m29yz3p5LyEKIHRP6h+KNc78Nf
	 p8TZzPiE8pSCFFImVinGofTKEul1iwFRBmgq2tEOqVkBQhVV/lqlWygYvf6qNxil3k
	 Oqt1aiUV5OowSofKqUy4FSygZxrwMvlGKx9SoJvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 158/334] lib/Kconfig.debug: TEST_IOV_ITER depends on MMU
Date: Tue, 27 Feb 2024 14:20:16 +0100
Message-ID: <20240227131635.569793808@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 1eb1e984379e2da04361763f66eec90dd75cf63e upstream.

Trying to run the iov_iter unit test on a nommu system such as the qemu
kc705-nommu emulation results in a crash.

    KTAP version 1
    # Subtest: iov_iter
    # module: kunit_iov_iter
    1..9
BUG: failure at mm/nommu.c:318/vmap()!
Kernel panic - not syncing: BUG!

The test calls vmap() directly, but vmap() is not supported on nommu
systems, causing the crash.  TEST_IOV_ITER therefore needs to depend on
MMU.

Link: https://lkml.kernel.org/r/20240208153010.1439753-1-linux@roeck-us.net
Fixes: 2d71340ff1d4 ("iov_iter: Kunit tests for copying to/from an iterator")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2234,6 +2234,7 @@ config TEST_DIV64
 config TEST_IOV_ITER
 	tristate "Test iov_iter operation" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	depends on MMU
 	default KUNIT_ALL_TESTS
 	help
 	  Enable this to turn on testing of the operation of the I/O iterator


