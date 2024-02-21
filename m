Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4517BAE5;
	Wed, 21 Feb 2024 13:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523717; cv=none; b=Mte+JHoFBWezoJEJCR/2EJ5h4aMfwW56+JOGvrJR4Inb+RKlbMRSxB3cu5wYqgBBETK1oSgkQR5+N8EYBFmvkDiff267O6+ItDH7ec4lTcFxnCT4JJBzUQh2XKnzsmaryXA7iZxfenOGNpgKCv9RSxEFuZS1cyv+InRjgfgEkf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523717; c=relaxed/simple;
	bh=jBT721L1q76VdZN5RJeI2EbDyvAA4BzaT8QVaM4m1wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vdl2jUr6bKLLyk029hz++76N7EC+lnypjcD4aeZP8IoyaUprV7TurE9HJ/1XzGKVWRkXu+mOfX7aynAxzEgLoy/5NBlwAxIa5ZlZNIiDjQDj8bayXXYV9U52kFBE0eqtTl1C472zYQYwpjevg8oqXYVJeQ/cXQRbejKcnoEqhqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ny9Ew/GI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ny9Ew/GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3B8C433F1;
	Wed, 21 Feb 2024 13:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523717;
	bh=jBT721L1q76VdZN5RJeI2EbDyvAA4BzaT8QVaM4m1wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ny9Ew/GIjLUOPrA9ech0XWuWgqmtzlBA+0Fc8wWbv6ohed3r0KMiuFatXDxNp5um+
	 3RSCW3wt2IuL5iyZ7v9o2xLyx8AWZWYbflrC7uWpeFi09TRrU6lGHrBx4fJujS9TRd
	 sPuCt2iKoe1X+xBXEuxt9ENLXX3izZtAKr+LKgc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.10 030/379] scripts/get_abi: fix source path leak
Date: Wed, 21 Feb 2024 14:03:29 +0100
Message-ID: <20240221125955.809384014@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vegard Nossum <vegard.nossum@oracle.com>

commit 5889d6ede53bc17252f79c142387e007224aa554 upstream.

The code currently leaks the absolute path of the ABI files into the
rendered documentation.

There exists code to prevent this, but it is not effective when an
absolute path is passed, which it is when $srctree is used.

I consider this to be a minimal, stop-gap fix; a better fix would strip
off the actual prefix instead of hacking it off with a regex.

Link: https://mastodon.social/@vegard/111677490643495163
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20231231235959.3342928-1-vegard.nossum@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/get_abi.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/get_abi.pl
+++ b/scripts/get_abi.pl
@@ -75,7 +75,7 @@ sub parse_abi {
 	$name =~ s,.*/,,;
 
 	my $fn = $file;
-	$fn =~ s,Documentation/ABI/,,;
+	$fn =~ s,.*Documentation/ABI/,,;
 
 	my $nametag = "File $fn";
 	$data{$nametag}->{what} = "File $name";


