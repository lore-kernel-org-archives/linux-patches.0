Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA02415B0FE;
	Tue,  2 Jul 2024 17:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940461; cv=none; b=j+wOGyrEnD8YBVe8dgJGez67YwxDQhpRvEQy6pBllUJc1QZjhQAba8ZziD9FLVjr8xR5kPdMt0EtJbbeY6Fz+JuYlTthzrkMopmizEr2Dzzk1yRo7Gl8iXRDT07Vb0kXYrtaPDazAqSGVDOCoKUup6iBWVp64WlIIqMoRIQCYCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940461; c=relaxed/simple;
	bh=F2zNg4mx3DB2uyK12EgQXT7fYnIpzfOYnkzQT0UQ4IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kK/E+MK9ioiW+Nl9xkKPTWi8YZDStRNOZh2BDjIfyd1bx3nvngC3DtwianhnNSrz3Z79Ks4HeVuA6mhWh36WANpS6IuJRmw1AI0bHIQ1cKxL1gy2ga5nsJG+wrfybwxAFS7tXkAyWdG/sXg4xntSxhD2UrtV4YYNfQaWDNE/EJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2BXV/uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2BXV/uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C0DC4AF07;
	Tue,  2 Jul 2024 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940461;
	bh=F2zNg4mx3DB2uyK12EgQXT7fYnIpzfOYnkzQT0UQ4IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2BXV/uymlIsPI9wJlZg/BJLqUG98kDPSUR8TPHdVIynxbzMTGW0RScONXkAs+txL
	 vuNYdDhxPvtP2uMi6PUAszXO+v9dEvAMVSKDuCPZI5ARf79hVPCDmoziyLsouJMBIL
	 3GHcFXEtz1W+JpyckHvDr0WGiSCy4czSsOqhZahc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.9 162/222] tty: mxser: Remove __counted_by from mxser_board.ports[]
Date: Tue,  2 Jul 2024 19:03:20 +0200
Message-ID: <20240702170250.169388429@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 1c07c9be87dd3dd0634033bf08728b32465f08fb upstream.

Work for __counted_by on generic pointers in structures (not just
flexible array members) has started landing in Clang 19 (current tip of
tree). During the development of this feature, a restriction was added
to __counted_by to prevent the flexible array member's element type from
including a flexible array member itself such as:

  struct foo {
    int count;
    char buf[];
  };

  struct bar {
    int count;
    struct foo data[] __counted_by(count);
  };

because the size of data cannot be calculated with the standard array
size formula:

  sizeof(struct foo) * count

This restriction was downgraded to a warning but due to CONFIG_WERROR,
it can still break the build. The application of __counted_by on the
ports member of 'struct mxser_board' triggers this restriction,
resulting in:

  drivers/tty/mxser.c:291:2: error: 'counted_by' should not be applied to an array with element of unknown size because 'struct mxser_port' is a struct type with a flexible array member. This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
    291 |         struct mxser_port ports[] __counted_by(nports);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Remove this use of __counted_by to fix the warning/error. However,
rather than remove it altogether, leave it commented, as it may be
possible to support this in future compiler releases.

Cc:  <stable@vger.kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2026
Fixes: f34907ecca71 ("mxser: Annotate struct mxser_board with __counted_by")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/mxser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -288,7 +288,7 @@ struct mxser_board {
 	enum mxser_must_hwid must_hwid;
 	speed_t max_baud;
 
-	struct mxser_port ports[] __counted_by(nports);
+	struct mxser_port ports[] /* __counted_by(nports) */;
 };
 
 static DECLARE_BITMAP(mxser_boards, MXSER_BOARDS);


