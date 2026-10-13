Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA6A4F7988;
	Tue, 13 Oct 2026 12:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895825; cv=none; b=TQU07I85l7RgxISPpC6JveOeIxbNFQ1kCGWVjR+EnXNd+CHiWyiwYg63HBbyP/JugIReE8PP2BrVTpUM1Vgv94xACDuYg9gShxLZ4qppJwhty5Mgaejwv8t+Oy/JihwXu+jyjiViRBixwbQrHyvjaitEwPDGNAIZ+pH/BTR3LEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895825; c=relaxed/simple;
	bh=NNzfllju6LWkb9stZRPm1rRGpKYNIs60NjMRJ0thIxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaXkncY+FMnbnsPj0osQn6NcvNm09GfZZ9GJb/jx0JzVuQ9AetMoNCIdddPg61IIwa2LcqqcWsOY0mvt6/hasThh0TIuRMemMZzvA37M0A8l6egUnAU6AjQXyJITcZ81LE0x0QNTJP9gbY7C1uM5RCiknCxOWYoBSfwWWQbymdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=En7gTgm9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="En7gTgm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AEE1F00899;
	Tue, 13 Oct 2026 12:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895824;
	bh=DoUxPD0ozLfzMulV2BtPXxdazVYUzwSfJRyhw+X4Y1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=En7gTgm9glBUtCWm3qU3TcZzJzXbr+PCycNAn1hAbd4QRumV67HtCZk8nnDmcL2qb
	 ai5WQ3hH5+AhhSEYbHOD9MdxbJmX+Qw8kFBb1O/wO6Ic0TlxKFKCrCbik6Ia3bFvQ7
	 TR/5qUJ/NYDMvsrmTPSROAY/AdCVVYmQ8A4CBOgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 404/497] net: sparx5: free the matchall entry on destroy
Date: Tue, 13 Oct 2026 13:39:31 +0200
Message-ID: <20261013112917.480238603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

commit 2b82e16d6084cbc651e3c902198f1945408ee1a5 upstream.

sparx5_tc_matchall_replace() allocates a struct sparx5_mall_entry for
every offloaded matchall filter and adds it to sparx5->mall_entries.
sparx5_tc_matchall_destroy() removes the entry from the list, but never
frees it, so the entry of every deleted mirror and goto matchall filter
is leaked.

Free the entry after unlinking it.

The leak was discovered by an AI code review agent, and reproduced with
kmemleak on a lan969x EV board (EV23X71A) by repeatedly adding and
deleting matchall mirror and goto filters. With the fix, kmemleak no
longer reports the leak.

Cc: stable@vger.kernel.org
Fixes: 1ede4acf045c ("net: sparx5: add bookkeeping code for matchall rules")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261007-sparx5-matchall-kfree-net-v1-1-c8918685b337@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c
@@ -160,6 +160,7 @@ static int sparx5_tc_matchall_destroy(st
 	}
 
 	list_del(&entry->list);
+	kfree(entry);
 
 	return err;
 }


