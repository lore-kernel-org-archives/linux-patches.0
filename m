Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2C74F68B1;
	Tue, 13 Oct 2026 12:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893009; cv=none; b=t8Fi6X3/YYx3F9WQsKXRgLww5LEae5R/nLVF9/mktyjDe3l5jtD3sGjrjqCJ+HpV7ictR2O1tdrgUid7jUAykKUUk9fx58aWkR3dRhMh6Vwt9YFLW8X4d01OEzgJ3YKhXzMKpPJIkXU7wLxFKTL5jqJT2n9ywogJWZR7FVybKsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893009; c=relaxed/simple;
	bh=9yv1g2oHqm5ZwnnZRL3Eu+YvI2xKjoVau7rN1pcGcn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltNzukZmEkDUQ/wqxU1Yk64aGkKHqy7AcIplbUPWkWqigb5ZXtd0Ppt+0HvQ+M1PP+6V4TlJB9isfYnechTPlHqd6trj1yR0Ctg/fsNwk1jf5qm/Tn8suaBfmxgcYWjflPh9GgvL8tNEWw0m7FbX4ovyDjiJGEyfSmOmCDQGXt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeocPBJh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeocPBJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAB61F00893;
	Tue, 13 Oct 2026 12:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893008;
	bh=ovFYBqkhiV4ad0/D3NewfJg9BrHY+JP+AV6ghHlSiOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HeocPBJhAuyLQzo7theQCG2KWlpfHVymgFxS9ErrCzw6PepR12oNeFhCWLyjA+mir
	 5iTJTMAta9tZ1p4jsDeTJKsQHBDTiCPiGQU3mcNTLLSeDMMSFeq7RkBEra9dO1JrV7
	 bmMSKTqw19NawP7e0ERh5wNXZLdey3ExlZwf4bLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 082/621] net: sparx5: free the matchall entry on destroy
Date: Tue, 13 Oct 2026 13:31:17 +0200
Message-ID: <20261013112922.801749339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


